@testset "Celerity" verbose = true begin
    include("atmosphere.jl")
    include("ocean.jl")
    include("seabed.jl")
end