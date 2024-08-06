density_profile(::Val{:one}, x::Real; a::Real)::Float64 = x + a

struct DensityProfile{F <: Function}
    profile::F

    function DensityProfile(model::Val; pars...)
        profile(x::Real)::Float64 = density_profile(model, x; pars...)
        new{typeof(profile)}(profile)
    end
end

function (den::DensityProfile{F} where {F <: Function})(x::Real)
    den.profile(x)::Float64
end
