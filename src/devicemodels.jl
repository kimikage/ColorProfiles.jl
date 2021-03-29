"""
`DeviceModels` module defines a type for identifying the device model.
See [`DeviceModel`](@ref).
"""
module DeviceModels

using ..ColorProfiles: TypedSignature
export DeviceModel

"""
    DeviceModel{sig}

Currently, the `DeviceModels` module does not define the `DeviceModel` instances
(constants).
See [Device Registry](https://www.color.org/signatureRegistry/deviceRegistry/index.xalter)
in the ICC website.
"""
struct DeviceModel{sig} <: TypedSignature{sig} end

end # module
