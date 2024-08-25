export uniquesort!
export efficient_sampling

uniquesort! = unique! ∘ sort!

function extract_after_last_period(text::String)
    period_idx = findlast(".", text)
    isnothing(period_idx) && return text
    return text[maximum(period_idx)+1 : end]
end

function efficient_sampling(f::Function, x1::Real, xN::Real, N::Integer)
    # WIP
    range(x1, xN, N)
end

# function efficient_sampling(f::Function, x1::Real, xN::Real, θmin::Real)
#     # WIP
# end