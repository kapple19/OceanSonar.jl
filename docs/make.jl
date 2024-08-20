using OceanSonar
using Documenter

sidebar_title(path::String) = if isdir(path)
    basename(path)[4:end]
elseif isfile(path)
    basename(path)[4:end-3]
else
    error("What even is $path?")
end |> titletext

src_dir = joinpath(@__DIR__, "src")

function populate_pages(current_path)
    return if isfile(current_path)
        current_path[length(src_dir)+2 : end]
    elseif isdir(current_path)
        [
            sidebar_title(subpath) => populate_pages(joinpath(current_path, subpath))
            for subpath in readdir(current_path, join = true, sort = true)
            if !contains(subpath, "index.md")
        ]
    else
        error("What even is $current_path?")
    end
end

pages=[
    "Home" => "index.md",
    populate_pages(joinpath(@__DIR__, "src"))...
]

DocMeta.setdocmeta!(OceanSonar, :DocTestSetup, :(using OceanSonar); recursive=true)

makedocs(;
    modules=[OceanSonar],
    authors="Aaron Kaw <aaronjkaw@gmail.com> and contributors",
    sitename="OceanSonar.jl",
    format=Documenter.HTML(;
        canonical="https://kapple19.github.io/OceanSonar.jl",
        edit_link="main",
        collapselevel = 1,
        assets=String[],
    ),
    pages=pages,
)

deploydocs(;
    repo="github.com/kapple19/OceanSonar.jl",
    devbranch="main",
)
