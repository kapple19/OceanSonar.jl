using Documenter
using OceanSonar

pages = [
    "Ocean Sonar" => "index.md"
    "Generic" => [
        "Usage" => "generic/usage.md"
        "Implementation" => "generic/implementation.md"
        "Modelling" => "generic/modelling.md"
        "Public API" => "generic/public.md"
        "Developers" => "generic/developers.md"
        "Interpolation" => "generic/interpolation.md"
    ]
    "Oceanography" => [
        "Introduction" => "oceanography/intro.md"
        "Boundary" => [
            "Introduction" => "oceanography/boundary/intro.md"
            "Altimetry" => "oceanography/boundary/altimetry.md"
            "Bathymetry" => "oceanography/boundary/bathymetry.md"
        ]
        "Celerity" => [
            "Introduction" => "oceanography/celerity/intro.md"
            "Atmosphere" => "oceanography/celerity/atmosphere.md"
            "Ocean" => "oceanography/celerity/ocean.md"
            "Seabed" => "oceanography/celerity/seabed.md"
        ]
        "Density" => [
            "Introduction" => "oceanography/density/intro.md"
            "Atmosphere" => "oceanography/density/atmosphere.md"
            "Ocean" => "oceanography/density/ocean.md"
            "Seabed" => "oceanography/density/seabed.md"
        ]
        "Medium" => [
            "Introduction" => "oceanography/medium/intro.md"
            "Atmosphere" => "oceanography/medium/atmosphere.md"
            "Ocean" => "oceanography/medium/ocean.md"
            "Seabed" => "oceanography/medium/seabed.md"
        ]
        "Environment" => "oceanography/environment.md"
    ]
    "Acoustics" => [
        "Introduction" => "acoustics/intro.md"
        "Scenario" => "acoustics/scenario.md"
        "Reflection" => [
            "Introduction" => "acoustics/reflection/intro.md"
            "Surface" => "acoustics/reflection/surface.md"
            "Bottom" => "acoustics/reflection/bottom.md"
        ]
        "Propagation" => [
            "Introduction" => "acoustics/propagation/intro.md"
            "Tracing" => [
                "Introduction" => "acoustics/propagation/tracing/intro.md"
                "Rays" => "acoustics/propagation/tracing/ray.md"
                "Beams" => "acoustics/propagation/tracing/beam.md"
                "Grid" => "acoustics/propagation/tracing/grid.md"
            ]
            "Parabolic" => "acoustics/propagation/parabolic.md"
        ]
    ]
    "Sonar" => [
        "Introduction" => "sonar/intro.md"
    ]
    "Detection" => [
        "Introduction" => "detection/intro.md"
    ]
]

makedocs(
    sitename = "OceanSonar",
    format = Documenter.HTML(
        edit_link = :commit,
        collapselevel = 1
    ),
    modules = [OceanSonar],
    repo = Remotes.GitLab("gitlab.com", "aaronjkaw", "OceanSonar.jl"),
    pages = pages
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
