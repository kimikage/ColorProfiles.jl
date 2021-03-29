module TaggedTypes

using Dates
using FixedPointNumbers
using ColorTypes

using ..ColorProfiles.StandardIlluminants

using ..ColorProfiles: UQ16f16, Signature, @sig_str, @sigtype_str
using ..ColorProfiles: read_u8, read_u16, read_u32, read_s32, read_q15f16
using ..ColorProfiles: read_sig, read_xyz, read_ascii, read_utf16be, read_datetime
using ..ColorProfiles: read_u16_3x3, read_q15f16_3x3

export AbstractTaggedData, UnknownTaggedData
export Chromaticity
export ColorantOrder
export ColorantTable
export Curve
export TaggedData # dataType
export TaggedDateTime # dateTimeType
export Dictionary
export LUT16
export LUT8
export LUTAToB
export LUTBToA
export Measurement
export MultiLocalizedUnicode, MLURecord
export MultiProcessElements
export ParametricCurve
export TaggedSignature # signatureType
export TaggedText # textType
export TextDescription
export ViewingConditions
export TaggedXYZ # xyzType

export read_tagged_data

abstract type AbstractTaggedData{sig} end

signature(::Type{<:AbstractTaggedData{sig}}) where {sig} = sig

read_tagged_data(io::IO, size, version) = _read_tagged_data(io, read_sig(io), size, version)

struct UnknownTaggedData{sig} <: AbstractTaggedData{sig}
    raw::Vector{UInt8}
end

function _read_tagged_data(io::IO, sig::Signature, size, ver)
    if size < 4
        error("size unknown")
    end
    return UnknownTaggedData{sig}(read(io, size - 4))
end

abstract type AbstractCurve{sig} <: AbstractTaggedData{sig} end

abstract type AbstractLUT{sig, Ni, No} <: AbstractTaggedData{sig} end

"""
    TaggedTypes.Chromaticity

"""
struct Chromaticity <: AbstractTaggedData{sig"chrm"}
    colorant::UInt16
    xy::Vector{NTuple{2, Float64}}
end

function _read_tagged_data(io::IO, ::S, size, ver) where {S <: sigtype"chrm"}
    read_u32(io)
    n = read_u16(io)
    colorant = read_u16(io)
    xy = Vector{NTuple{2, Float64}}(undef, n)
    for i in eachindex(xy)
        x = Float64(read_q15f16(io))
        y = Float64(read_q15f16(io))
        xy[i] = (x, y)
    end
    return Chromaticity(colorant, xy)
end

"""
    TaggedTypes.ColorantOrder
"""
struct ColorantOrder <: AbstractTaggedData{sig"clro"}
    order::Vector{UInt8}
end

function _read_tagged_data(io::IO, ::S, size, ver) where {S <: sigtype"clro"}
    read_u32(io)
    n = read_u32(io)
    order = read(io, n)
    return ColorantOrder(order)
end

"""
    TaggedTypes.ColorantTable
"""
struct ColorantTable end

"""
    TaggedTypes.Curve


"""
struct Curve <: AbstractCurve{sig"curv"}
    curve::Vector{UInt16}
end

function _read_tagged_data(io::IO, ::S, size, ver) where {S <: sigtype"curv"}
    read_u32(io) # reserved
    n = read_u32(io)
    curve = [read_u16(io) for _ in 1:n]
    isodd(n) && read_u16(io) # padding
    return Curve(curve)
end

"""
    TaggedTypes.ParametricCurve{func, N}

`func` is a `UInt16` number specifying the function type.
`N` is a `Int` number specifying the number of function parameters.

## Fields
- `params::NTuple{N, Float64}`

## Specific Curves
- [`ParametricCurve0`](@ref)
- [`ParametricCurve1`](@ref)
- [`ParametricCurve2`](@ref)
- [`ParametricCurve3`](@ref)
- [`ParametricCurve4`](@ref)
"""
struct ParametricCurve{func, N} <: AbstractCurve{sig"para"}
    params::NTuple{N, Float64}
end

"""
    TaggedTypes.ParametricCurve0

`ParametricCurve0` represents the following function with one parameter: `g`.
```julia
g = (curve::ParametricCurve0).params

y(x) = x ^ g
```
"""
const ParametricCurve0 = ParametricCurve{0x0000, 1}

"""
    TaggedTypes.ParametricCurve1

`ParametricCurve1` represents the following function with three parameters: `g`,
`a`, `b`.
```julia
g, a, b = (curve::ParametricCurve1).params

y(x) = a * x + b >= 0 ? (a * x + b) ^ g : 0
```
"""
const ParametricCurve1 = ParametricCurve{0x0001, 3}

