using OceanSonar
using Documenter

DocMeta.setdocmeta!(OceanSonar, :DocTestSetup, :(using OceanSonar); recursive = true)

## Math Engine
# TODO

## Structure
# General
general = joinpath.("general",
    [
        "general.md"
        "index.md"
        "auxiliary.md"
    ]
)

# Sonar Oceanography
dir = joinpath("oceanography", "volume", "celerity")
celerity = joinpath.(dir,
    [
        "celerity.md"
        "ocean_celerity.md"
        "atmosphere_celerity.md"
        "seabed_celerity.md"
    ]
)

dir = joinpath("oceanography", "volume")
volume = [
    "Introduction" => joinpath(dir, "volume.md");
    celerity
]

dir = joinpath("oceanography", "surface")
surface = [
    "Introduction" => joinpath(dir, "surface.md")
]

dir = joinpath("oceanography", "bottom")
bottom = [
    "Introduction" => joinpath(dir, "bottom.md")
]

dir = joinpath("oceanography", "life")
life = [
    "Introduction" => joinpath(dir, "life.md")
]

oceanography = [
    "Introduction" => joinpath("oceanography", "oceanography.md");
    "Volume" => volume
    "Surface" => surface
    "Bottom" => bottom
    "Life" => life
]

# Underwater Acoustics
dir = joinpath("acoustics", "propagation", "trace")
trace = [
    "Introduction" => joinpath(dir, "trace.md")
    joinpath.(dir,
        [
            "ray.md",
            "beam.md"
        ]
    )
]

dir = joinpath("acoustics", "propagation")
propagation = [
    "Introduction" => joinpath(dir, "propagation.md")
    "Tracing" => trace
    joinpath.(dir,
        [
            "parabolic.md"
            "finite.md"
            "normal.md"
            "spectral.md"
        ]
    )
]

dir = joinpath("acoustics", "dispersion")
dispersion = [
    "Introduction" => joinpath(dir, "dispersion.md")
]

dir = joinpath("acoustics", "reflection")
reflection = [
    "Introduction" => joinpath(dir, "reflection.md")
]

dir = joinpath("acoustics", "transmission")
transmission = [
    "Introduction" => joinpath(dir, "transmission.md")
]

dir = joinpath("acoustics", "scattering")
scattering = [
    "Introduction" => joinpath(dir, "scattering.md")
]

acoustics = [
    "Introduction" => joinpath("acoustics", "acoustics.md")
    "Propagation" => propagation
    "Dispersion" => dispersion
    "Reflection" => reflection
    "Transmission" => transmission
    "Scattering" => scattering
]

# Sonar Signal Processing
processing = [
    "Introduction" => joinpath("processing", "processing.md")
]

# Statistical Detection Theory
detection = [
    "Introduction" => joinpath("detection", "detection.md")
]

# Auxiliary
mathematics = [
    "Introduction" => joinpath("auxiliary", "mathematics", "mathematics.md")
    joinpath.(
        joinpath("auxiliary", "mathematics"),
        [
            "interpolation.md"    
            "units.md"
        ]
    )
]

## Build
makedocs(;
    modules = [OceanSonar],
    authors = "Aaron Kaw <aaronjkaw@gmail.com>",
    repo = "https://github.com/kapple19/OceanSonar.jl/blob/{commit}{path}#{line}",
    sitename = "OceanSonar.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://kapple19.github.io/OceanSonar.jl",
        edit_link = "main",
        assets = String[],
    ),
    pages = [
        "Introduction" => "index.md",
        "General" => general,
        "Sonar Oceanography" => oceanography,
        "Ocean Acoustics" => acoustics,
        "Sonar Signal Processing" => processing,
        "Statistical Detection Theory" => detection
    ]
)

## Deployment
deploydocs(;
    repo = "github.com/kapple19/OceanSonar.jl",
    devbranch = "main",
)
