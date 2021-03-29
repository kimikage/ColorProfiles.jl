# Type Mapping

## Basic number types

| §  | ICC Profile        | ColorProfiles.jl                    |
|:--:|:-------------------|:------------------------------------|
|4.2 | `dateTimeNumber`   | `Dates.DateTime`                    |
|4.3 | `float32Number`    | `Core.Float32`                      |
|4.4 | `positionNumber`   | [`ColorProfiles.Position`](@ref)    |
|4.5 | `response16Number` | [`ColorProfiles.Response16`](@ref)  |
|4.6 | `s15Fixed16Number` | `FixedPointNumbers.Q15f16`          |
|4.7 | `u16Fixed16Number` | [`UQ16f16`](@ref)                   |
|4.8 | `u1Fixed15Number`  | [`UQ1f15`](@ref)                    |
|4.9 | `u8Fixed8Number`   | [`UQ8f8`](@ref)                     |
|4.10| `uInt16Number`     | `Core.UInt16`                       |
|4.11| `uInt32Number`     | `Core.UInt32`                       |
|4.12| `uInt64Number`     | `Core.UInt64`                       |
|4.13| `uInt8Number`      | `Core.UInt8`                        |
|4.14| `XYZNumber`        | `ColorTypes.XYZ{Float64}`           |
|4.15| Seven-bit ASCII    | `Core.Char`/`Core.String`           |

## Tags

