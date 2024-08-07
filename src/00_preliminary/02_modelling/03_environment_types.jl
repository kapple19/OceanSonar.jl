abstract type EnvironmentComponent end

abstract type OceanInterface <: EnvironmentComponent end
abstract type AcousticMedium <: EnvironmentComponent end

struct NotOceanSonarEnvironmentComponent <: EnvironmentComponent end

struct Surface <: OceanInterface end
struct Bottom <: OceanInterface end

struct Atmosphere <: AcousticMedium end
struct Ocean <: AcousticMedium end
struct Seabed <: AcousticMedium end

EnvironmentComponent(::Type) = NotOceanSonarEnvironmentComponent()
EnvironmentComponent(FunctorType::Type{<:ModellingFunctor}) = EnvironmentComponent(FunctorType |> ModellingFunction)
EnvironmentComponent(modelling_instance::ModellingType) = EnvironmentComponent(modelling_instance |> typeof)

children(T::Type{<:EnvironmentComponent}) = subtypes(T)
