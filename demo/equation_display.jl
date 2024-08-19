using OceanSonar
using Symbolics
using Latexify
using CairoMakie

@variables z, ϵ

symbolic_equation = ocean_sound_speed_profile(:Munk, 0, 0, z; ϵ = ϵ)
temp_latex_equation = latexify(symbolic_equation)
latex_equation = replace(latex_equation |> String,
    "\\begin{equation}" => "",
    "\\end{equation}" => "",
    "\n" => ""
) |> Latexify.LaTeXString
text(0, 0, text = latex_equation, align = (:center, :center))
