abstract type SpatialInterpolation <: ModelFunction end

(data::SpatialInterpolation)(args::Real...) = data.fcn(args...)

@implement_model_function interpolator

interpolator(::Model{:Linear}) = LinearInterpolation
interpolator(::Model{:CubicSpline}) = CubicSpline

function interpolation(model::Model{M},
    F::AbstractVector{<:Real},
    x::AbstractVector{<:Real};
    extrapolate = true,
    nan_below = true,
    nan_above = true,
    kws...
) where {M}
    @assert length(x) ≥ 2
    @assert issorted(x)
    @assert allunique(x)
    @assert (F, x) .|> length |> allequal
    @assert x .|> isnan |> any |> !

    F_itp = copy(F |> collect)
    x_itp = copy(x |> collect)

    if nan_below && !isinf(x_itp[begin])
        pushfirst!(x_itp, -Inf)
        pushfirst!(F_itp, NaN)
    end

    if nan_above && !isinf(x_itp[end])
        push!(x_itp, Inf)
        push!(F_itp, NaN)
    end

    interpolator(model)(F_itp, x_itp; extrapolate = extrapolate, kws...)
end
