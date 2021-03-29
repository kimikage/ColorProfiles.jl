module Tags

using Dates
using FixedPointNumbers
using ColorTypes

using ..ColorProfiles.TaggedTypes
using ..ColorProfiles.PCSColorTypes
using ..ColorProfiles.StandardIlluminants
using ..ColorProfiles.RenderingIntentGamuts
using ..ColorProfiles.DeviceTechnologies

using ..ColorProfiles: Signature, @sig_str, @sigtype_str
using ..ColorProfiles: read_u16, read_u32, read_sig, read_utf16be, read_datetime

import ..ColorProfiles: signature

export AbstractTag, UnknownTag
export AToBTag, BToATag, PreviewTag, MatrixColumnTag, XYZTag # parametric
export AToB0Tag
export AToB1Tag
export AToB2Tag
export BlueMatrixColumnTag
export BlueTRCTag
export BToA0Tag
export BToA1Tag
export BToA2Tag
export CharTargetTag
export ChromaticAdaptationTag
export CopyrightTag
export GamutTag
export GrayTRCTag
export GreenMatrixColumnTag
export GreenTRCTag
export LuminanceTag
export MediaBlackPointTag # ICC v2
export MediaWhitePointTag
export PerceptualRenderingIntentGamutTag
export Preview0Tag
export Preview1Tag
export Preview2Tag
export ProfileDescriptionTag
export RedMatrixColumnTag
export RedTRCTag
export SaturationRenderingIntentGamutTag
export TechnologyTag
export ViewingConditionsTag

export read_tag

abstract type AbstractTag{sig} end

signature(::Type{<:AbstractTag{sig}}) where {sig} = sig

function Base.show(io::IO, ::MIME"text/plain", tag::AbstractTag)
    print(io, typeof(tag), ":")
end

function read_tag(io::IO, sig::Signature, size, version)
    data = read_tagged_data(io, size, version)
    return _tag(sig, data, version)
end

"""
    UnknownTag{sig, T}

"""
struct UnknownTag{sig, T} <: AbstractTag{sig}
    data::T
end

element_signature(tag::UnknownTag, ver) = signature(typeof(tag.data))

_tag(sig::Signature, data, ver) = UnknownTag{sig, typeof(data)}(data)

abstract type AbstractLUTTag{sig, T} <: AbstractTag{sig} end

element_signature(::AbstractLUTTag{sig, T}, ver) where {sig, T} = signature(T)

"""
    AToBTag{sig, T}

`AToBTag` defines a color transform to (mainly) PCS. See also [`BToATag`](@ref).
This is the parametric type for the following tags:
- [`AToB0Tag`](@ref)
- [`AToB1Tag`](@ref)
- [`AToB2Tag`](@ref)

# Fields
- `lut::T`: lookup table
"""
struct AToBTag{sig, T <: Union{LUT8, LUT16, LUTAToB}} <: AbstractLUTTag{sig, T}
    lut::T
end

const AToBSignature = Union{sigtype"A2B0", sigtype"A2B1", sigtype"A2B2"}
_tag(sig::S, data, ver) where {S <: AToBSignature} = AToBTag{sig, typeof(data)}(data)

"""
    BToATag{sig, T}

`BToATag` is
This is the parametric type for the following tags:
- [`BToA0Tag`](@ref)
- [`BToA1Tag`](@ref)
- [`BToA2Tag`](@ref)

# Fields
- `lut::T`: lookup table
"""
struct BToATag{sig, T <: Union{LUT8, LUT16, LUTBToA}} <: AbstractLUTTag{sig, T}
    lut::T
end

const BToASignature = Union{sigtype"B2A0", sigtype"B2A1", sigtype"B2A2"}
_tag(sig::S, data, ver) where {S <: BToASignature} = BToATag{sig, typeof(data)}(data)

"""
    BToDTag{sig, T}


- [`BToD0Tag`](@ref)
- [`BToD1Tag`](@ref)
- [`BToD2Tag`](@ref)
- [`BToD3Tag`](@ref)
"""
struct BToDTag{sig, T} <: AbstractLUTTag{sig, T}
    lut::T
end

const BToDSignature = Union{sigtype"BToD0", sigtype"BToD1", sigtype"BToD2", sigtype"BToD3"}
_tag(sig::S, data, ver) where {S <: BToDSignature} = BToDTag{sig, typeof(data)}(data)

"""
    PreviewTag{sig, T}
"""
struct PreviewTag{sig, T <: Union{LUT8, LUT16, LUTAToB, LUTBToA}} <: AbstractLUTTag{sig, T}
    lut::T
end

