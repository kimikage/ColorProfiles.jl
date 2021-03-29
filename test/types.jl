using Test, ColorProfiles

using ColorProfiles: UQ1f15

@testset "basic types" begin
    pos = ColorProfiles.Position(0x124, 100)
    @test pos.offset === 0x00000124
    @test pos.size === 0x00000064


end

@testset "Signature" begin
    sig_test = Signature(:Test)
    @test sig_test === Signature{0x54657374}()
    @test ColorProfiles.signature(sig_test) === sig_test
    @test ColorProfiles.idnumber(sig_test) === 0x54657374
    @test string(sig_test) == "Test"
    @test string(Signature()) == ""
    @test_throws ArgumentError string(Signature{0x12345678}())
end

@testset "ProfileClasses" begin
    @test ColorProfiles.signature(InputClass)      === Signature{0x73636E72}()
    @test ColorProfiles.signature(DisplayClass)    === Signature{0x6D6E7472}()
    @test ColorProfiles.signature(OutputClass)     === Signature{0x70727472}()
    @test ColorProfiles.signature(DeviceLinkClass) === Signature{0x6C696E6B}()
    @test ColorProfiles.signature(ColorSpaceClass) === Signature{0x73706163}()
    @test ColorProfiles.signature(AbstractClass)   === Signature{0x61627374}()
    @test ColorProfiles.signature(NamedColorClass) === Signature{0x6E6D636C}()
end