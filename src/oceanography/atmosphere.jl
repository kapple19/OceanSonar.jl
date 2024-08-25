export Atmosphere

include("atmosphere/altimetry.jl")
include("atmosphere/celerity.jl")

Atmosphere() = Medium{:atmosphere}()

function Atmosphere(model)
    cel = AtmosphereCelerity(model)
    Medium{:atmosphere}(model = model, cel = cel)
end