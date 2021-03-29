"""
`Platforms` module defines a type for
"""
module Platforms

using ..ColorProfiles: TypedSignature
export Platform

"""
    Platform{sig}

`Platform` is a singleton type to represent the primary platform. The `sig`
parameter should be a [`Signature`](@ref) instance.

The `Platforms` module defines the following singleton instances, but they are
not exported:

| Instance Name       | Primary Platform       | Signature |
|--------------------:|:-----------------------|:---------:|
| `ApplePlatform`     | Apple Computer, Inc.   | `"APPL"`  |
| `MicrosoftPlatform` | Microsoft Corporation  | `"MSFT"`  |
| `SGIPlatform`       | Silicon Graphics, Inc. | `"SGI "`  |
| `SunPlatform`       | Sun Microsystems, Inc. | `"SUNW"`  |
| `TaligentPlatform`  | Taligent, Inc.         | `"TGNT"`  |

"""
struct Platform{sig} <: TypedSignature{sig} end

# the follwing are not exported
const ApplePlatform = Platform(:APPL)
const MicrosoftPlatform = Platform(:MSFT)
const SGIPlatform = Platform(Symbol("SGI "))
const SunPlatform = Platform(:SUNW)
const TaligentPlatform = Platform(:TGNT) # ICC profile v2

end # module
