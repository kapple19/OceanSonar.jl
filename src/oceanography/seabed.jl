export Seabed

function Seabed(::Val{:clay})
    cel_sbd = SeabedCelerity(:clay |> Val)
    Medium(cel_sbd)
end