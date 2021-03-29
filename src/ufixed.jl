
    # minimal implementation of unsiged fixed types

import Base: *
import FixedPointNumbers: showtype

struct UQ16f16 <: FixedPoint{UInt32, 16}
    i::UInt32
    UQ16f16(i::Integer, _) = new(i % UInt32)
end
struct UQ1f15 <: FixedPoint{UInt16, 15}
    i::UInt16
    UQ1f15(i::Integer, _) = new(i % UInt16)
end
struct UQ8f8 <: FixedPoint{UInt16, 8}
    i::UInt16
    UQ8f8(i::Integer, _) = new(i % UInt16)
end

UQ16f16(x::AbstractFloat) = UQ16f16(round(UInt32, x * oftype(x, 0x1p16)), 0)
UQ1f15(x::AbstractFloat) = UQ1f15(round(UInt16, x * oftype(x, 0x1p15)), 0)
UQ8f8(x::AbstractFloat) = UQ8f8(round(UInt16, x * oftype(x, 0x1p8)), 0)

function UQ16f16(x::Integer)
    ((0x0 <= x) & (x <= 0xffff)) || throw(ArgumentError("UQ16f16 cannot represent $x"))
    UQ16f16((x % UInt32) << 0x10, 0)
end
function UQ1f15(x::Integer)
    ((0x0 <= x) & (x <= 0x1)) || throw(ArgumentError("UQ1f15 cannot represent $x"))
    UQ1f15((x % UInt16) << 0xf, 0)
end
function UQ8f8(x::Integer)
    ((0x0 <= x) & (x <= 0xff)) || throw(ArgumentError("UQ8f8 cannot represent $x"))
    UQ8f8((x % UInt16) << 0x10, 0)
end

(::Type{T})(x::Union{UQ16f16, UQ1f15, UQ8f8}) where {T <: AbstractFloat} = convert(T, x)

Base.convert(T::Type{<:AbstractFloat}, x::UQ16f16) = T(x.i * T(0x1p-16))
Base.convert(T::Type{<:AbstractFloat}, x::UQ1f15) = T(x.i * T(0x1p-15))
Base.convert(T::Type{<:AbstractFloat}, x::UQ8f8) = T(x.i * T(0x1p-8))

(*)(x::Real, ::Type{UF}) where {UF <: Union{UQ16f16, UQ1f15, UQ8f8}} = UF(x)

showtype(io::IO, ::Type{UQ16f16}) = write(io, "UQ16f16")
showtype(io::IO, ::Type{UQ1f15}) = write(io, "UQ1f15")
showtype(io::IO, ::Type{UQ8f8}) = write(io, "UQ8f8")
