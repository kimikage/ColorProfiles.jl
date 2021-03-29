module ColorProfilesFileIOExt

isdefined(Base, :get_extension) ? (using FileIO) : (using ..FileIO)

using ColorProfiles
using UUIDs

"""
    ColorProfiles.load(f::File{format"ICCProfile"}; kwargs...)
    ColorProfiles.load(s::Stream{format"ICCProfile"}; kwargs...)

See also `read_iccprofile`.

# Keyword Arguments
- `embedding`
  - If specified, an embedded ICC profile will be loaded from the format.
  - Currently, only `format"JPEG"` is supported.

# Examples
```julia
julia> using FileIO;

julia> ColorProfiles.load("example.icc");

julia> ColorProfiles.load("example.jpg"; embedding=format"JPEG");
```
"""
function ColorProfiles.load(f::File{format"ICCProfile"}; kwargs...)
    open(f) do s
        return read_icc_profile(stream(s); kwargs...)
    end
end

function ColorProfiles.load(s::Stream{format"ICCProfile"};
                            embedding::Type{<:DataFormat} = format"")
    return _load(embedding, s)
end

function _load(::Type, ::Stream{format"ICCProfile"})
    error("not supported")
end

function _load(::Type{format""}, s::Stream{format"ICCProfile"})
    return read_icc_profile(stream(s))
end

function _load(::Type{format"JPEG"}, s::Stream{format"ICCProfile"})
    return read_icc_profile_in_jpeg(stream(s))
end

function ColorProfiles.add_icc_profile_format()
    add_format(format"ICCProfile",
               ColorProfiles.detect_icc_header,
               [".icc", ".icm"],
               [:ColorProfiles => UUID("b638e392-9ff0-4b7a-a644-061760c28f55")])
end

end # module
