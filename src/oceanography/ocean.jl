export Ocean

function Ocean(::Val{:munk_profile})
    cel = OceanCelerity(Val(:munk))
    Medium(cel)
end