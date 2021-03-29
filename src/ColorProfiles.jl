"""
    ColorProfiles

`ColorProfiles` package provides the types for ICC Profile and profile reader.
"""
module ColorProfiles

using Dates
using FixedPointNumbers
using ColorTypes

@static if !isdefined(Base, :get_extension)
    using Requires
end

import Base: show, print

export AbstractColorProfile, ICCProfile
export ICCProfileHeader, TagTable
export Q15f16, UQ16f16, UQ1f15, UQ8f8
export Signature
export TaggedTypes

export embedded_in_file, use_with_embedded_data_only

export read_icc_profile, read_icc_header, read_icc_tag_table
export write_icc_profile, write_icc_header, write_icc_tag_table

export read_icc_profile_in_jpeg

export add_icc_profile_format

if !isdefined(FixedPointNumbers, :UQ16f16)
    include("ufixed.jl")
end

include("utilities.jl")

include("types.jl")
using .CMMTypes
using .ProfileClasses
using .ColorSpaces
using .Platforms
using .Manufacturers
using .DeviceModels
using .RenderingIntentGamuts
using .DeviceTechnologies

include("typedids.jl")
using .RenderingIntents
using .StandardObservers
using .MeasurementGeometries
using .MeasurementFlares
using .StandardIlluminants

include("pcscolortypes.jl")
using .PCSColorTypes

include("taggedtypes.jl")
using .TaggedTypes

include("tags.jl")
using .Tags

include("tagtable.jl")

include("header.jl")

abstract type AbstractColorProfile end

"""
    ICCProfile

A type for ICC plofile data. This supports both ICC profile v4 and v2.

# Fields
- `header::ICCProfileHeader`
- `table::TagTable`
"""
struct ICCProfile <: AbstractColorProfile
    header::ICCProfileHeader
    table::TagTable
end

"""
    embedded_in_file(profile) -> Bool
    embedded_in_file(profile, conf::Bool) -> Bool

Get or set the flag which indicates that the profile is embedded.
"""
embedded_in_file(profile::ICCProfile) = embedded_in_file(profile.header)
embedded_in_file(profile::ICCProfile, conf::Bool) = embedded_in_file(profile.header, conf)

"""
    use_with_embedded_data_only(profile) -> Bool
    use_with_embedded_data_only(profile, conf::Bool) -> Bool

Get or set the flag which indicates that the profile cannot be used
independently of the embedded color data.
"""
function use_with_embedded_data_only(profile::ICCProfile)
    use_with_embedded_data_only(profile.header)
end
function use_with_embedded_data_only(profile::ICCProfile, conf::Bool)
    use_with_embedded_data_only(profile.header, conf)
end

# re-export
for submodule in (CMMTypes,
                  ProfileClasses,
                  ColorSpaces,
                  Platforms,
                  Manufacturers,
                  DeviceModels,
                  RenderingIntentGamuts,
                  DeviceTechnologies,
                  RenderingIntents,
                  StandardObservers,
                  MeasurementGeometries,
                  MeasurementFlares,
                  StandardIlluminants,
                  PCSColorTypes,
                  Tags)
    for name in names(submodule)
        @eval export $name
    end
end

include("show.jl")

include("io.jl")

# extension for FileIO
function add_icc_profile_format end
function load end
function save end

@static if !isdefined(Base, :get_extension)
    function __init__()
        @require FileIO="5789e2e9-d7fb-5bc7-8068-2c6fae9b9549" include("../ext/ColorProfilesFileIOExt.jl")
        @require MD5="6ac74813-4b46-53a4-afec-0b5dc9d7885c" include("../ext/ColorProfilesMD5Ext.jl")
    end
end

end
