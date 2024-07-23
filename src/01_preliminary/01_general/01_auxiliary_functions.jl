export uniquesort!
export efficient_sampling
export output_extrema

const uniquesort! = unique! ∘ sort!

const cossin = reverse ∘ sincos
const nan_cossin = reverse ∘ nan_sincos
const cossind = reverse ∘ sincosd
const magang(z::Number) = (abs(z), angle(z))

function extract_all_underscored_alphanumeric_bodies(text::AbstractString)
    idxs = findall(r"([a-z]|[A-Z]|[0-9]|_)+", text)
    return getindex.(text, idxs)
end

function extract_first_underscored_alphanumeric_bodies(text::AbstractString)
    return extract_all_underscored_alphanumeric_bodies(text)[1]
end

function extract_last_underscored_alphanumeric_bodies(text::AbstractString)
    return extract_all_underscored_alphanumeric_bodies(text)[end]
end

function efficient_sampling(f::Function, x1::Real, xN::Real, N::Integer)
    # WIP, to be replaced
    range(x1, xN, N)
end

# function efficient_sampling(f::Function, x1::Real, xN::Real, θmin::Real)
#     # WIP
# end

output_extrema(f::Function, ntv::Interval) = (:lo, :hi) .|> bnd -> getproperty(f(ntv).bareinterval, bnd)
output_extrema(f::Function, x_lo::Real, x_hi::Real) = output_extrema(f, interval(x_lo, x_hi))
