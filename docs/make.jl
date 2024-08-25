using OceanSonar
using Documenter

DocMeta.setdocmeta!(OceanSonar, :DocTestSetup, :(using OceanSonar); recursive=true)

pages = [
    "Ocean Sonar" => "index.md"
    "General" => [
        "Usage" => "general/usage.md"
        "Implementation" => "general/implementation.md"
    ]
    "Oceanography" => [
        "Parameters" => [
            "Celerity" => [
                "Atmosphere" => "oceanography/parameters/celerity/atmosphere.md"
                "Ocean" => "oceanography/parameters/celerity/ocean.md"
                "Seabed" => [
                    "Compressional" => "oceanography/parameters/celerity/seabed/compressional.md"
                    "Shear" => "oceanography/parameters/celerity/seabed/shear.md"
                ]
            ]
            "Density" => [
                "Atmosphere" => "oceanography/parameters/density/atmosphere.md"
                "Ocean" => "oceanography/parameters/density/ocean.md"
                "Seabed" => "oceanography/parameters/density/seabed.md"
            ]
            "Attenuation" => [
                "Atmosphere" => "oceanography/parameters/attenuation/atmosphere.md"
                "Ocean" => "oceanography/parameters/attenuation/ocean.md"
                "Seabed" => [
                    "Compressional" => "oceanography/parameters/attenuation/seabed/compressional.md"
                    "Shear" => "oceanography/parameters/attenuation/seabed/shear.md"
                ]
            ]
        ]
        "Slice" => [
            "Introduction" => "oceanography/environment/intro.md"
            "Boundary" => [
                "Altimetry" => "oceanography/environment/boundary/altimetry.md"
                "Bathymetry" => "oceanography/environment/boundary/bathymetry.md"
            ]
            "Medium" => [
                "Introduction" => "oceanography/environment/medium/intro.md"
                "Atmosphere" => "oceanography/environment/medium/atmosphere.md"
                "Ocean" => "oceanography/environment/medium/ocean.md"
                "Seabed" => "oceanography/environment/medium/seabed.md"
            ]
        ]
    ]
    "Acoustics" => [
        "Scenario" => "acoustics/scenario.md"
        "Reflection" => [
            "Bottom" => "acoustics/reflection/bottom.md"
        ]
        "Propagation" => [
            "Introduction" => "acoustics/propagation/intro.md"
            "Tracing" => [
                "Introduction" => "acoustics/propagation/tracing/intro.md"
                "Rays" => "acoustics/propagation/tracing/rays.md"
                "Beams" => "acoustics/propagation/tracing/beam.md"
                "Grid" => "acoustics/propagation/tracing/grid.md"
            ]
            "Parabolic" => [
                "Marchers" => "acoustics/propagation/parabolic/marcher.md"
            ]
        ]
    ]
]

makedocs(;
    sitename="OceanSonar.jl",
    modules=[OceanSonar],
    authors="Aaron Kaw <aaronjkaw@gmail.com> and contributors",
    format = Documenter.HTML(;
        canonical="https://kapple19.github.io/OceanSonar.jl",
        edit_link = :commit,
        collapselevel = 1,
        assets = String[]
    ),
    pages = pages,
)

deploydocs(;
    repo="github.com/kapple19/OceanSonar.jl",
    devbranch="main",
)
