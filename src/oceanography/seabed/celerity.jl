export seabed_celerity
export SeabedCelerity

seabed_celerity(::Val{:jensen_clay}, ::Real, ::Real) = 1500.0
seabed_celerity(::Val{:jensen_gravel}, ::Real, ::Real) = 1800.0
seabed_celerity(::Val{:jensen_basalt}, ::Real, ::Real) = 5250.0
seabed_celerity(::Val{:jensen_sand}, ::Real, ::Real) = 1650.0

@add_model_conversion_methods seabed_celerity

SeabedCelerity() = Celerity{:seabed}()
SeabedCelerity(model) = Celerity{:seabed}(model)

function (cel::Celerity{:seabed})(args...; kwargs...)
    seabed_celerity(cel.model, args...; kwargs...)
end