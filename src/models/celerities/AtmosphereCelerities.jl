module AtmosphereCelerities

using ...Structures: Celerity

"""
```
wikipedia
```

Taken from the Wikipedia page for the [https://en.wikipedia.org/wiki/Speed_of_sound](Speed of Sound).
"""
wikipedia(x::Real, z::Real) = Celerity(343.0)

end