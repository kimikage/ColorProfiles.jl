"""
`CMMTypes` module defines a type for identifying CMM (Color Management Module)
types.
See [`CMMType`](@ref).
"""
module CMMTypes

using ..ColorProfiles: TypedSignature
export CMMType

"""
    CMMType{sig}

A singleton type for CMM (Color Management Module) types.
The `sig` parameter should be a [`Signature`](@ref) instance.

Currently, the `CMMTypes` module does not define the `CMMType` instances
(constants). See [Signature Registry](https://www.color.org/signatures2.xalter)
in the ICC website for the registered signatures. For example, you can use
`CMMType(:lcms)` for the Little CMS CMM, as a singleton instance.
"""
struct CMMType{sig} <: TypedSignature{sig} end

end # module
