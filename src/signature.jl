
"""
    Signature{id}

`Signature` is a sigleton type to represent an 4-ASCII-character symbol. The
`id` paramater should be a `UInt32` number.

!!! note
    Note that the semantics of signatures are context dependent and are not
    globally unique in profiles. For example, `"XYZ "`(`0x58595a20`) is used for
    [`ColorSpaces.XYZSpace`](@ref) and [`TaggedTypes.TaggedXYZ`](@ref).
"""
struct Signature{id} end

"""
    Signature() -> Signature{0x00000000}
    Signature(sym::Symbol) -> Signature
    Signature(s::AbstractString) -> Signature

Return a singleton instance of corresponding to the specified 4-character symbol.

See also [`ColorProfiles.@sig_str`](@ref)/[`ColorProfiles.@sigtype_str`](@ref).

# Examples
```jldoctest; setup=(using ColorProfiles)
julia> Signature(Symbol("XYZ ")) # padded at the end with `" "`` (`0x20`) bytes
Signature{0x58595a20}()
````
"""
Signature() = Signature{zero(UInt32)}()

function Signature(sym::Symbol)
    codes = UInt32.(codeunits(string(sym)))
    id = (codes[1] << 0x18) | (codes[2] << 0x10) | (codes[3] << 0x8) | codes[4]
    Signature{id}()
end

Signature(s::AbstractString) = Signature(Symbol(s))

idnumber(::Type{Signature{id}}) where {id} = id
idnumber(x::Signature) = idnumber(typeof(x))
idnumber(x) = idnumber(typeof(x))

signature(x::Type{<:Signature}) = x()
signature(x::Type) = throw(MethodError(signature, (typeof(x),)))
signature(x) = signature(typeof(x))



read_sig(io::IO) = Signature{read_u32(io)}()
write_sig(io::IO, sig::Signature) = write_u32(io, idnumber(sig))
write_sig(io::IO, x) = write_sig(io, signature(x))


"""
    ColorProfiles.@sig_str

Creates a [`Signature`](@ref) singleton instance using string syntax.
See also [`ColorProfiles.@sigtype_str`](@ref).

# Examples
```jldoctest; setup=(using ColorProfiles)
julia> using ColorProfiles: @sig_str;

julia> sig"XYZ " # returns a singleton instance
Signature{0x58595a20}()
```
"""
macro sig_str(e)
    sig = Signature(Symbol(e))
    :($sig)
end

"""
    ColorProfiles.@sigtype_str

Creates a [`Signature`](@ref) singleton type using string syntax.
See also [`ColorProfiles.@sig_str`](@ref).

# Examples
```jldoctest; setup=(using ColorProfiles)
julia> using ColorProfiles: @sigtype_str;

julia> sigtype"XYZ " # returns a singleton type
Signature{0x58595a20}
```
"""
macro sigtype_str(e)
    sigtype = typeof(Signature(Symbol(e)))
    :($sigtype)
end

# Enum-like type with `Signature`
abstract type TypedSignature{sig} end

(::Type{T})() where {T<:TypedSignature} = T{Signature()}()

function (::Type{T})(sym::Symbol) where {T<:TypedSignature}
    isconcretetype(T) && throw(MethodError(T, ()))
    T{Signature(sym)}()
end

signature(::Type{<:TypedSignature{sig}}) where {sig} = sig

# Enum-like type with `UInt32` id
abstract type TypedId{id} end

idnumber(::Type{<:TypedId{id}}) where {id} = id::UInt32
