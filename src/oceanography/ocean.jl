export Ocean

include("ocean/celerity.jl")

Ocean() = Medium{:ocean}()

function Ocean(model)
    cel = OceanCelerity(model)
    Medium{:ocean}(model = model, cel = cel)
end