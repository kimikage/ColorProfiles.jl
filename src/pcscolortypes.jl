"""
    PCSColorTypes

This module defines two color spaces, PCSXYZ and PCSLAB, although they are a
kind of the predefined `XYZ` and `Lab` in `ColorTypes`.
The reason is that PCSXYZ and PCSLAB have a white point of D50, which is
different from the default white point of D65 in Colors.jl.
In other words, PCSXYZ and PCSLAB prevent wrong conversions using the default
conversions in Colors.jl.
Also, `XYZ` does not support `FixedPoint` eltypes and PCSLAB has heterogeneous
encodings which do not match the homogeneous `Lab{T}`.
"""
module PCSColorTypes

using ColorTypes
using FixedPointNumbers
using ..ColorProfiles: UQ1f15

import Base: convert
import ColorTypes: comp1, comp2, comp3

export AbstractPCSXYZ, AbstractPCSLAB
export PCSXYZ, PCSXYZ48, PCSXYZ96
export PCSLAB, PCSLAB24, PCSLAB48, pcsl, pcsa, pcsb
export WP_ICC48, WP_ICC96, WP_ICC

abstract type AbstractPCSXYZ{T <: Real} <: Color{T, 3} end
abstract type AbstractPCSLAB{T <: Real} <: Color{T, 3} end

struct PCSXYZ{T <: Real} <: AbstractPCSXYZ{T}
    x::T
    y::T
    z::T
end

"""
    PCSXYZ48

16-bit representation of `PCSXYZ`.
"""
const PCSXYZ48 = PCSXYZ{UQ1f15}

"""
    PCSXYZ96

32-bit representation of `PCSXYZ`.
This corresponds to `XYZNumber` in the ICC Profile specification except for the
endianness.
"""
const PCSXYZ96 = PCSXYZ{Q15f16}

struct PCSLAB{T <: Real} <: AbstractPCSLAB{T}
    l::T
    a::T
    b::T
end

"""
    PCSLAB24 <: AbstractPCSLAB{Float32}

8-bit representation of `PCSLAB`.
Note that the "apparent" component type of `PCSLAB24` is `Float32`.
The reason for this is that `l` is encoded as an *unsigned* fixed point number,
and `a` and `b` are encoded as *signed* fixed point numbers.
"""
struct PCSLAB24 <: AbstractPCSLAB{Float32}
    l::UInt8
    a::UInt8
    b::UInt8
    function PCSLAB24(l, a::Integer, b::Integer)
        new(round(UInt8, l * 2.55), a + 0x80, b + 0x80)
    end
    function PCSLAB24(l, a, b)
        new(round(UInt8, l * 2.55), round(UInt8, a + 0x80), round(UInt8, b + 0x80))
    end
end

"""
    PCSLAB48 <: AbstractPCSLAB{Float32}

16-bit representation of `PCSLAB`.
Note that the "apparent" component type of `PCSLAB48` is `Float32`.
The reason for this is that `l` is encoded as an *unsigned* fixed point number,
and `a` and `b` are encoded as *signed* fixed point numbers.
"""
struct PCSLAB48 <: AbstractPCSLAB{Float32}
    l::UInt16
    a::UInt16
    b::UInt16
    function PCSLAB48(l, a::Integer, b::Integer)
        new(round(UInt16, l * 655.35), (a + 0x80) * 0x0101, (b + 0x80) * 0x0101)
    end
    function PCSLAB48(l, a, b)
        new(round(UInt16, l * 655.35),
            round(UInt16, (a + 0x80) * 0x0101),
            round(UInt16, (b + 0x80) * 0x0101))
    end
end

pcsl(c::AbstractPCSLAB) = c.l
pcsl(c::PCSLAB24) = c.l * 0.39215687f0 # 100 / 255
pcsl(c::PCSLAB48) = c.l * 1.5259022f-3 # 100 / 65535
pcsa(c::AbstractPCSLAB) = c.a
pcsa(c::PCSLAB24) = Float32(signed(c.a - 0x80))
pcsa(c::PCSLAB48) = c.a * 3.8910506f-3 - 128.0f0 # 128 / 0x8080 = 1 / 257
pcsb(c::AbstractPCSLAB) = c.b
pcsb(c::PCSLAB24) = Float32(signed(c.b - 0x80))
pcsb(c::PCSLAB48) = c.b * 3.8910506f-3 - 128.0f0 # 128 / 0x8080 = 1 / 257

comp1(c::AbstractPCSLAB) = pcsl(c)
comp2(c::AbstractPCSLAB) = pcsa(c)
comp3(c::AbstractPCSLAB) = pcsb(c)

function Base.convert(::Type{Cout}, c::AbstractPCSXYZ) where {Cout <: XYZ}
    Cout(float(c.x), float(c.y), float(c.z))
end
function Base.convert(::Type{Cout}, c::XYZ) where {Cout <: AbstractPCSXYZ}
    Cout(c.x, c.y, c.z)
end
function Base.convert(::Type{Cout}, c::AbstractPCSLAB) where {Cout <: Lab}
    Cout(pcsl(c), pcsa(c), pcsb(c))
end
function Base.convert(::Type{Cout}, c::Lab) where {Cout <: AbstractPCSLAB}
    Cout(c.l, c.a, c.b)
end

const WP_ICC48 = PCSXYZ48(0.9642, 1.0000, 0.8249) # D50
const WP_ICC96 = PCSXYZ96(0.9642, 1.0000, 0.8249) # D50
const WP_ICC = XYZ{Float64}(WP_ICC96)

end # module
