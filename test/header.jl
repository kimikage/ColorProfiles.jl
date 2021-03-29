using Test, ColorProfiles

include("download.jl")

@testset "read_icc_header" begin
    @testset "$srgb_v4" begin
        header = ICCProfileHeader()
        open(profile_path(srgb_v4), "r") do f
            header = ColorProfiles.read_icc_header(f)
        end

        @test header isa ICCProfileHeader
    end

    #@test header.size === 1
end
