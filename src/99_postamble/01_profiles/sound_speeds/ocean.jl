export ocean_sound_speed_profile

@implement_model_function ocean_sound_speed_profile

ocean_sound_speed_profile(::Model{:Homogeneous}, x::Real, y::Real, z::Real; c::Real = 1500.0) = c

function ocean_sound_speed_profile(::Model{:Munk}, x::Real, y::Real, z::Real; ϵ::Real = 7.37e-3)
    z̃ = 2(z/1300 - 1)
    return 1500(
        1 + ϵ * (
            z̃ - 1 + exp(-z̃)
        )
    )
end

function ocean_sound_speed_profile(::Model{:RefractionSquared}, x::Real, y::Real, z::Real; c₀ = 1550)
    return c₀ / sqrt(1 + 2.4z / c₀)
end
