using OceanSonar
using Test

@testset "Subtypes" begin
    @test Exposure <: Passive
    @test Intercept <: Passive
    @test Monostatic <: Active
    @test Bistatic <: Active

    @test Passive <: SonarType
    @test Active <: SonarType

    @test Exposure <: SonarType
    @test Intercept <: SonarType
    @test Monostatic <: SonarType
    @test Bistatic <: SonarType
end

@testset "Invalid Spectral Parameterisations" begin
    @test_throws TypeError Exposure{CW}
    @test_throws TypeError Exposure{FM}
    @test_throws TypeError Intercept{NB}
    @test_throws TypeError Intercept{BB}
    @test_throws TypeError Monostatic{NB}
    @test_throws TypeError Monostatic{BB}
    @test_throws TypeError Bistatic{NB}
    @test_throws TypeError Bistatic{BB}

    @test_throws TypeError Exposure{NBorCW}
    @test_throws TypeError Intercept{NBorCW}

    @test_throws TypeError Active{NBorCW}
    @test_throws TypeError Active{BBorFM}
end

@testset "Specific Subtyping" begin
    @test Exposure{NB} <: Passive
    @test Exposure{BB} <: Passive
    @test Intercept{CW} <: Passive
    @test Intercept{FM} <: Passive
    @test Monostatic{CW} <: Active
    @test Monostatic{FM} <: Active
    @test Bistatic{CW} <: Active
    @test Bistatic{FM} <: Active

    @test Exposure{NB} <: Passive{NB}
    @test Exposure{BB} <: Passive{BB}
    @test Intercept{CW} <: Passive{CW}
    @test Intercept{FM} <: Passive{FM}
    @test Monostatic{CW} <: Active{CW}
    @test Monostatic{FM} <: Active{FM}
    @test Bistatic{CW} <: Active{CW}
    @test Bistatic{FM} <: Active{FM}

    @test !(Exposure{NB} <: Passive{NBorCW})
    @test !(Exposure{BB} <: Passive{BBorFM})
    @test !(Intercept{CW} <: Passive{NBorCW})
    @test !(Intercept{FM} <: Passive{BBorFM})

    @test Exposure{NB} <: Passive{<:NBorCW}
    @test Exposure{BB} <: Passive{<:BBorFM}
    @test Intercept{CW} <: Passive{<:NBorCW}
    @test Intercept{FM} <: Passive{<:BBorFM}
end

@testset "Generic Subtyping" begin
    @test Passive{NBorCW} <: SonarType
    @test Passive{BBorFM} <: SonarType

    @test Passive{NBorCW} <: SonarType{NBorCW}
    @test Passive{BBorFM} <: SonarType{BBorFM}

    @test Passive{NBorCW} <: SonarType{<:NBorCW}
    @test Passive{BBorFM} <: SonarType{<:BBorFM}

    @test Exposure{NB} <: SonarType
    @test Exposure{BB} <: SonarType
    @test Intercept{CW} <: SonarType
    @test Intercept{FM} <: SonarType
    @test Monostatic{CW} <: SonarType
    @test Monostatic{FM} <: SonarType
    @test Bistatic{CW} <: SonarType
    @test Bistatic{FM} <: SonarType

    @test Exposure{NB} <: SonarType{NB}
    @test Exposure{BB} <: SonarType{BB}
    @test Intercept{CW} <: SonarType{CW}
    @test Intercept{FM} <: SonarType{FM}
    @test Monostatic{CW} <: SonarType{CW}
    @test Monostatic{FM} <: SonarType{FM}
    @test Bistatic{CW} <: SonarType{CW}
    @test Bistatic{FM} <: SonarType{FM}

    @test !(Exposure{NB} <: SonarType{NBorCW})
    @test !(Exposure{BB} <: SonarType{BBorFM})
    @test !(Intercept{CW} <: SonarType{NBorCW})
    @test !(Intercept{FM} <: SonarType{BBorFM})

    @test Exposure{NB} <: SonarType{<:NBorCW}
    @test Exposure{BB} <: SonarType{<:BBorFM}
    @test Intercept{CW} <: SonarType{<:NBorCW}
    @test Intercept{FM} <: SonarType{<:BBorFM}
end