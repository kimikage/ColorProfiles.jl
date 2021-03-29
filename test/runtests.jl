using Test, ColorProfiles

@testset "types" begin
    include("types.jl")
end

@testset "PCSColorTypes" begin
    include("pcscolortypes.jl")
end

@testset "header" begin
    include("header.jl")
end

@testset "io" begin
    include("io.jl")
end

@testset "ext FileIO" begin
    include("ext/fileio.jl")
end
