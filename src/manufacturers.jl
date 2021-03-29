"""
`Manufacturers` module defines a type for identifying the manufacturers or
creators. See [`Manufacturer`](@ref).
"""
module Manufacturers

using ..ColorProfiles: TypedSignature

export Manufacturer

"""
    Manufacturer{sig}

Currently, the `Manufacturers` module does not define the `Manufacturer`
instances (constants).
See [Manufacturer Registry](https://www.color.org/signatureRegistry/index.xalter)
in the ICC website.
"""
struct Manufacturer{sig} <: TypedSignature{sig} end

end # module