"""
    TaggedTypes.ParametricCurve2

`ParametricCurve2` represents the following function with four parameters: `g`,
`a`, `b`, `c`.
```julia
g, a, b, c = (curve::ParametricCurve2).params

y(x) = a * x + b >= 0 ? (a * x + b) ^ g + c : c
```
"""
const ParametricCurve2 = ParametricCurve{0x0002, 4}

"""
    TaggedTypes.ParametricCurve3

`ParametricCurve3` represents the following function with five parameters: `g`,
`a`, `b`, `c`, `d`.
```julia
g, a, b, c, d = (curve::ParametricCurve3).params

y(x) = x >= d ? (a * x + b) ^ g : c * x
```
This type of curve is used in IEC 61966-2.1 (sRGB).
"""
const ParametricCurve3 = ParametricCurve{0x0003, 5}

"""
    TaggedTypes.ParametricCurve4

`ParametricCurve4` represents the following function with seven parameters: `g`,
`a`, `b`, `c`, `d`, `e`, `f`.
```julia
g, a, b, c, d = (curve::ParametricCurve4).params

y(x) = x >= d ? (a * x + b) ^ g + e : c * x + f
```
"""
const ParametricCurve4 = ParametricCurve{0x0004, 7}

function _read_tagged_data(io::IO, ::S, size, ver) where {S <: sigtype"para"}
    read_u32(io) # reserved
    func = read_u16(io)
    read_u16(io) # reserved
    Ns = (1, 3, 4, 5, 7)
    if func > 0x0004
        if ver <= ICC_ver
            error("invalid parametric curve function: $(repr(func))")
        else # unknown ver.
            @warn("unknown parametric curve function: $(repr(func))")
        end
        iszero(size) && error("size unknown")
        N::Int = (size - 8) ÷ 4
    else
        N = Ns[func + 1]
    end
    if !iszero(size)
        _check_size(size, N * 4 + 8)
    end
    params = ntuple(_ -> Float64(read_q15f16(io)), N)
    return ParametricCurve{func, N}(params)
end

struct TaggedData <: AbstractTaggedData{sig"data"}
    flags::UInt32
    data::Vector{UInt8}
end

function _read_tagged_data(io::IO, ::S, size, ver) where {S <: sigtype"data"}
    read_u32(io)
    flags = read_u32(io)
    return TaggedData(flags, read(io, size - 12))
end

"""
    TaggedTypes.TaggedDateTime

`dateTimeType`
"""
struct TaggedDateTime <: AbstractTaggedData{sig"dtim"}
    datetime::DateTime
end

function _read_tagged_data(io::IO, ::S, size, ver) where {S <: sigtype"dtim"}
    read_u32(io) # reserved
    return TaggedDateTime(read_datetime(io))
end

struct Dictionary <: AbstractTaggedData{sig"dict"} end

"""
    TaggedTypes.LUT16{Ni, No}

`lut16Type`
"""
struct LUT16{Ni, No} <: AbstractLUT{sig"mft2", Ni, No}
    mat::Matrix{Float64}
    input_tables::NTuple{Ni, Vector{UInt16}}
    clut::Array{NTuple{No, UInt16}, Ni}
    output_tables::NTuple{No, Vector{UInt16}}
end

"""
    TaggedTypes.LUT8

`lut8Type`
"""
struct LUT8{Ni, No} <: AbstractLUT{sig"mft1", Ni, No}
    mat::Matrix{Float64}
    input_curves::NTuple{Ni, Vector{UInt8}}
    clut::Array{NTuple{No, UInt8}, Ni}
    output_curves::NTuple{No, Vector{UInt8}}
end

function _read_tagged_data(io::IO, ::S, size,
                           ver) where {S <: Union{sigtype"mft1", sigtype"mft2"}}
    T = S === sigtype"mft1" ? UInt8 : UInt16
    read_u32(io) # reserved
    Ni = Int(read_u8(io))
    No = Int(read_u8(io))
    Ng = Int(read_u8(io))
    read_u8(io) # reserved
    mat = read_q15f16_3x3(io)
    read_u = S === sigtype"mft1" ? read_u8 : read_u16
    n = S === sigtype"mft1" ? 256 : Int(read_u16(io))
    m = S === sigtype"mft1" ? 256 : Int(read_u16(io))
    input_curves = ntuple(_ -> Vector{UInt16}(undef, n), Ni)
    output_curves = ntuple(_ -> Vector{UInt16}(undef, m), No)
    clut = Array{NTuple{No, T}}(undef, ntuple(_ -> Ng, Ni))
    clutp = PermutedDimsArray(clut, Ni:-1:1)
    for t in input_curves, i in 1:n
        @inbounds t[i] = read_u(io)
    end
    for I in CartesianIndices(clutp)
        @inbounds clutp[I] = ntuple(_ -> read_u(io), No)
    end
    for t in output_curves, i in 1:m
        @inbounds t[i] = read_u(io)
    end
    LUT = S === sigtype"mft1" ? LUT8{Ni, No} : LUT16{Ni, No}
    return LUT(mat, input_curves, clut, output_curves)
