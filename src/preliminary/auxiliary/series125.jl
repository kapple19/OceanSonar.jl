export series125

series125_(::Val{0}, type::Type{<:Integer} = Int) = 1 |> type
series125_(::Val{1}, type::Type{<:Integer} = Int) = 2 |> type
series125_(::Val{2}, type::Type{<:Integer} = Int) = 5 |> type
series125_(::Val{N}, type::Type{<:Integer} = Int) where N = 10series125_(N-3 |> Val, type)

series125_(N::Integer, type::Type{<:Integer} = Int) = series125_(N |> Val, type)

function series125(N::Integer, type::Type{<:Integer} = Int)
    series = series125_.(0:N-1, type)
    if any(series .< 0)
        error("Integer overflow, try `series125(N, BigInt)`.")
    end
    return series
end

function series125(M::AbstractFloat, type::Type{<:Integer} = Int)
    series = Float64[]
    n = -1
    while true
        n += 1
        S = series125_(n, type)
        if S ≤ M
            push!(series, S)
        else
            return series
        end
    end
end