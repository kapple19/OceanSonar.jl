using Documenter
using OceanSonar

oceanography = [
    "Overview" => "oceanography.md"
    "Surface" => [
        "Overview" => "oceanography/surface.md"
        "Wind" => "oceanography/surface/wind.md"
        "Density" => "oceanography/surface/density.md"
        "Celerity" => "oceanography/surface/celerity.md"
        "Altimetry" => "oceanography/surface/altimetry.md"
        "Classification" => "oceanography/surface/classification.md"
    ]
    "Volume" => [
        "Overview" => "oceanography/volume.md"
        "Density" => "oceanography/volume/density.md"
        "Salinity" => "oceanography/volume/salinity.md"
        "Celerity" => "oceanography/volume/celerity.md"
    ]
    "Bottom" => [
        "Overview" => "oceanography/bottom.md"
        "Density" => "oceanography/bottom/density.md"
        "Celerity" => "oceanography/bottom/celerity.md"
        "Classification" => "oceanography/bottom/classification.md"
        "Bathymetry" => "oceanography/bottom/bathymetry.md"
    ]
]

acoustics = [
    "Overview" => "acoustics.md"
    "Reflection" => [
        "Overview" => "acoustics/reflection.md"
        "Fluid-to-Fluid" => "acoustics/reflection/fluid_to_fluid.md"
        "Fluid-to-Solid" => "acoustics/reflection/fluid_to_solid.md"
        "Solid-to-Fluid" => "acoustics/reflection/solid_to_fluid.md"
        "Surface" => "acoustics/reflection/surface.md"
        "Bottom" => "acoustics/reflection/bottom.md"
    ]
    "Propagation" => [
        "Propagation" => "acoustics/propagation.md"
        "Ray Tracing" => "acoustics/propagation/ray.md"
        "Parabolic Equation" => "acoustics/propagation/parabolic.md"
        "Normal Mode" => "acoustics/propagation/normal.md"
        "Spectral" => "acoustics/propagation/spectral.md"
        "Finite Difference/Element" => "acoustics/propagation/finite.md"
    ]
]

pages = [
    "Sonar Oceanography" => oceanography
    "Ocean Acoustics" => acoustics
]

makedocs(
    sitename = "OceanSonar",
    format = Documenter.HTML(),
    modules = [OceanSonar],
    pages = pages
)