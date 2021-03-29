using Test, ColorProfiles

@testset "read_xyz" begin
    buf = IOBuffer([
        0x00, 0x01, 0x00, 0x00,
        0x00, 0x00, 0x80, 0x00,
        0x00, 0x00, 0x00, 0x01,
        ])

    @test ColorProfiles.read_xyz(buf) === XYZ{Float64}(1.0, 0.5, 1 / 65536)
end