| §    | ICC Profile                        | ColorProfiles.jl                           |
|:----:|:-----------------------------------|:-------------------------------------------|
|9.2.1 | `AToB0Tag`                         | [`AToB0Tag`](@ref)                         |
|9.2.2 | `AToB1Tag`                         | [`AToB1Tag`](@ref)                         |
|9.2.3 | `AToB2Tag`                         | [`AToB2Tag`](@ref)                         |
|9.2.4 | `blueMatrixColumnTag`              | [`BlueMatrixColumnTag`](@ref)              |
|9.2.5 | `blueTRCTag`                       | [`BlueTRCTag`](@ref)                       |
|9.2.6 | `BToA0Tag`                         | [`BToA0Tag`](@ref)                         |
|9.2.7 | `BToA1Tag`                         | [`BToA1Tag`](@ref)                         |
|9.2.8 | `BToA2Tag`                         | [`BToA2Tag`](@ref)                         |
|9.2.9 | `BToD0Tag`                         | [`BToD0Tag`](@ref)                         |
|9.2.10| `BToD1Tag`                         | [`BToD1Tag`](@ref)                         |
|9.2.11| `BToD2Tag`                         | [`BToD2Tag`](@ref)                         |
|9.2.12| `BToD3Tag`                         | [`BToD3Tag`](@ref)                         |
|9.2.13| `calibrationDateTimeTag`           | [`CalibrationDateTimeTag`](@ref)           |
|9.2.14| `charTargetTag`                    | [`CharTargetTag`](@ref)                    |
|9.2.15| `chromaticAdaptationTag`           | [`ChromaticAdaptationTag`](@ref)           |
|9.2.16| `chromaticityTag`                  | [`ChromaticityTag`](@ref)                  |
|9.2.17| `cicpTag`                          | [`CicpTag`](@ref)                          |
|9.2.18| `colorantOrderTag`                 | [`ColorantOrderTag`](@ref)                 |
|9.2.19| `colorantTableTag`                 | [`ColorantTableTag`](@ref)                 |
|9.2.20| `colorantTableOutTag`              | [`ColorantTableOutTag`](@ref)              |
|9.2.21| `colorimetricIntentImageStateTag`  | [`ColorimetricIntentImageStateTag`](@ref)  |
|9.2.22| `copyrightTag`                     | [`CopyrightTag`](@ref)                     |
|9.2.23| `deviceMfgDescTag`                 | [`DeviceMfgDescTag`](@ref)                 |
|9.2.24| `deviceModelDescTag`               | [`DeviceModelDescTag`](@ref)               |
|9.2.25| `DToB0Tag`                         | [`DToB0Tag`](@ref)                         |
|9.2.26| `DToB1Tag`                         | [`DToB1Tag`](@ref)                         |
|9.2.27| `DToB2Tag`                         | [`DToB2Tag`](@ref)                         |
|9.2.28| `DToB3Tag`                         | [`DToB3Tag`](@ref)                         |
|9.2.29| `gamutTag`                         | [`GamutTag`](@ref)                         |
|9.2.30| `grayTRCTag`                       | [`GrayTRCTag`](@ref)                       |
|9.2.31| `greenMatrixColumnTag`             | [`GreenMatrixColumnTag`](@ref)             |
|9.2.32| `greenTRCTag`                      | [`GreenTRCTag`](@ref)                      |
|9.2.33| `luminanceTag`                     | [`LuminanceTag`](@ref)                     |
|9.2.34| `measurementTag`                   | [`MeasurementTag`](@ref)                   |
|9.2.35| `metadataTag`                      | [`MetaDataTag`](@ref)                      |
|(v2)  | `mediaBlackPointTag`               | [`MediaBlackPointTag`](@ref)               |
|9.2.36| `mediaWhitePointTag`               | [`MediaWhitePointTag`](@ref)               |
|9.2.37| `namedColor2Tag`                   | [`NamedColor2Tag`](@ref)                   |
|9.2.38| `outputResponseTag`                | [`OutputResponseTag`](@ref)                |
|9.2.39| `perceptualRenderingIntentGamutTag`| [`PerceptualRenderingIntentGamutTag`](@ref)|
|9.2.40| `preview0Tag`                      | [`Preview0Tag`](@ref)                      |
|9.2.41| `preview1Tag`                      | [`Preview1Tag`](@ref)                      |
|9.2.42| `preview2Tag`                      | [`Preview2Tag`](@ref)                      |
|9.2.43| `profileDescriptionTag`            | [`ProfileDescriptionTag`](@ref)            |
|9.2.44| `profileSequenceDescTag`           | [`ProfileSequenceDescTag`](@ref)           |
|9.2.45| `profileSequenceIdentifierTag`     | [`ProfileSequenceIdentifierTag`](@ref)     |
|9.2.46| `redMatrixColumnTag`               | [`RedMatrixColumnTag`](@ref)               |
|9.2.47| `redTRCTag`                        | [`RedTRCTag`](@ref)                        |
|9.2.48| `saturationRenderingIntentGamutTag`| [`SaturationRenderingIntentGamutTag`](@ref)|
|9.2.49| `technologyTag`                    | [`TechnologyTag`](@ref)                    |
|9.2.50| `viewingCondDescTag`               | [`ViewingCondDescTag`](@ref)               |
|9.2.51| `viewingConditionsTag`             | [`ViewingConditionsTag`](@ref)             |

# Tag Types
| §    | ICC Profile                        | ColorProfiles.jl                           |
|:----:|:-----------------------------------|:-------------------------------------------|
|10.2  |`chromaticityType`                  |[`Chromaticity`](@ref)                      |
|10.3  |`cicpType`                          |[`Cicp`](@ref)                              |
|10.4  |`colorantOrderType`                 |[`ColorantOrder`](@ref)                     |
|10.5  |`colorantTableType`                 |[`ColorantTable`](@ref)                     |
|10.6  |`curveType`                         |[`Curve`](@ref)                             |
|10.7  |`dataType`                          |[`TaggedData`](@ref)                        |
|10.8  |`dateTimeType`                      |[`TaggedDateTime`](@ref)                    |
|10.9  |`dictType`                          |[`TaggedDict`](@ref)                        |
|10.10 |`lut16Type`                         |[`LUT16`](@ref)                             |
|10.11 |`lut8Type`                          |[`LUT8`](@ref)                              |
|10.12 |`lutAToBType`                       |[`LUTAToB`](@ref)                           |
|10.13 |`lutBToAType`                       |[`LUTBToA`](@ref)                           |
|10.14 |`measurementTypee`                  |[`Measurement`](@ref)                       |
