export uniquesort!

macro initialise_function()
    return quote
        function _ end
    end
end

const uniquesort! = unique! ∘ sort!

function isalphanumeric(char::AbstractChar)
    '0' ≤ char ≤ '9' && return true
    'a' ≤ char ≤ 'z' && return true
    'A' ≤ char ≤ 'Z' && return true
    return false
end

cossin = reverse ∘ sincos

function cis(theta::Real)
    c, s = cossin(theta)
    Complex(c, s)
end
