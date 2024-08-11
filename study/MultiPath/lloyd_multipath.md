# Case Study: Ocean Acoustics Lloyd's Mirror Multipath in Julia and MATLAB

In response to [this comment](https://discourse.julialang.org/t/julia-has-ruined-my-work-experience/116556/2?u=kapple) which was itself a response to my Discourse post griping about MATLAB at work,
I've dug into a case study in my field of work comparing development and performance in MATLAB with Julia.
Admittedly I've really gone overboard in responding to Steven's comment,
but this was fun to work on as a little side project.

Factors under consideration in this case study are:

* Amount of workarounds.
* Variety of implementation options (i.e. scripting, function, OOP(-like), etc.).
* Execution performance.
* Code reuseability.
* MATLAB toolbox/Julia package enhancements.
* Code profiling and quality tooling.
* Development ease.

If any of you have improvement suggestions for any of my implementations below, I'd love to know. I need to use MATLAB at work so improving my use of it will just make my experience with it less negative. Also, for those more experienced in other language, It'd be awesome to compare with them as well, particularly Python and C++ (I'm not touching C++, even though I'm somewhat experienced with it). For the base post of this thread, I think two languages is plenty enough.

Consider this a "Part Two" of my public venting on the mental health drainer that is the MATLAB programming language.

Machine Specification: TODO.

The topic of this case study is the Lloyd's Mirror Multipath in the context of long-range ocean acoustics.
[Lloyd's Mirror](https://en.wikipedia.org/wiki/Lloyd%27s_mirror) is the phenomenon of TODO.
[Multipath propagation](https://en.wikipedia.org/wiki/Multipath_propagation) refers to the fact that acoustics from a source to a point in space experience reflections off acoustic boundaries multiple times during the propagation. The contribution of all multipaths is an important consideration in acoustic models, and no less so in ocean sonar modelling where the index of refraction can vary significantly enough across space that many rays can get trapped in waveguides known as surface ducts or deep sea sound channels. It is even TODO in detection in calculating the Closest Point of Approach in ocean sonar.

For this case study, the ocean model is significantly simplified as is done in introductory texts on ocean sonar:

* The ocean sound speed and density is modelled as homogeneous, with the only propagation attenuation modelled as spherical spreading loss, i.e. absorption and scattering are ignored/assumed non-existent.

* There are many long-range ocean acoustic propagation solution methods, but the most convenience for our study is [ray tracing](https://en.wikipedia.org/wiki/Ray_tracing_(graphics)). Since our ocean environment is homogeneous, we don't need to worry about solving a differential equation for this, and will be modelling rays under some form of TODO (something about images).

* The ocean boundaries (surface and seabed) will be flat. Some long-range ocean acoustic models do apply the curvature of the earth in the solution process, which will be ignored in this study.

* The ocean boundaries will be perfectly reflective. Additionally, the surface will flip the phase.

* The acoustic source and receiver as modelled as point-wise omni.

* No acoustic interference effects are considered, such as ambient noise, self noise, etc.

All implementations will first be tested on replicating Figure 1.9 of Jensen, et al. (2019) where propagation loss under Lloyd's mirror for a simple two-ray case is shown to approximate double the spherical spreading loss in decibels with range.

## Modelling Preliminaries

### Identifiers

* `r`: Range [m] across ocean
* `z`: Depth [m] in the ocean, positive downwards
* `s`: Acoustic ray arc length [m]
* `p`: Acoustic pressure [μPa], complex-valued
* `PL`: Acoustic propagation loss [dB]

### Abbreviations

| Abbreviation | Expansion |
| ---          | ---       |
| rcv          | receiver  |
| src          | source    |

### Control Variables

Ocean surface at `z == 0` [m].

| Control Variable              | Value    |
| ---                           | ---      |
| Ocean sound speed             | 1500 m/s |
| Acoustic Frequency            | 150 Hz   |
| Maximum Range                 | 5 km     |
| Number of Ranges (equispaced) | 501      |
| Bathymetry Depth              | 500 m    |
| Acoustic Source Depth         | 25 m     |
| Acoustic Receiver Depth       | 200 m    |

### Benchmarking Summary Preview

## Symbolics in Julia vs MATLAB

## Scripting in Julia vs MATLAB

```julia
using OffsetArrays
using CairoMakie

# Controls
c = 1500.0
f = 150.0
r_max = 5e3
r_rcvs = range(0, r_max, 501)
z_bty = 500
z_src = 25
z_rcv = 200

r_mid = r_max/2
k = 2π * f / c

# Images
num_pairs = 5
pair_indices = ceil(Int, 0.25 - num_pairs/2) : floor(Int, 0.25 + num_pairs/2)

z_bty_imgs = z_bty * pair_indices
z_src_imgs = z_bty_imgs .+ (z_src * [-1 1])
s_rays = [hypot(z, r) for z in z_src_imgs, r in r_rcvs] # surprised and happy this worked so naturally
R_cml_rays = [isodd(index) ? -1 : 1 for index in pair_indices]
p_rays = @. R_cml_rays * cis(k * s_rays)

PL_rays = @. -20log10(p_rays |> abs)

fig = Figure()
axis = Axis(fig[1, 1], yreversed = true)

for z_bty_img in z_bty_imgs
  lines!(axis, [0, r_max], fill(z_bty_img, 2), color = :black)
end
scatter!.(axis, 0, z_src_imgs, color = :blue)
lines!(axis, r_rcvs, fill(z_rcv, size(r_rcvs)), linestyle = :dash, color = :red)
for z_src_img in z_src_imgs
  lines!(axis, [0, r_mid], [z_src_img, z_rcv], color = :blue)
end

# lines!(axis, r_rcvs, s_rays[1, 1, :])

# for n in eachindex(pair_indices)
#   lines!(axis, r_rcvs, PL_rays[n, 1, :])
#   lines!(axis, r_rcvs, PL_rays[n, 2, :])
# end

# limits!(axis, 0, r_max, 40, 90)

display(fig)
```

Development ease:

* This treatise was developed in a Markdown file, and I could execute the above code directly in VS Code without needing to copy-paste between here and a `*.jl` file. In contrast, MATLAB must run code in a `*.m` file (or `*.mlx`, compared with `Jupyter` in another section below).

## Julia's `Unitful.jl` vs MATLAB's TODO

## Julia's `NamedTuple` vs MATLAB's `struct`

## Julia's `Dict`ionary vs MATLAB's `dictionary`

## Functions in Julia vs MATLAB

## Vectorising in Julia vs MATLAB

The typical Julia user knows that generally you can implement an algorithm on scalar inputs/the smallest minimalisation of the algorithm as needed, and various options are available as `broadcast`ing or `map`ping or comprehensions or...

In MATLAB, TODO.

## Julia's `struct` vs Matlab's `classdef`

## Julia's `module` vs MATLAB's Packaging

## Julia in Jupyter notebooks vs MATLAB's Live Scripts

## Julia's `Pluto`

## Conclusions

### Other Julia vs MATLAB Comparison Notes

* Unicode. Need I say more?

* MATLAB Toolbox prices vs Julia's open source.

* Multiline editing in VS Code vs MATLAB GUI.

* Regular expressions in VS Code vs MATLAB GUI.

On top of all of the above points, MATLAB has been "in the game" for years, and they keep building unintuitive and poor design choices on top of unintuitive poor design choices. And people and organisations are paying out of their butts for base MATLAB plus toolboxes, and they're still behind in quality and performance. Some simple functions and tools in MATLAB are behind paywalls! Julia is much younger, and is already significantly competitive on multiple fronts.

### Note on Mental Health

While I acknowledge that the monotropic theory of autism is still just a theory,
I feel like it explains me well. TODO. TODO: intense hobby.

Most of the time, after a programming session in Julia, learning things in Julia makes me feel smarter. Programming in MATLAB makes me feel dumber. I feel like MATLAB gets in the way of my academic development, whereas Julia enables it.

### Julia Rebuttals

I just want to take up the space to address the criticism that people give Julia when compared with Python: "Python has a larger ecosystem."

I like the title of Alan Edelman's presentation titled ["A programming language to heal the planet together: Julia"](https://www.youtube.com/watch?v=qGW0GT1rCvs&t=179s) (I really dislike that the camera keeps panning around). If a language's core features are preferable regardless of the ecosystem size, then for humanity's long-term benefit, we should be working to build that language's ecosystem together. Sticking to Python because it has a larger.

There are contexts where Python is better than Julia, such as the urgency of results in a workplace's environment. But when an ecosystem's functionality is not urgently needed, I see it as the unselfish choice to TODO.

## References