end

"""
    TaggedTypes.LUTAToB

# Fields
- `mat::Matrix{Float64}`
- `vec::NTuple{3, Float64}` # translation vector
"""
struct LUTAToB{Ni, No} <: AbstractLUT{sig"mAB ", Ni, No}
    bcurves::NTuple{No, Union{Curve, ParametricCurve}}
    mat::Matrix{Float64}
    vec::NTuple{3, Float64}
    mcurves::NTuple{Ni, Union{Curve, ParametricCurve}}
    clut::Union{Array{NTuple{No, UInt8}, Ni}, Array{NTuple{No, UInt16}, Ni}}
    acurves::NTuple{Ni, Union{Curve, ParametricCurve}}
end

"""
    TaggedTypes.LUTBToA


See [`LUTAToB`](@ref)
"""
struct LUTBToA{Ni, No} <: AbstractLUT{sig"mBA ", Ni, No}
    bcurves::NTuple{Ni, Union{Curve, ParametricCurve}}
    mat::Matrix{Float64}
    vec::NTuple{3, Float64}
    mcurves::NTuple{Ni, Union{Curve, ParametricCurve}}
    clut::Union{Array{NTuple{No, UInt8}, Ni}, Array{NTuple{No, UInt16}, Ni}}
    acurves::NTuple{No, Union{Curve, ParametricCurve}}
end

function _read_tagged_data(io::IO, ::S, size,
                           ver) where {S <: Union{sigtype"mAB ", sigtype"mBA "}}
    pos = position(io) - 4
    read_u32(io) # reserved
    Ni = Int(read_u8(io))
    No = Int(read_u8(io))
    read_u16(io) # reserved
    LUT = S === sigtype"mAB " ? LUTAToB{Ni, No} : LUTBToA{Ni, No}
    Na = S === sigtype"mAB " ? Ni : No
    Nb = S === sigtype"mAB " ? No : Ni
    offset_bcurves = read_u32(io)
    offset_mat = read_u32(io)
    offset_mcurves = read_u32(io)
    offset_clut = read_u32(io)
    offset_acurves = read_u32(io)
    if iszero(offset_bcurves)
        bcurves = ntuple(_ -> Curve(UInt16[]), Nb)
    else
        seek(io, pos + offset_bcurves)
        bcurves = ntuple(_ -> _read_curve(io, ver), Nb)
    end
    if iszero(offset_mat)
        mat = Float64[]
        vec = (0.0, 0.0, 0.0)
    else
        seek(io, pos + offset_mat)
        mat = read_u16_3x3(io)
        vec = ntuple(_ -> Float64(read_u16(io)), Val(3))
    end
    if iszero(offset_mcurves)
        mcurves = ntuple(_ -> Curve(UInt16[]), Nb)
    else
        seek(io, pos + offset_mcurves)
        mcurves = ntuple(_ -> _read_curve(io, ver), Nb)
    end
    if iszero(offset_clut)
        clut = Array{NTuple{No, UInt8}, Ni}(undef, ntuple(_ -> 0, Ni))
    else
        seek(io, pos + offset_clut)
        dims = ntuple(_ -> Int(read_u8(io)), Ni)
        read(io, 16 - Ni) # unused
        T = read_u8(io) === 0x02 ? UInt16 : UInt8
        read(io, 3) # reserved
        read_u = T === UInt16 ? read_u16 : read_u8
        clut = Array{NTuple{No, T}, Ni}(undef, dims)
        clutp = PermutedDimsArray(clut, Ni:-1:1)
        for I in CartesianIndices(clutp)
            @inbounds clutp[I] = ntuple(_ -> read_u(io), No)
        end
    end
    if iszero(offset_acurves)
        acurves = ntuple(_ -> Curve(UInt16[]), Na)
    else
        seek(io, pos + offset_mcurves)
        acurves = ntuple(_ -> _read_curve(io, ver), Na)
    end
    return LUT(bcurves, mat, vec, mcurves, clut, acurves)
end

function _read_curve(io::IO, ver)
    sig = read_sig(io)
    sig isa sigtype"curv" && return _read_tagged_data(io, sig, zero(UInt32), ver)
    sig isa sigtype"para" && return _read_tagged_data(io, sig, zero(UInt32), ver)
    return error("invalid curve signature: $sig")
end

struct Mesurement <: AbstractTaggedData{sig"meas"} end

struct MLURecord
    lang::Symbol    # ISO 639-1
    region::Symbol  # ISO 3166-1
    text::String
end

