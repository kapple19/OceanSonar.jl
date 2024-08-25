export ocnson_sqrt

num_fcn(fcn::Function, args::Num...) = Term(fcn, [args...]) |> wrap

for op in (:sqrt, :cos, :sin, :cossin)
    op_string = String(op)
    ocnson_op = Symbol("ocnson_" * op_string)
    nan_op = Symbol("nan_" * op_string)
    eval(
        quote
            $ocnson_op(x::Real) = $nan_op(x)
            $ocnson_op(x::Num) = $op(x)
            $ocnson_op(x::Interval) = $op(x)
        end
    )
end

ocnson_hypot(args::Number...) = nan_hypot(args...)
ocnson_hypot(args::Union{<:Num, <:Interval}...) = hypot(args...)
