using Test, ColorProfiles
using FixedPointNumbers
using ColorProfiles: UQ1f15

@testset "PCSXYZ" begin
    pcsxyz48 = PCSXYZ48(0.0, 1.0, 1 + (32767 / 32768))
    @test pcsxyz48.x === reinterpret(UQ1f15, 0x0000)
    @test pcsxyz48.y === reinterpret(UQ1f15, 0x8000)
    @test pcsxyz48.z === reinterpret(UQ1f15, 0xffff)

    pcsxyz96 = PCSXYZ96(-32768.0, 1.0, 32767 + (65535 / 65536))
    @test pcsxyz96.x === reinterpret(Q15f16, signed(0x80000000))
    @test pcsxyz96.y === reinterpret(Q15f16, signed(0x00010000))
    @test pcsxyz96.z === reinterpret(Q15f16, signed(0x7fffffff))
end

@testset "PCSLAB" begin
    pcslab24_min = PCSLAB24(0.0, -128.0, -128.0)
    @test pcslab24_min.l === 0x00
    @test pcslab24_min.a === 0x00
    @test pcslab24_min.b === 0x00
    @test pcsl(pcslab24_min) === 0.0f0
    @test pcsa(pcslab24_min) === -128.0f0
    @test pcsb(pcslab24_min) === -128.0f0

    pcslab24_max = PCSLAB24(100.0, 127.0, 127.0)
    @test pcslab24_max.l === 0xff
    @test pcslab24_max.a === 0xff
    @test pcslab24_max.b === 0xff
    @test pcsl(pcslab24_max) === 100.0f0
    @test pcsa(pcslab24_max) === 127.0f0
    @test pcsb(pcslab24_max) === 127.0f0

    pcslab48_min = PCSLAB48(0.0, -128.0, -128.0)
    @test pcslab48_min.l === 0x0000
    @test pcslab48_min.a === 0x0000
    @test pcslab48_min.b === 0x0000
    @test pcsl(pcslab48_min) === 0.0f0
    @test pcsa(pcslab48_min) === -128.0f0
    @test pcsb(pcslab48_min) === -128.0f0

    pcslab48_max = PCSLAB48(100.0, 127.0, 127.0)
    @test pcslab48_max.l === 0xffff
    @test pcslab48_max.a === 0xffff
    @test pcslab48_max.b === 0xffff
    @test pcsl(pcslab48_max) === 100.0f0
    @test pcsa(pcslab48_max) === 127.0f0
    @test pcsb(pcslab48_max) === 127.0f0
end

@testset "white/black point" begin
    @test WP_ICC48.x === reinterpret(UQ1f15, 0x7b6b)
    @test WP_ICC48.y === reinterpret(UQ1f15, 0x8000)
    @test WP_ICC48.z === reinterpret(UQ1f15, 0x6996)

end