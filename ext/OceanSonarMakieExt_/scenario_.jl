function visual!(type::Type{<:OceanSonar.Functor}, scen::Scenario)
    visual!(type, scen.slc, 0.0, scen.x)
    return current_figure()
end

function visual!(scen::Scenario)
    visual!(OceanCelerity, scen)
    return current_figure()
end