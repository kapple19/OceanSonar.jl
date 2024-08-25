export visual!
export visual
export boundaryplot!
export boundaryplot
export bivariateplot!
export bivariateplot

"""
```
visual!(pos::Makie.GridPosition, args...)
```
Adds the plotting of `args...` to `pos::Makie.GridPosition`,
where `args...` is the same as in `visual`.

See `@doc visual`.
"""
function visual! end

"""
```
visual(args...)
```

Performs the following:

* Creates a `Makie.Figure` with a single `Makie.GridPosition`.
* Plots according to `args...`
* Flips the y-axis positive-downwards for representing depth.
* Plots the boundaries if such information is available (`Slice` and upward).
* Adds a colorbar if 2D data (`<:Bivariate`) is plotted.
* Adds labels and units.
* Applies a default colouring for distinguishing between the different plots on the axis.

The first argument always specifies what the plotting target is.
There are two ways to specify the plotting target:
instances or types.

Plottable instances are:

* `Altimetry`
* `Bathymetry`
* `<:Celerity` (e.g. `OceanCelerity` instances)
* `<:Density`
* `Slice`
* `Scenario`
* `Beam`
* `Vector{Beam}`
* `Propagation`

The second way to specify the plotting target
is by `arg[2]` an instance of any of the above,
and `arg[1]` an appropriate type contained by the instance inputted as `arg[2]`.

* `Altimetry`
* `Bathymetry`
* `Boundary` plots both the `Altimetry` and `Bathymetry`
* `OceanCelerity`
* `OceanDensity`
* `Beam`

See documentation of the above-listed types for specific `visual` usage documentation.
"""
function visual end

function OceanAxis end

colour(ocnson::OcnSon) = ocnson |> typeof |> colour

function boundaryplot! end
function boundaryplot end

colour(::Type{Altimetry}) = :slateblue1
colour(::Type{Bathymetry}) = :sienna
# colour(::Type{<:Boundary}) = :gray

function bivariateplot! end
function bivariateplot end

colour(::Type{<:Celerity}) = :Blues
colour(::Type{<:Bivariate}) = :jet
colour(::Type{<:Propagation}) = :jet

function rayplot! end
function rayplot end

colour(::Type{<:Beam}) = :black
colour(::Type{<:AbstractVector{<:Beam}}) = colour(Beam)
colour(beams::AbstractVector{<:Beam}) = beams |> typeof |> colour

default_arc_points(beam::Beam) = [
    range(0, beam.s_max, 301); beam.s_srf; beam.s_bot; beam.s_hrz
] |> uniquesort!

function propagationplot! end
function propagationplot end

create_ranges(x1::Real, x2::Real, Nx::Integer) = range(x1, x2, Nx)
create_ranges(scen::Scenario, Nx::Integer) = create_ranges(0.0, scen.x, Nx)
create_ranges(prop::Propagation) = prop.x

create_depths(z1::Real, z2::Real, Nz::Integer) = range(z1, z2, Nz)
create_depths(slc::Slice, xlo::Real, xhi::Real, Nz::Integer) = create_depths(depth_extrema(slc, xlo, xhi)..., Nz)
create_depths(scen::Scenario, Nz::Integer) = create_depths(scen.slc, 0.0, scen.x, Nz)
create_depths(prop::Propagation) = prop.z

square_numbers = [(n, n, n^2) for n in 1:25]
rect_numbers = [(n, n+1, n * (n+1)) for n in 1:25]
rect_and_square_numbers = sort(
    [rect_numbers; square_numbers],
    by = nums -> nums[3]
)

function rect_or_square_gridsize(N::Integer)
    rect_and_square_nums = [numbers[3] for numbers in rect_and_square_numbers]
    idx = findfirst(rect_and_square_nums .≥ N)
    return rect_and_square_numbers[idx][1:2]
end

colourrange(data) = mean(data) .+ 2std(data) * [-1, 1]
colourrange(prop::Propagation) = prop.PL |> colourrange