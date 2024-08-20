using OceanSonar
using Documenter
using Base.Filesystem: basename, path_separator

src_dir = joinpath(@__DIR__, "src")

hell = 1

function sidebar_title(abs_subpath)
    abs_subpath
    filename = basename(abs_subpath)
    @assert !isempty(filename)
    first = findfirst(r"[A-Z]|[a-z]", filename)[1]
    final = contains(filename, ".") ? findlast('.', filename)[1] - 1 : length(filename)
    return filename[first:final] |> titletext
end

function populate_pages(abs_path)
    return if isfile(abs_path)
        replace(abs_path, src_dir * path_separator => "")

    elseif isdir(abs_path)
        [
            sidebar_title(abs_subpath) => populate_pages(abs_subpath)
            for abs_subpath in readdir(abs_path, join = true, sort = true)
            if abs_subpath != joinpath(src_dir, "index.md")
        ]

    else
        error("Unrecognised path: $abs_path.")
    end
end

pages = [
    "Home" => "index.md",
    populate_pages(src_dir)...
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
