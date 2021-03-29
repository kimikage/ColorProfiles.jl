
"""
`ColorSpaces` module defines a type for identifying color spaces, and its
instances (constants).
See [`ColorSpace`](@ref).
"""
module ColorSpaces

using ..ColorProfiles: TypedSignature, @sig_str
export ColorSpace
export XYZSpace, LabSpace, LuvSpace, YCbCrSpace, YxySpace, RGBSpace, GraySpace
export HSVSpace, HLSSpace, CMYKSpace, CMYSpace
export Color2Space, Color3Space, Color4Space, Color5Space, Color6Space
export Color7Space, Color8Space, Color9Space, Color10Space, Color11Space
export Color12Space, Color13Space, Color14Space, Color15Space

"""
    ColorSpace{sig}

`ColorSpace` is a singleton type to represent the data color space. The `sig`
parameter should be a [`Signature`](@ref) instance.

The following singleton instances are defined.

| Color Space        | Signature | Color Space      | Signature |
|-------------------:|:---------:|-----------------:|:---------:|
|[`XYZSpace`](@ref)  | `"XYZ "`  | `Color2Space`    | `"2CLR"`  |
|[`LabSpace`](@ref)  | `"Lab "`  | `Color3Space`    | `"3CLR"`  |
|[`LuvSpace`](@ref)  | `"Luv "`  | `Color4Space`    | `"4CLR"`  |
| `YCbCrSpace`       | `"YCbr"`  | `Color5Space`    | `"5CLR"`  |
| `YxySpace`         | `"Yxy "`  | `Color6Space`    | `"6CLR"`  |
| `RGBSpace`         | `"RGB "`  | `Color7Space`    | `"7CLR"`  |
| `GraySpace`        | `"GRAY"`  | `Color8Space`    | `"8CLR"`  |
| `HSVSpace`         | `"HSV "`  | `Color9Space`    | `"9CLR"`  |
| `HLSSpace`         | `"HLS "`  | `Color10Space`   | `"ACLR"`  |
| `CMYKSpace`        | `"CMYK"`  | `Color11Space`   | `"BCLR"`  |
| `CMYSpace`         | `"CMY "`  | `Color12Space`   | `"CCLR"`  |
|                    |           | `Color13Space`   | `"DCLR"`  |
|                    |           | `Color14Space`   | `"ECLR"`  |
|                    |           | `Color15Space`   | `"FCLR"`  |

"""
struct ColorSpace{sig} <: TypedSignature{sig} end

"""
`XYZSpace` refers to nCIEXYZ or PCSXYZ color space depending upon the context.
"""
const XYZSpace = ColorSpace{sig"XYZ "}()

"""
`LabSpace` refers to CIELAB or PCSLAB color space depending upon the context.
"""
const LabSpace = ColorSpace{sig"Lab "}()
const LuvSpace = ColorSpace{sig"Luv "}()
const YCbCrSpace = ColorSpace{sig"YCbr"}()
const YxySpace = ColorSpace{sig"Yxy "}()
const RGBSpace = ColorSpace{sig"RGB "}()
const GraySpace = ColorSpace{sig"GRAY"}()
const HSVSpace = ColorSpace{sig"HSV "}()
const HLSSpace = ColorSpace{sig"HLS "}()
const CMYKSpace = ColorSpace{sig"CMYK"}()
const CMYSpace = ColorSpace{sig"CMY "}()
const Color2Space = ColorSpace{sig"2CLR"}()
const Color3Space = ColorSpace{sig"3CLR"}()
const Color4Space = ColorSpace{sig"4CLR"}()
const Color5Space = ColorSpace{sig"5CLR"}()
const Color6Space = ColorSpace{sig"6CLR"}()
const Color7Space = ColorSpace{sig"7CLR"}()
const Color8Space = ColorSpace{sig"8CLR"}()
const Color9Space = ColorSpace{sig"9CLR"}()
const Color10Space = ColorSpace{sig"ACLR"}()
const Color11Space = ColorSpace{sig"BCLR"}()
const Color12Space = ColorSpace{sig"CCLR"}()
const Color13Space = ColorSpace{sig"DCLR"}()
const Color14Space = ColorSpace{sig"ECLR"}()
const Color15Space = ColorSpace{sig"FCLR"}()

end # module