const PreviewSignature = Union{sigtype"pre0", sigtype"pre1", sigtype"pre2"}
function _tag(sig::S,
              data::Union{LUT8, LUT16, LUTAToB, LUTBToA}, ver) where {S <: PreviewSignature}
    data isa LUTAToB && S === sigtype"pre0" || error("`LUTAToB` is not permitted.")
    return PreviewTag{sig, typeof(data)}(data)
end

struct RenderingIntentGamutTag{sig} <: AbstractTag{sig}
    gamut::RenderingIntentGamut
end

const RIGSignature = Union{sigtype"rig0", sigtype"rig2"}
function _tag(sig::S, data::TaggedSignature, ver) where {S <: RIGSignature}
    RenderingIntentGamutTag{sig}(RenderingIntentGamut{data.signature}())
end

abstract type AbstractXYZTag{sig} <: AbstractTag{sig} end

element_signature(::AbstractXYZTag) = signature(TaggedXYZ)

"""
    MatrixColumnTag{sig}

- [`RedMatrixColumnTag`](@ref)
- [`GreenMatrixColumnTag`](@ref)
- [`BlueMatrixColumnTag`](@ref)
"""
struct MatrixColumnTag{sig} <: AbstractXYZTag{sig}
    xyz::XYZ{Float64}
end

const MatrixColumnSignature = Union{sigtype"bXYZ", sigtype"gXYZ", sigtype"rXYZ"}
function _tag(sig::S, data::TaggedXYZ) where {S <: MatrixColumnSignature}
    MatrixColumnTag{sig}(first(data.xyz))
end

"""
    XYZTag{sig}
"""
struct XYZTag{sig} <: AbstractXYZTag{sig}
    xyz::XYZ{Float64}
end

const XYZSignature = Union{sigtype"lumi", sigtype"bkpt", sigtype"wtpt"}
function _tag(sig::S, data::TaggedXYZ, ver) where {S <: XYZSignature}
    XYZTag{sig}(first(data.xyz))
end

"""
    TRCTag{sig}

TRC (Tone Reproduction Curve).

- [`RedTRCTag`](@ref)
- [`GreenTRCTag`](@ref)
- [`BlueTRCTag`](@ref)
- [`GrayTRCTag`](@ref)
"""
struct TRCTag{sig, T <: Union{Curve, ParametricCurve}} <: AbstractTag{sig}
    curve::T
end

const TRCSignature = Union{sigtype"bTRC", sigtype"kTRC", sigtype"gTRC", sigtype"rTRC"}
_tag(sig::S, data, ver) where {S <: TRCSignature} = TRCTag{sig, typeof(data)}(data)

"""
    AToB0Tag{T}

`AToB0Tag` is the alias for [`AToBTag{Signature(:A2B0)}`](@ref).

This tag describes a color transform depending on the device/profile class.
Except for `AbstractClass` and `DeviceLinkClass`, the transform is mainly for
[`Parceptual`](@ref) rendering.

| [`ProfileClass`](@ref)    | from           | to      |
|--------------------------:|:--------------:|:-------:|
| [`InputClass`](@ref)      | Device         | PCS     |
| [`DisplayClass`](@ref)    | Device         | PCS     |
| [`OutputClass`](@ref)     | Device         | PCS     |
| [`ColorSpaceClass`](@ref) | Color encoding | PCS     |
| [`AbstractClass`](@ref)   | PCS            | PCS     |
| [`DeviceLinkClass`](@ref) | Device1        | Device2 |

"""
const AToB0Tag{T} = AToBTag{sig"A2B0", T}

"""
    AToB1Tag{T}

`AToB1Tag` is the alias for [`AToBTag{Signature(:A2B1)}`](@ref).

The transform is mainly for [`RelativeColorimetric`](@ref)/
[`AbsoluteColorimetric`](@ref) rendering.

| [`ProfileClass`](@ref)    | from           | to      |
|--------------------------:|:--------------:|:-------:|
| [`InputClass`](@ref)      | Device         | PCS     |
| [`DisplayClass`](@ref)    | Device         | PCS     |
| [`OutputClass`](@ref)     | Device         | PCS     |
| [`ColorSpaceClass`](@ref) | Color encoding | PCS     |

"""
const AToB1Tag{T} = AToBTag{sig"A2B1", T}

"""
    AToB2Tag{T}

`AToB2Tag` is the alias for [`AToBTag{Signature(:A2B2)}`](@ref).

[`Saturation`](@ref)

| [`ProfileClass`](@ref)    | from           | to      |
|--------------------------:|:--------------:|:-------:|
| [`InputClass`](@ref)      | Device         | PCS     |
| [`DisplayClass`](@ref)    | Device         | PCS     |
| [`OutputClass`](@ref)     | Device         | PCS     |
| [`ColorSpaceClass`](@ref) | Color encoding | PCS     |

"""
const AToB2Tag{T} = AToBTag{sig"A2B2", T}

