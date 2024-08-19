export Processing

abstract type Processing <: ModelContainer end

@kwdef mutable struct NarrowbandProcessing <: Processing
    f::Float64
end

@kwdef mutable struct BroadbandProcessing <: Processing

end

@kwdef mutable struct InterceptProcessing <: Processing
    
end
