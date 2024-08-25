@kwdef struct ParabolicConfig <: Config
    field_starter::Symbol = :gaussian
    marcher::Symbol = :elastic
    surface::Symbol = :release
    bottom::Symbol = :halfspace
end

function Config(::Val{:parabolic}, args...; kwargs...)
    ParabolicConfig(args...; kwargs...)
end

const default_parabolic_config = ParabolicConfig()