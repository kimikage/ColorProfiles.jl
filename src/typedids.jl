
#-------------------------------------------------------------------------------
# 7.2.15 Rendering intent field
#-------------------------------------------------------------------------------
"""
`RenderingIntents` module defines the type for identifying rendering intents and
its instances (constants).
See [`RenderingIntent`](@ref).
"""
module RenderingIntents

using ..ColorProfiles: TypedId

export RenderingIntent
export Perceptual, RelativeColorimetric, Saturation, AbsoluteColorimetric

"""
    RenderingIntent{id}

| Rendering Intent             | Encoded `id` |
|:-----------------------------|:------------:|
|[`Perceptual`](@ref)          | `0x00000001` |
|[`RelativeColorimetric`](@ref)| `0x00000002` |
|[`Saturation`](@ref)          | `0x00000003` |
|[`AbsoluteColorimetric`](@ref)| `0x00000004` |
"""
struct RenderingIntent{id} <: TypedId{id} end

"""
    Perceptual

Perceptual rendering intent.
"""
const Perceptual = RenderingIntent{0x00000001}()

"""
    RelativeColorimetric

Media-relative colorimetric rendering intent.
"""
const RelativeColorimetric = RenderingIntent{0x00000002}()

"""
    Saturation

Saturation rendering intent.
"""
const Saturation = RenderingIntent{0x00000003}()

"""
    AbsoluteColorimetric

ICC-absolute colorimetric rendering intent.
"""
const AbsoluteColorimetric = RenderingIntent{0x00000004}()

end # module RenderingIntents

#-------------------------------------------------------------------------------
# 10.14 measurementType
#-------------------------------------------------------------------------------
"""
`StandardObservers` module defines the type for identifying standard observers
and its instances (constants).
See [`StandardObserver`](@ref).
"""
module StandardObservers

using ..ColorProfiles: TypedId

export StandardObserver
export UnknownObserver, CIE1931Observer, CIE1964Observer

"""
    StandardObserver{id}

| Standard Observer       | Encoded `id` |
|:------------------------|:------------:|
| `UnknownObserver`       | `0x00000000` |
|[`CIE1931Observer`](@ref)| `0x00000001` |
|[`CIE1964Observer`](@ref)| `0x00000002` |
"""
struct StandardObserver{id} <: TypedId{id} end

const UnknownObserver = StandardObserver{0x00000000}()

"""
    CIE1931Observer

CIE 1931 standard colorimetric observer
"""
const CIE1931Observer = StandardObserver{0x00000001}()

"""
    CIE1964Observer

CIE 1964 standard colorimetric observer
"""
const CIE1964Observer = StandardObserver{0x00000002}()

end # module StandardObservers

"""
`MeasurementGeometries` module`defines the type for identifying measurement
geometries and its instances (constants).
See [`MeasurementGeometry`](@ref).
"""
module MeasurementGeometries

using ..ColorProfiles: TypedId

export MeasurementGeometry
export GeometryUnknown, Geometry45Deg, GeometryD

"""
    MeasurementGeometry{id}

| Measurement Geometry  | Encoded `id` |
|:----------------------|:------------:|
| `GeometryUnknown`     | `0x00000000` |
|[`Geometry45Deg`](@ref)| `0x00000001` |
|[`GeometryD`](@ref)    | `0x00000002` |
"""
struct MeasurementGeometry{id} <: TypedId{id} end

const GeometryUnknown = MeasurementGeometry{0x00000000}()

"""
    Geometry45Deg

Measurement geometry of 0°:45° or 45°:0°.
"""
const Geometry45Deg = MeasurementGeometry{0x00000001}()

"""
    GeometryD

Measurement geometry of 0°:d or d:0°.
"""
const GeometryD = MeasurementGeometry{0x00000002}()

end # module MeasurementGeometries

"""
`MeasurementFlares` module defines the type for identifying the measurement
flares and its instances (constants).
See [`MeasurementFlare`](@ref).
"""
module MeasurementFlares

using ..ColorProfiles: TypedId

export MeasurementFlare
export Flare0, Flare100

"""
    MeasurementFlare{id}

The encoding for the measurement flare value.
The `id` is equivalent to the underlying type of `UQ16f16`.
There are two pre-defined instances.

| Measurement Flare     | Encoded `id` |
|:----------------------|:------------:|
|[`Flare0`](@ref)       | `0x00000000` |
|[`Flare100`](@ref)     | `0x00010000` |
"""
struct MeasurementFlare{id} <: TypedId{id} end

"""
    Flare0

Measurement flare value of 0.0 (0%).
"""
const Geometry45Deg = MeasurementFlare{0x00000000}()

"""
    Flare100

Measurement flare value of 1.0 (or 100%).
"""
const Flare100 = MeasurementFlare{0x00010000}()

end # module MeasurementFlares

"""
`StandardIlluminants` module defines the type for identifying standard
illuminants and its instances (constants).
See [`StandardIlluminant`](@ref).
"""
module StandardIlluminants

using ..ColorProfiles: TypedId

export StandardIlluminant
export IlluminantUnknown
export IlluminantD50
export IlluminantD65
export IlluminantD93
export IlluminantF2
export IlluminantD55
export IlluminantA
export IlluminantE
export IlluminantF8

"""
    StandardIlluminant{id}

| Standard Illuminant   | Encoded `id` |
|:----------------------|:------------:|
| `IlluminantUnknown`   | `0x00000000` |
|[`IlluminantD50`](@ref)| `0x00000001` |
|[`IlluminantD65`](@ref)| `0x00000002` |
| `IlluminantD93`       | `0x00000003` |
| `IlluminantF2`        | `0x00000004` |
| `IlluminantD55`       | `0x00000005` |
| `IlluminantA`         | `0x00000006` |
|[`IlluminantE`](@ref)  | `0x00000007` |
| `IlluminantF8`        | `0x00000008` |
"""
struct StandardIlluminant{id} <: TypedId{id} end

const IlluminantUnknown = StandardIlluminant{0x00000000}()

"""
    IlluminantD50
"""
const IlluminantD50 = StandardIlluminant{0x00000001}()

"""
    IlluminantD65

This is used as the default white point in `Colors`.
"""
const IlluminantD65 = StandardIlluminant{0x00000002}()
const IlluminantD93 = StandardIlluminant{0x00000003}()
const IlluminantF2 = StandardIlluminant{0x00000004}()
const IlluminantD55 = StandardIlluminant{0x00000005}()
const IlluminantA = StandardIlluminant{0x00000006}()

"""
    IlluminantE

Equi-Power standard illuminant.
"""
const IlluminantE = StandardIlluminant{0x00000007}()
const IlluminantF8 = StandardIlluminant{0x00000008}()

end # module StandardIlluminants
