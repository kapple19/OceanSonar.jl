export Seabed

include("seabed/bathymetry.jl")
include("seabed/celerity.jl")

Seabed() = Medium{:seabed}()

function Seabed(model)
    cel = SeabedCelerity(model)
    Medium{:seabed}(model = model, cel = cel)
end