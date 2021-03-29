using Test, ColorProfiles

include("download.jl")

@testset "read_icc_profile" begin
    @testset "$srgb_v4" begin
        profile = read_icc_profile(profile_path(srgb_v4))

        @test profile isa ICCProfile
        @test profile.header.magic === ColorProfiles.ICC_MAGIC_NUMBER
        table = profile.table
        @test length(table) == 9
        @test table[1] isa ProfileDescriptionTag
        @test table[2] isa AToB0Tag
        @test table[3] isa AToB1Tag
        @test table[4] isa BToA0Tag
        @test table[5] isa BToA1Tag
        @test table[6] isa PerceptualRenderingIntentGamutTag
        @test table[7] isa MediaWhitePointTag
        @test table[8] isa CopyrightTag
        @test table[9] isa ChromaticAdaptationTag

        @info srgb_v4 * "\n" * table[ColorProfiles.sig"cprt"].text
    end
end