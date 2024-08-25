export Atmosphere

function Atmosphere(::Val{:standard})
    cel_atm = AtmosphereCelerity(:standard |> Val)
    Medium(cel_atm)
end