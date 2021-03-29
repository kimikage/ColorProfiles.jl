"""
    read_icc_profile(filepath::AbstractString; kwargs...) -> ICCProfile
    read_icc_profile(io::IO; kwargs...) -> ICCProfile

Read an ICC profile from a file or IO.
"""
function read_icc_profile(filepath::AbstractString; kwargs...)
    open(filepath, "r") do f
        return read_icc_profile(f, kwargs...)
    end
end

function read_icc_profile(io::IO; kwargs...)
    header = read_icc_header(io)
    table = read_icc_tag_table(io; version = header.version)
    return ICCProfile(header, table)
end

"""
    read_icc_profile_in_jpeg(io::IO) -> ICCProfile

Read an ICC profile embedded in a JPEG (JFIF) file.
"""
function read_icc_profile_in_jpeg(filename::AbstractString)
    open(filename, "r") do f
        return read_icc_profile_in_jpeg(f)
    end
end
function read_icc_profile_in_jpeg(io::IO)
    function seek_to_profile(io)
        id = b"ICC_PROFILE\0"
        while true
            b1 = read_u8(io)
            b1 === 0xff || continue
            b2 = read_u8(io)
            b2 === 0xe2 || continue # APP2 0xFFE2
            seg_size = read_u16(io)
            read(io, length(id)) == id || continue
            count = read_u16(io)
            return seg_size - length(id) - 4
        end
    end
    seg_size = seek_to_profile(io)
    header = read_header(io)
    seg_size -= ICC_HEADER_SIZE

    data_size = header.profile_size - ICC_HEADER_SIZE
    buf = IOBuffer(maxsize = data_size)
    n = data_size
    while true
        write(buf, read(io, min(n, seg_size)))
        n -= seg_size
        n <= 0 && break
        seg_size = seek_to_profile(io)
    end
    seek(buf, 0)
    table = read_tag_table(buf, header.version)
    return ICCProfile(header, table)
end

function detect_icc_header(io)
    seek(io, ICC_HEADER_SIZE)
    position(io) == ICC_HEADER_SIZE || return false
    seek(io, 36)
    return read_sig(io) === ICC_MAGIC_NUMBER
end

function validate_required_tags(profile::ICCProfile)
    class = profile.header.profile_class
    pcs = profile.header.pcs
    cs = profile.header.color_space
    sigs = signature.(profile.table.tags)
    local isvalid = true
    function w(msg)
        @warn(msg)
        isvalid = false
    end
    sig"desc" in sigs || w("`ProfileDescriptionTag` not found")
    sig"cprt" in sigs || w("`CopyrightTag` not found")
    sig"wtpt" in sigs || class === DeviceLinkClass || w("`MediaWhitePointTag` not found")
    if class === InputClass
        if pcs !== XYZSpace && cs !== GraySpace
            sig"A2B0" in sigs || w("`AToB0Tag` not found")
        end
        if pcs === XYZSpace && !(sig"A2B0" in sigs) && cs === RGBSpace
            isvalid = _validate_required_matrix_based_tags(sigs)
        end
        if cs === GraySpace
            sig"kTRC" in sigs || w("`GrayTRCTag` not found")
        end
    elseif class === DisplayClass
        if pcs !== XYZSpace && cs !== GraySpace
            sig"A2B0" in sigs || w("`AToB0Tag` not found")
            sig"B2A0" in sigs || w("`BToA0Tag` not found")
        end
        if pcs === XYZSpace && !(sig"A2B0" in sigs) && cs === RGBSpace
            isvalid = _validate_required_matrix_based_tags(sigs)
        end
        if cs === GraySpace
            sig"kTRC" in sigs || w("`GrayTRCTag` not found")
        end
    elseif class === OutputClass
        if cs !== GraySpace
            sig"A2B0" in sigs || w("`AToB0Tag` not found")
            sig"A2B1" in sigs || w("`AToB1Tag` not found")
            sig"A2B2" in sigs || w("`AToB2Tag` not found")
            sig"B2A0" in sigs || w("`BToA0Tag` not found")
            sig"B2A1" in sigs || w("`BToA0Tag` not found")
            sig"B2A2" in sigs || w("`BToA0Tag` not found")
            sig"gamt" in sigs || w("`gamutTag` not found")
        else
            sig"kTRC" in sigs || w("`GrayTRCTag` not found")
        end
    elseif class === DeviceLinkClass
        sig"pseq" in sigs || w("`ProfileSequenceDescTag` not found")
        sig"A2B0" in sigs || w("`AToB0Tag` not found")
    elseif class === ColorSpaceClass
        sig"A2B0" in sigs || w("`AToB0Tag` not found")
        sig"B2A0" in sigs || w("`BToA0Tag` not found")
    elseif class === AbstractClass
        sig"A2B0" in sigs || w("`AToB0Tag` not found")
    elseif class === NamedColorClass
        sig"ncl2" in sigs || w("`NamedColor2Tag` not found")
    end
    return isvalid
end

function _validate_required_matrix_based_tags(sigs)
    local isvalid = true
    function w(msg)
        @warn(msg)
        isvalid = false
    end
    sig"rXYZ" in sigs || w("`RedMatrixColumnTag` not found")
    sig"gXYZ" in sigs || w("`GreenMatrixColumnTag` not found")
    sig"bXYZ" in sigs || w("`BlueMatrixColumnTag` not found")
    sig"rTRC" in sigs || w("`RedTRCTag` not found")
    sig"gTRC" in sigs || w("`GreenTRCTag` not found")
    sig"bTRC" in sigs || w("`BlueTRCTag` not found")
    return isvalid
end

function update!(profile::ICCProfile;
                 version::VersionNumber = profile.header.version,
                 datetime::DateTime = prifile.header.datetime)
    header = profile.header
    header.version = version
    header.datetime = datetime

    update!(profile.table, version = version)

    profile.header.profile_size = rawsize(profile.header) + rawsize(profile.table)
end
