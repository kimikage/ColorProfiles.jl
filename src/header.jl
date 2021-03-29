
const ICC_MAGIC_NUMBER = sig"acsp"
const ICC_HEADER_SIZE = 128
const ICC_VERSION = v"4.4.0" # latest version supported by this package

mutable struct ICCProfileHeader
    profile_size::UInt32
    cmm_type::CMMType
    version::VersionNumber
    profile_class::ProfileClass
    color_space::ColorSpace
    pcs::ColorSpace
    datetime::DateTime
    magic::Signature
    platform::Platform
    flags::UInt32
    manufacturer::Manufacturer
    model::DeviceModel
    attribute::UInt64
    intent::RenderingIntent
    illuminant::XYZ{Float64}
    creator::Manufacturer
    id::UInt128
end

function ICCProfileHeader(;
                          profile_size = zero(UInt32),
                          cmm_type = CMMType(),
                          version = ICC_VERSION,
                          profile_class = AbstractClass,
                          color_space = XYZSpace,
                          pcs = XYZSpace,
                          datetime = now(UTC),
                          magic = ICC_MAGIC_NUMBER,
                          platform = Platform(),
                          flags = zero(UInt32),
                          manufacturer = Manufacturer(),
                          model = DeviceModel(),
                          attribute = zero(UInt64),
                          intent = Perceptual,
                          illuminant = WP_ICC,
                          creator = Manufacturer(),
                          id = zero(UInt128))
    ICCProfileHeader(profile_size, cmm_type, version, profile_class, color_space, pcs,
                     datetime, magic, platform, flags, manufacturer, model, attribute,
                     intent, illuminant, creator, id)
end

embedded_in_file(header::ICCProfileHeader) = !iszero(header.flags & 0x1)
function embedded_in_file(header::ICCProfileHeader, conf::Bool)
    header.flags = header.flags & ~UInt32(0x1) | conf
    return conf
end
function use_with_embedded_data_only(header::ICCProfileHeader)
    !iszero(header.flags & 0x2)
end
function use_with_embedded_data_only(header::ICCProfileHeader, conf::Bool)
    header.flags = header.flags & ~UInt32(0x1) | conf << 0x1
    return conf
end

rawsize(::ICCProfileHeader) = ICC_HEADER_SIZE

function read_icc_header(io::IO)
    profile_size = read_u32(io)
    profile_size < UInt32(128 + 4) && error("invalid profile size")
    cmm_type = CMMType{read_sig(io)}()
    ver32 = read_u32(io)
    version = VersionNumber(ver32 >> 0x18, (ver32 >> 0x14) & 0xf, (ver32 >> 0x10) & 0xf)
    profile_class = ProfileClass{read_sig(io)}()
    color_space = ColorSpace{read_sig(io)}()
    pcs = ColorSpace{read_sig(io)}()
    datetime = read_datetime(io)
    magic = read_sig(io)
    magic === ICC_MAGIC_NUMBER || error("invalid magic number: $(typeof(magic))")
    platform = Platform{read_sig(io)}()
    flags = read_u32(io)
    manufacturer = Manufacturer{read_sig(io)}()
    model = DeviceModel{read_sig(io)}()
    attribute = read_u64(io)
    intent = RenderingIntent{read_u32(io)}()
    illuminant = read_xyz(io)
    creator = Manufacturer{read_sig(io)}()
    id = read_u128(io)
    read(io, 28) # reserved
    ICCProfileHeader(profile_size, cmm_type, version, profile_class, color_space, pcs,
                     datetime, magic, platform, flags, manufacturer, model, attribute,
                     intent, illuminant, creator, id)
end

function write_icc_header(io::IO, header::ICCProfileHeader)
    write_u32(io, header.profile_size)
    write_sig(io, header.cmm_type)
    version = header.version
    ver32 = UInt32(version.major & 0xff) << 0x18 |
            UInt32(version.minor & 0x0f) << 0x14 |
            UInt32(version.patch & 0x0f) << 0x10
    write_u32(io, ver32)
    write_sig(io, header.profile_class)
    write_sig(io, header.color_space)
    write_sig(io, header.pcs)
    write_datetime(io, header.datetime)
    header.magic === ICC_MAGIC_NUMBER || @warn("invalid magic number: $(typeof(magic))")
    write_sig(io, header.magic)
    write_sig(io, header.platform)
    write_u32(io, header.flags)
    write_sig(io, header.manufacturer)
    write_sig(io, header.model)
    write_u64(io, header.attribute)
    write_u32(io, header.intent)
    write_xyz(io, header.illuminant)
    write_sig(io, header.creator)
    write_u128(io, header.id)
    write(io, ntuple(_ -> 0x00, 28))
    return ICC_HEADER_SIZE
end
