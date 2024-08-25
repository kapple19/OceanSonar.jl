using Documenter
using OceanAcoustics

makedocs(
    sitename = "OceanAcoustics",
    format = Documenter.HTML(),
    modules = [OceanAcoustics]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
