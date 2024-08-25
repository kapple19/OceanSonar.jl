export ocean_attenuation
export OceanAttenuation

@implement_modelling ocean_attenuation 3

function ocean_attenuation(::Val{:jensen}, x::Real, y::Real, z::Real; f::Real)
    f_khz = 1e-3f
    f²_khz = f_khz^2
    3.3e-3 + 0.11f²_khz / (1 + f²_khz) + 44f²_khz / (4100 + f²_khz) + 3e-4f²_khz
end
