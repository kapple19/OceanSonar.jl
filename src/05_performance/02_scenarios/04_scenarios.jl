export Scenario

@kwdef mutable struct Scenario{
    ownET <: EmissionType,
    tgtET <: EmissionType,
    catET <: EmissionType,
} <: ModelContainer
    env::Environment
    own::Entity{ownET} = Entity(:GenericOwnship)
    tgt::Entity{tgtET} = Entity(:GenericTarget)
    cat::Union{<:Entity{catET}, <:AbsentEntity{catET}} = AbsentEntity{VoidEmission}()
    proc::Processing = NarrowbandProcessing(f = 1e3)
end

Scenario(::Model{:SphericalSpreading}) = Scenario(
    env = Environment(:SphericalSpreading),
)

Scenario(::Model{:SurfaceLloydMirror}) = Scenario(
    env = Environment(:SurfaceLloydMirror),
)

Scenario(::Model{:BottomLloydMirror}) = Scenario(
    env = Environment(:BottomLloydMirror),
)

Scenario(::Model{:CylindricalSpreading}) = Scenario(
    env = Environment(:CylindricalSpreading),
)

Scenario(::Model{:ParabolicBathymetry}) = Scenario(
    env = Environment(:ParabolicBathmyetry),
)

Scenario(::Model{:MunkSoundSpeed}) = Scenario(
    env = Environment(:MunkSoundSpeed),
)

Scenario(::Model{:RefractionSquaredSoundSpeed}) = Scenario(
    env = Environment(:RefractionSquaredSoundSpeed),
)