"""
    BlueMatrixColumnTag
"""
const BlueMatrixColumnTag = MatrixColumnTag{sig"bXYZ"}

"""
    BlueTRCTag{T}
"""
const BlueTRCTag{T} = TRCTag{sig"bTRC", T}

"""
    BToA0Tag{T}
"""
const BToA0Tag{T} = BToATag{sig"B2A0", T}

"""
    BToA1Tag{T}
"""
const BToA1Tag{T} = BToATag{sig"B2A1", T}

"""
    BToA2Tag{T}
"""
const BToA2Tag{T} = BToATag{sig"B2A2", T}

"""
    BToD0Tag{T}
"""
const BToD0Tag{T} = BToDTag{sig"B2D0", T}

"""
    BToD1Tag{T}
"""
const BToD1Tag{T} = BToDTag{sig"B2D1", T}

"""
    BToD2Tag{T}
"""
const BToD2Tag{T} = BToDTag{sig"B2D2", T}

"""
    BToD3Tag{T}
"""
const BToD3Tag{T} = BToDTag{sig"B2D3", T}

"""
    CalibrationDateTimeTag
"""
struct CalibrationDateTimeTag <: AbstractTag{sig"calt"}
    datetime::DateTime
end

"""
    CharTargetTag
"""
struct CharTargetTag <: AbstractTag{sig"targ"}
    text::String
end

_tag(::S, data::TaggedText, ver) where {S <: sigtype"targ"} = CharTargetTag(data.text)

"""
    ChromaticAdaptationTag
"""
struct ChromaticAdaptationTag <: AbstractTag{sig"chad"}
    mat::Matrix{Float64}
end

function _tag(::S, data, ver) where {S <: sigtype"chad"}
    mat = [Float64(data.array[3j + i + 1]) for i in 0:2, j in 0:2]
    return ChromaticAdaptationTag(mat)
end

"""
    ChromaticityTag
"""
struct ChromaticityTag <: AbstractTag{sig"chrm"}
    colorant::UInt16
    xy::Vector{NTuple{2, Float32}}
end
ChromaticityTag(chrom::Chromaticity) = ChromaticityTag(chrom.colorant, chrom.xy)

_tag(::S, data, ver) where {S <: sigtype"chrm"} = ChromaticityTag(data)

"""
    CicpTag

Define Coding-Independent Code Points (CICP) for video signal type
identification.

!!! Compat
    cicpTag is added in ICC Profile v4.4.0.0
"""
struct CicpTag <: AbstractTag{sig"cicp"}
    color_primary::UInt8
    # FIXME
end

function _tag(::S, data, ver) where {S <: sigtype"cicp"}
    if ver < v"4.4.0"
        @warn("cicpTag is added in ICC Profile v4.4.0.0")
    end
    CicpTag(data)
end

"""
    ColorantOrderTag
"""
struct ColorantOrderTag <: AbstractTag{sig"clro"}
    order::Vector{UInt8}
end

_tag(::S, data, ver) where {S <: sigtype"clro"} = ColorantOrderTag(data.order)

"""
    ColorantTableTag
"""
struct ColorantTableTag <: AbstractTag{sig"clrt"}
end

"""
    ColorantTableOutTag
"""
struct ColorantTableOutTag <: AbstractTag{sig"clot"}
end

"""
    ColorimetricIntentImageStateTag
"""
struct ColorimetricIntentImageStateTag <: AbstractTag{sig"ciis"}
    state::Signature
end

"""
    CopyrightTag
"""
struct CopyrightTag <: AbstractTag{sig"cprt"}
    text::String
    records::Vector{MLURecord}
end

function _tag(::S,
              data::Union{TaggedText, MultiLocalizedUnicode},
              ver) where {S <: sigtype"cprt"}
    mlu = data isa TaggedText ? MultiLocalizedUnicode(data) : data
    return CopyrightTag(first(mlu.records).text, mlu.records)
end

"""
    GamutTag{T}

If the output value of LUT is zero, the PCS color is in-gamut, otherwise, the
PCS color is out-of-gamut.
"""
struct GamutTag{T <: Union{LUT8, LUT16, LUTAToB}} <: AbstractLUTTag{sig"gamt", T}
    lut::T
end

function _tag(::S, data::Union{LUT8, LUT16, LUTAToB}, ver) where {S <: sigtype"gamt"}
    GamutTag{typeof(data)}(data)
