@kwdef mutable struct Performance
    model::Model{M} where {M} = Model{:Bistatic}

    ownship::Entity
    target::Entity
    catalyst::AbstractEntity
end

function (perf::Performance)()
    Sonar
end
