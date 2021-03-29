# 9.2.49 technologyTag
"""
`DeviceTechnologies` module defines a type for specifying device technology and
its instances (constants).
See [`DeviceModel`](@ref).
"""
module DeviceTechnologies

import ..ColorProfiles: TypedSignature, @sig_str

export DeviceTechnology
export FilmScanner
export DigitalCamera
export ReflectiveScanner
export InkJetPrinter
export ThermalWaxPrinter
export ElectrophotographicPrinter
export ElectrostaticPrinter
export DyeSublimationPrinter
export PhotographicPaperPrinter
export FilmWriter
export VideoMonitor
export VideoCamera
export ProjectionTelevision
export CathodeRayTubeDisplay
export PassiveMatrixDisplay
export ActiveMatrixDisplay
export PhotoCD
export PhotographicImageSetter
export Gravure
export OffsetLithography
export Silkscreen
export Flexography
export MotionPictureFilmScanner
export MotionPictureFilmRecorder
export DigitalMotionPictureCamera
export DigitalCinemaProjector

struct DeviceTechnology{sig} <: TypedSignature{sig} end


const FilmScanner = DeviceTechnology(:fscn)
const DigitalCamera = DeviceTechnology(:dcam)
const ReflectiveScanner = DeviceTechnology(:rscn)
const InkJetPrinter = DeviceTechnology(:ijet)
const ThermalWaxPrinter = DeviceTechnology(:twax)
const ElectrophotographicPrinter = DeviceTechnology(:epho)
const ElectrostaticPrinter = DeviceTechnology(:esta)
const DyeSublimationPrinter = DeviceTechnology(:dsub)
const PhotographicPaperPrinter = DeviceTechnology(:rpho)
const FilmWriter = DeviceTechnology(:fprn)
const VideoMonitor = DeviceTechnology(:vdim)
const VideoCamera = DeviceTechnology(:vidc)
const ProjectionTelevision = DeviceTechnology(:pjtv)
const CathodeRayTubeDisplay = DeviceTechnology{sig"CRT "}()
const PassiveMatrixDisplay = DeviceTechnology{sig"PMD "}()
const ActiveMatrixDisplay = DeviceTechnology{sig"AMD "}()
const PhotoCD = DeviceTechnology(:KPCD)
const PhotographicImageSetter = DeviceTechnology(:imgs)
const Gravure = DeviceTechnology(:grav)
const OffsetLithography = DeviceTechnology(:offs)
const Silkscreen = DeviceTechnology(:silk)
const Flexography = DeviceTechnology(:flex)
const MotionPictureFilmScanner = DeviceTechnology(:mpfs)
const MotionPictureFilmRecorder = DeviceTechnology(:mpfr)
const DigitalMotionPictureCamera = DeviceTechnology(:dmpc)
const DigitalCinemaProjector = DeviceTechnology(:dcpj)

end # module DeviceTechnologies
