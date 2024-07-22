using OceanSonar
using Documenter

DocMeta.setdocmeta!(OceanSonar, :DocTestSetup, :(using OceanSonar); recursive=true)

makedocs(;
    modules=[OceanSonar],
    authors="Aaron Kaw <aaronjkaw@gmail.com> and contributors",
    sitename="OceanSonar.jl",
    format=Documenter.HTML(;
        canonical="https://kapple19.github.io/OceanSonar.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/kapple19/OceanSonar.jl",
    devbranch="main",
)
