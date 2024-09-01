export uniquesort!
public isalphanumeric

"""
`uniquesort!`

Composition `sort!` then `unique!`.
"""
const uniquesort! = unique! ∘ sort!

"""
`OceanSonar.isalphanumeric(char::AbstractChar)` -> `Bool`

Returns `true` if `char` is inclusively between:

* `'0' ≤ char ≤ '9'`
* `'a' ≤ char ≤ 'z'`
* `'A' ≤ char ≤ 'Z'`
"""
function isalphanumeric(char::AbstractChar)
    '0' ≤ char ≤ '9' && return true
    'a' ≤ char ≤ 'z' && return true
    'A' ≤ char ≤ 'Z' && return true
    return false
end
