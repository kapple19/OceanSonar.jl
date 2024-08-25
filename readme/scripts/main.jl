# This script generates the `readme.md` file for the OceanSonar.jl package.

using CairoMakie

badges = [
    "Stable" => "https://img.shields.io/badge/docs-stable-blue.svg)](https://kapple19.github.io/OceanSonar.jl/stable/"
    "Dev" => "https://img.shields.io/badge/docs-dev-blue.svg)](https://kapple19.github.io/OceanSonar.jl/dev/"
    "Build Status" => "https://github.com/kapple19/OceanSonar.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/kapple19/OceanSonar.jl/actions/workflows/CI.yml?query=branch%3Amain"
    "Aqua" => "https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl"
]

link_definitions = [
    "Aqua.jl" => "https://docs.juliahub.com/Aqua"
    "Documenter.jl" => "https://documenter.juliadocs.org/stable"
    "JET.jl" => "https://aviatesk.github.io/JET.jl"
    "Julia" => "https://docs.julialang.org/en"
    "Latexify.jl" => "https://korsbo.github.io/Latexify.jl/stable"
    "LiveServer.jl" => "https://tlienart.github.io/LiveServer.jl"
    "Makie.jl" => "https://docs.makie.org/stable/"
    "ModelingToolkit.jl" => "https://docs.sciml.ai/ModelingToolkit/stable"
    "Plots.jl" => "https://docs.juliaplots.org/stable"
    "PropCheck.jl" => "https://seelengrab.github.io/PropCheck.jl/stable"
    "Symbolics.jl" => "https://docs.sciml.ai/Symbolics/stable"
] |> sort!

academics = [
    "Abraham, D. A. (2019). _Underwater Acoustic Signal Processing: Modeling, Detection, and Estimation_. Springer."
    "Ainslie, M. A. (2010). _Principles of Sonar Performance Modelling_. Springer."
    "Jensen, F. B., Kuperman, W. A., Porter, M. B., & Schmidt, H. (2011). _Computational Ocean Acoustics_ (2nd Ed.). Springer."
    "Lurton, X. (2016). _An Introduction to Underwater Acoustics: Principles and Applications_ (2nd Ed.). Springer."
] |> sort!

software = [
    "Documenter"
    "LiveServer"
    "Aqua"
    "JET"
    "PropCheck"
    "Latexify"
] |> sort!

struct Demo
    desc::String
    filenames::Vector{String}
end

Demo(desc::String, filename::String) = Demo(desc, [filename])

function present(io::IO, demo::Demo)
    println(io, demo.desc)
    println(io)

    for filebarename in demo.filenames
        codename = filebarename * ".jl"
        codepath = joinpath("readme", "scripts", codename)
        code_string = read(codepath, String)

        println(io, "```julia")
        println(io, code_string)
        println(io, "```")
        println(io)

        sym = Symbol(codename)
        m = Module(sym)
        # Core.eval(m, :(eval(x) = Core.eval($m, x)))
        Core.eval(m, :(include(x) = Base.include($m, abspath(x))))
        # codefullpath = abspath(codepath)
        # output = invokelatest(m.include, codefullpath)
        output = @eval m include($codepath)

        if output isa Nothing
            println(io, "In development.")
        elseif output isa AbstractString
            print(io, output)
        elseif output isa Figure
            outputpath = "readme/img/" * filebarename * ".svg"
            save(outputpath, output)
            println(io, "![", outputpath, "](", outputpath, ")")
        else
            error("""
            Unrecognised expression evaluation output
            from file $codename:
            $(output |> typeof).
            """)
        end
        println(io)
    end
end

demos = [
    Demo(
        "Acoustic ray tracing", [
            "munk_profile_rays", "parabolic_bathymetry_rays"
        ]
    )
    Demo(
        "Visualise frequency changes (issues with CairoMakie image saving)",
        "lloyd_mirror_freq_perturb"
    )
    Demo(
        "Compare square root operator approximations for the parabolic equation",
        "lloyd_mirror_sqrt_approxers"
    )
    Demo(
        "Visualise the equation for an OceanSonar.jl model",
        "munk_profile_eqn"
    )
]

function write_readme_file()
    open("readme.md"; write = true) do file
        println(file, "# OceanSonar.jl")
        println(file)

        for badge in badges
            println(file, "[![", badge.first, "](", badge.second, ")") 
        end
        println(file)

        for link in link_definitions
            println(file, "[", link.first, "]: ", link.second)
        end
        println(file)

        println(file, read("readme/texts/introduction.md", String))
        println(file)
        
        println(file, "## Usage")
        println(file)
        println(file, read("readme/texts/usage.md", String))
        println(file)
        
        println(file, "## Demonstration")
        println(file)

        for demo in demos
            present(file, demo)
        end

        println(file, read("readme/texts/implementation.md", String))

        println(file, "## Citation")
        println(file)

        println(file, "Cite this work with [`citation.bib`](citation.bib):")
        println(file)
        println(file, "```verbatim")
        println(file, read("citation.bib", String))
        println(file, "```")
        println(file)

        println(file, "### Academic Bibliography")
        println(file)
        
        for ref in academics
            println(file, "> ", ref)
            println(file)
        end

        println(file, "### Software Bibliography")
        println(file)

        println(file, "No citation provided:")
        println(file)
        for ref in software
            println(file, "* [", ref, ".jl]")
        end
        println(file)

        println(file, "Provided citations:")
        for ref in readdir("readme/refs")
            println(file)
            println(file, "```bibtex")
            println(file, read("readme/refs/" * ref, String))
            println(file, "```")
        end
    end
end

write_readme_file()
