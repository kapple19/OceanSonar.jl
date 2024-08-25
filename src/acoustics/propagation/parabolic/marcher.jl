struct RationalFunctionApproximation{N} <: Functor
    model::Symbol
    a::NTuple{N, NTuple{2, Float64}}
    b::NTuple{N, Float64}
end

function (rfa::RationalFunctionApproximation)(q::Real)
    numerators = [a[1] + q*a[2] for a in rfa.a]
    denominators = [1.0 + b*q for b in rfa.b]
    return 1.0 + sum(numerators ./ denominators)
end

@parse_models_w_args_kwargs RationalFunctionApproximation

function pade_rfa(m::Integer)
    a_eqn(j, m) = 2 / (2m + 1) * sin(j*π / (2m + 1))^2
    b_eqn(j, m) = cos(j*π / (2m + 1))^2
    return (
        Tuple((0.0, a_eqn(j, m)) for j in 1:m),
        Tuple(b_eqn(j, m) for j in 1:m)
    )
end

function RationalFunctionApproximation(model::Val{:pade}; m::Integer = 2)
    RationalFunctionApproximation(
        model |> modelsymbol,
        pade_rfa(m)...
    )
end

function RationalFunctionApproximation(model::Val{:tappert})
    RationalFunctionApproximation(
        model |> modelsymbol,
        ((0.0, 0.5),),
        (0.0,)
    )
end

function RationalFunctionApproximation(model::Val{:claerbout})
    RationalFunctionApproximation(
        model |> modelsymbol,
        pade_rfa(1)...
    )
end

function RationalFunctionApproximation(model::Val{:greene})
    RationalFunctionApproximation(
        model |> modelsymbol,
        ((0.99987 - 1, 0.79624 - 0.30102),),
        (0.30102,)
    )
end