"""
`ProfileClasses` module defines the type for identifying profile/device classes
and its instances.
See [`ProfileClass`](@ref).
"""
module ProfileClasses

using ..ColorProfiles: TypedSignature
export ProfileClass
export InputClass, DisplayClass, OutputClass
export DeviceLinkClass, ColorSpaceClass, AbstractClass, NamedColorClass

"""
    ProfileClass{sig}

- [`InputClass`](@ref)
- [`DisplayClass`](@ref)
- [`OutputClass`](@ref)
- [`DeviceLinkClass`](@ref)
- [`ColorSpaceClass`](@ref)
- [`AbstractClass`](@ref)
- [`NamedColorClass`](@ref)
"""
struct ProfileClass{sig} <: TypedSignature{sig} end

"""
    InputClass

A singleton instance of [`ProfileClass{Signature(:scnr)}`](@ref).
This is one of basic device classes.
"""
const InputClass = ProfileClass(:scnr)

"""
    DisplayClass

A singleton instance of [`ProfileClass{Signature(:mntr)}`](@ref).
This is one of basic device classes.
"""
const DisplayClass = ProfileClass(:mntr)

"""
    OutputClass

A singleton instance of [`ProfileClass{Signature(:prtr)}`](@ref).
This is one of basic device classes.
"""
const OutputClass = ProfileClass(:prtr)

"""
    DeviceLinkClass
"""
const DeviceLinkClass = ProfileClass(:link)

"""
    ColorSpaceClass
"""
const ColorSpaceClass = ProfileClass(:spac)

"""
    AbstractClass
"""
const AbstractClass = ProfileClass(:abst)

"""
    NamedColorClass
"""
const NamedColorClass = ProfileClass(:nmcl)

end # module
