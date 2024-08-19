export Medium

@kwdef mutable struct Medium <: ModelContainer
    c::SoundSpeedProfileFunctionType where {SoundSpeedProfileFunctionType <: Function}
end
