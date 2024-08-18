@kwdef mutable struct Performance
    model::Model{M} where {M} = Model{:Bistatic}

    ownship::PresentEntity
    target::PresentEntity
    catalyst::AbstractEntity
end

function (perf::Performance)()
    Sonar
end
