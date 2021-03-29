using Test, ColorProfiles

include(joinpath("..", "download.jl"))

@testset "w/o FileIO" begin
    @test length(methods(ColorProfiles.load)) == 0
end

using FileIO

@testset "w/ FileIO" begin
    @test length(methods(ColorProfiles.load)) == 2
end

@testset "before registration" begin
    @test_throws Exception load(profile_path(srgb_v4))
end

@testset "after registration" begin
    add_icc_profile_format()

    profile_from_file = load(profile_path(srgb_v4))
    @test profile_from_file isa ICCProfile
end