end

"""
    GrayTRCTag{T}

See also `[TRCTag]`(@ref).
"""
const GrayTRCTag{T} = TRCTag{sig"kTRC", T}

"""
    GreenTRCTag{T}

See also `[TRCTag]`(@ref), `[RedTRCTag]`(@ref) and `[BlueTRCTag]`(@ref).
"""
const GreenTRCTag{T} = TRCTag{sig"gTRC", T}

"""
    LuminanceTag = XYZTag{sig"lumi"}

`LuminanceTag` is the alias for [`XYZTag{Signature(:lumi)}`](@ref).

The `xyz` field is the "absolute" luminance of emissive devices in cd/m^2.
"""
const LuminanceTag = XYZTag{sig"lumi"}

"""
    MediaBlackPointTag = XYZTag{sig"bkpt"}

!!! Compat
    This tag was used in ICC Profile v2 but was removed in v4.
"""
const MediaBlackPointTag = XYZTag{sig"bkpt"}

"""
    MediaWhitePointTag = XYZTag{sig"wtpt"}

`MediaWhitePointTag` is the alias for [`XYZTag{Signature(:wtpt)}`](@ref).

This tag specifies the chromatically adapted CIEXYZ values of the media white
point. The `xyz` field is in normalized CIEXYZ format (i.e. `xyz.y == 1.0`).
"""
const MediaWhitePointTag = XYZTag{sig"wtpt"}

"""
    NamedColor2Tag


"""
struct NamedColor2Tag <: AbstractTag{sig"ncl2"}
end

"""
    PerceptualRenderingIntentGamutTag

"""
const PerceptualRenderingIntentGamutTag = RenderingIntentGamutTag{sig"rig0"}

"""
    Preview0Tag{T} = PreviewTag{sig"pre0",T}
"""
const Preview0Tag{T <: Union{LUT8, LUT16, LUTAToB, LUTBToA}} = PreviewTag{sig"pre0", T}

"""
    Preview1Tag{T} = PreviewTag{sig"pre1",T}
"""
const Preview1Tag{T <: Union{LUT8, LUT16, LUTBToA}} = PreviewTag{sig"pre1", T}

"""
    Preview2Tag{T} = PreviewTag{sig"pre2",T}
"""
const Preview2Tag{T <: Union{LUT8, LUT16, LUTBToA}} = PreviewTag{sig"pre2", T}

"""
    ProfileDescriptionTag <: AbstractTag{sig"desc"}
"""
struct ProfileDescriptionTag <: AbstractTag{sig"desc"}
    text::String
    records::Vector{MLURecord}
end

function _tag(::S,
              data::Union{TextDescription, MultiLocalizedUnicode},
              ver) where {S <: sigtype"desc"}
    if data isa MultiLocalizedUnicode
        ver >= v"4.0.0" || error("`MultiLocalizedUnicode` is not permitted.")
        mlu = data
    else
        mlu = MultiLocalizedUnicode(data)
    end
    ProfileDescriptionTag(first(mlu.records).text, mlu.records)
end

"""
    RedTRCTag{T} = TRCTag{sig"rTRC",T}

See also [`TRCTag`](@ref), [`GreenTRCTag`](@ref) and [`BlueTRCTag`](@ref).
"""
const RedTRCTag{T} = TRCTag{sig"rTRC", T}

"""
    SaturationRenderingIntentGamutTag = RenderingIntentGamutTag{sig"rig2"}

"""
const SaturationRenderingIntentGamutTag = RenderingIntentGamutTag{sig"rig2"}

"""
    TechnologyTag <: AbstractTag{sig"tech"}

device technology.

# Fields
- `technology::DeviceTechnology`
  - see [`DeviceTechnology`](@ref)
"""
struct TechnologyTag <: AbstractTag{sig"tech"}
    technology::DeviceTechnology
end

function _tag(::S, data::TaggedSignature) where {S <: sigtype"tech"}
    TechnologyTag(DeviceTechnology{data.signature}())
end

"""
    ViewingConditionsTag <: AbstractTag{sig"view"}

# Fields
- `illuminant::XYZ{Float64}`
- `surround::XYZ{Float64}`
- `standard::StandardIlluminant`
"""
struct ViewingConditionsTag <: AbstractTag{sig"view"}
    illuminant::XYZ{Float64}
    surround::XYZ{Float64}
    standard::StandardIlluminant
end

function ViewingConditionsTag(view::ViewingConditions)
    ViewingConditionsTag(view.illuminant, view.surround, view.standard)
end

_tag(::S, data::ViewingConditions) where {S <: sigtype"view"} = ViewingConditionsTag(data)

end
