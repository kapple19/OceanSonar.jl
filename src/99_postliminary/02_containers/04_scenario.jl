export Scenario

@kwdef mutable struct Scenario <: ModellingContainer
    env::Environment
    own::AbstractEntity
    tgt::AbstractEntity
    fac::AbstractEntity = AbsentEntity()
end

Scenario(::ModelName{:SphericalSpreading}) = Scenario(
    env = Environment(:SphericalSpreading),
    own = Entity{NoiseOnly}(
        NL = 3,
        pos = RectangularCoordinate{DownwardDepth}(
            x = 0,
            y = 0,
            z = env.bot.dpt(0, 0) / 2
        )
    ),
    tgt = Entity{Signaling}(SL = 100.0)
)

Scenario(::ModelName{:CylindricalSpreading}) = Scenario(
    env = Environment(:CylindricalSpreading),
    own = Entity{NoiseOnly}(
        NL = 3,
        pos = RectangularCoordinate{DownwardDepth}(
            x = 0,
            y = 0,
            z = env.bot.dpt(0, 0) / 2
        )
    ),
    tgt = Entity{Signaling}(SL = 100.0)
)

Scenario(::ModelName{:MunkCelerity}) = Scenario(
    env = Environment(:MunkCelerity),
    own = Entity{NoiseOnly}(
        NL = 3,
        pos = RectangularCoordinate{DownwardDepth}(x = 0, y = 0, z = 1e3)
    ),
    tgt = Entity{Signaling}(SL = 100.0)
)

Scenario(::ModelName{:ParabolicBathymetry}) = Scenario(
    env = Environment(:ParabolicBathymetry),
    own = Entity{NoiseOnly}(
        NL = 3,
        pos = RectangularCoordinate{DownwardDepth}(x = 0, y = 0, z = 0)
    ),
    tgt = Entity{Signaling}(SL = 100.0)
)

Scenario(::ModelName{:SquaredRefractionCelerity}) = Scenario(
    env = Environment(:SquaredRefractionCelerity),
    own = Entity{NoiseOnly}(
        NL = 3,
        pos = RectangularCoordinate{DownwardDepth}(x = 0, y = 0, z = 0)
    ),
    tgt = Entity{Signaling}(SL = 100.0)
)