struct MultiLocalizedUnicode <: AbstractTaggedData{sig"mluc"}
    records::Vector{MLURecord}
end

function _read_tagged_data(io::IO, ::S, size, ver) where {S <: sigtype"mluc"}
    pos = position(io) - 4
    read_u32(io) # reserved
    n = read_u32(io)
    len = read_u32(io)
    len == 12 || error("invalid record size: $len")
    records = Vector{MLURecord}(undef, n)
    for i in eachindex(records)
        lang = Symbol(Char(read_u8(io)), Char(read_u8(io)))
        region = Symbol(Char(read_u8(io)), Char(read_u8(io)))
        nbytes = read_u32(io)
        ofs = read_u32(io)
        seek(io, pos + ofs)
        str = read_utf16be(io, nbytes)
        records[i] = MLURecord(lang, region, str)
    end
    return MultiLocalizedUnicode(records)
end

struct MultiProcessElements <: AbstractTaggedData{sig"mpet"} end

struct NamedColor2 <: AbstractTaggedData{sig"ncl2"} end

struct ProfileSequenceDesc <: AbstractTaggedData{sig"psec"} end

struct ProfileSequenceIdentifier <: AbstractTaggedData{sig"psid"} end

struct S15Fixed16Array{N} <: AbstractTaggedData{sig"sf32"}
    array::NTuple{N, Q15f16}
end

function _read_tagged_data(io::IO, ::S, size, ver) where {S <: sigtype"sf32"}
    iszero(size) && error("size unknown")
    read_u32(io) # reserved
    N::Int = (size - 8) ÷ 4
    array = ntuple(_ -> read_q15f16(io), N)
    return S15Fixed16Array{N}(array)
end

struct TaggedSignature <: AbstractTaggedData{sig"sig "}
    signature::Signature
end

function _read_tagged_data(io::IO, ::S, size, ver) where {S <: sigtype"sig "}
    read_u32(io) # reserved
    return TaggedSignature(read_sig(io))
end

struct TaggedText <: AbstractTaggedData{sig"text"}
    text::String
end
function MultiLocalizedUnicode(text::TaggedText)
    return MultiLocalizedUnicode([MLURecord(:en, :US, text.text)])
end
function _read_tagged_data(io::IO, ::S, size, ver) where {S <: sigtype"text"}
    read_u32(io) # reserved
    return TaggedText(read_ascii(io, size - 8))
end

"""
    TaggedTypes.TextDescription

`textDescription`

!!! compat ICC Profile v2
    `TextDescription` (textDescriptionType) is used in ICC Profile v2.4 and
    earlier, replaced by `multiLU` in ICC Profile v4.0 and later.
"""
struct TextDescription <: AbstractTaggedData{sig"desc"}
    text::String
    ascii::String
    scriptcode::UInt16
    script::String

    function TextDescription(text, ascii = "", scriptcode = 0x0000, script = "")
        return new(text, ascii, scriptcode, script)
    end
end

function MultiLocalizedUnicode(text::TextDescription)
    return MultiLocalizedUnicode([MLURecord(:en, :US, text.text)])
end

function _read_tagged_data(io::IO, ::S, size, ver) where {S <: sigtype"desc"}
    read_u32(io) # reserved
    ascii = read_ascii(io, read_u32(io))
    lang = read_u32(io)
    n_unicode = read_u32(io)
    if n_unicode != 0
        desc = read_utf16be(io, n_unicode * 2 - 2)
        read_u16(io) === 0x0000 || error("invalid UTF-16BE string termination")
    else
        desc = ascii
    end
    code = read_u16(io)
    script = read_ascii(io, read_u8(io))
    return TextDescription(desc, ascii, code, script)
end

struct ViewingConditions <: AbstractTaggedData{sig"view"}
    illuminant::XYZ{Float64}
    surround::XYZ{Float64}
    standard::StandardIlluminant
end

function _read_tagged_data(io::IO, ::S, size, ver) where {S <: sigtype"view"}
    read_u32(io) # reserved
    illuminant = read_xyz(io)
    surround = read_xyz(io)
    standard = StandardIlluminant{read_sig(io)}()
    return ViewingConditions(illuminant, surround, standard)
end

"""
    TaggedTypes.TaggedXYZ


"""
struct TaggedXYZ <: AbstractTaggedData{sig"XYZ "}
    xyz::Vector{XYZ{Float64}}
end

function _read_tagged_data(io::IO, ::S, size, ver) where {S <: sigtype"XYZ "}
    read_u32(io) # reserved
    vec = Vector{XYZ{Float64}}(undef, (size - 8) ÷ 12)
    for i in eachindex(vec)
        vec[i] = read_xyz(io)
    end
    return TaggedXYZ(vec)
end

function _check_size(actual, expected)
    return actual == expected || error("size mismatch")
end

end # module
