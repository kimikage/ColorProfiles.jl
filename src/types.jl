
include("signature.jl")
"""
    ColorProfiles.Position

Indicate positions of some data elements.
"""
struct Position
    offset::UInt32
    size::UInt32
end


"""
    ColorProfiles.Response16

Associate a normalized device code with a measurement value.
"""
struct Response16
    i::UInt16
    reserved::UInt16
    value::Q15f16
end

"""
    ColorProfiles.UQ16f16

A fixed unsigned 32-bit number with 16 fractional bits.

!!! compat
    This type may be implemented by FixedPointNumbers in the feature.
"""
UQ16f16

"""
    ColorProfiles.UQ1f15

A fixed unsigned 16-bit number with 15 fractional bits.

!!! compat
    This type may be implemented by FixedPointNumbers in the feature.
"""
UQ1f15

"""
    ColorProfiles.UQ8f8

A fixed unsigned 16-bit number with 8 fractional bits.

!!! compat
    This type may be implemented by FixedPointNumbers in the feature.
"""
UQ8f8

const UnsignedFixed = Union{UQ16f16, UQ1f15, UQ8f8}

# 7.2.3 Preferred CMM type field => CMMType
include("cmmtypes.jl")

# 7.2.4 Profile version field => VersionNuber

# 7.2.5 Profile/device class field => ProfileClass
include("profileclasses.jl")

# 7.2.6 Data colour space field => ColorSpace
include("colorspaces.jl")

# 7.2.7 PCS field => ColorSpase
# defined in "colorspaces.jl"

# 7.2.8 Date and time field => DateTime

# 7.2.9 Profile file signature field

# 7.2.10 Primary platform field
include("platforms.jl")

# 7.2.11 Profile flags field => UInt32

# 7.2.12 Device manufacturer field => Manufacturer
include("manufacturers.jl")

# 7.2.13 Device model field => DeviceModel
include("devicemodels.jl")

# 7.2.14 Device attributes field => UInt64

# 7.2.15 Rendering intent field => RenderingIntent
# defined in "typedids.jl"

# 7.2.16 PCS illuminant field => XYZ

# 7.2.17 Profile creator field => Manufacturer

# 7.2.18 Profile ID field => UInt128

# 9.2.39 perceptualRenderingIntentGamutTag => RenderingIntentGamut
# 9.2.48 saturationRenderingIntentGamutTag => RenderingIntentGamut
include("renderingintentgamuts.jl")

# 9.2.49 technologyTag => DeviceTechnology
include("devicetechnologies.jl")
