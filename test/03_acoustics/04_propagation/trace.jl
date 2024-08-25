using OceanSonar
using Test
using Base.Threads
# using Supposition

@testset "Parabolic Bathymetry Reflection Angles" begin
    N = 301
    r_scales = rand(Float64, N)
    r_maxes = r_scales * OceanSonar.EQUATORIAL_EARTH_CIRCUMFERENCE
    z₀ = 0.0
    z_bty = Bathymetry("Parabolic")
    θ₀s = [atan(1.1z_bty(r_max), r_max) for r_max in r_maxes]
    fan = Fan(
        "Gaussian", θ₀s, 1e3, z₀, maximum(r_maxes),
        OceanCelerity("Homogeneous"),
        z_bty, ReflectionCoefficient("Reflective"),
        Altimetry("Flat"), ReflectionCoefficient("Mirror")
    )
    θ_ends = [beam.θ(beam.s_max) for beam in fan.beams]
    @test isapprox.(θ_ends, 0, atol = 1e-15) |> all
    
    # Too Long
    # floatgen = Data.Floats{Float64}(nans = false)
    # @check function parabolic_bathymetry_reflects_horizontally(r_scale = floatgen)
    #     r_max = OceanSonar.EQUATORIAL_EARTH_CIRCUMFERENCE / (
    #         1 + exp(-r_scale)
    #     )
    #     r_max
    #     z₀ = 0.0
    #     z_bty = Bathymetry("Parabolic")
    #     θ₀ = atan(1.1z_bty(r_max), r_max)
    #     fan = Fan("Gaussian", 1e3, OceanCelerity("Homogeneous"), z_bty, r_max, z₀, [θ₀])
    #     beam = fan.beams[1]
    #     return beam.θ(beam.s_max) == 0
    # end
end
