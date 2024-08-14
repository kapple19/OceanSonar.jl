AcousticInterface{SurfaceInterface}(::ModelName{:Mirror}) = AcousticInterface{SurfaceInterface}(
    dpt = AltimetryProfile(:Flat),
    rfl = ReflectionCoefficientProfile(:Mirror)
)

AcousticInterface{SurfaceInterface}(::ModelName{:Absorbent}) = AcousticInterface{SurfaceInterface}(
    dpt = AltimetryProfile(:Flat),
    rfl = ReflectionCoefficientProfile(:Absorbent)
)

AcousticInterface{SurfaceInterface}(::ModelName{:Translucent}) = AcousticInterface{SurfaceInterface}(
    dpt = AltimetryProfile(:Flat),
    rfl = ReflectionCoefficientProfile(:Translucent; ϕ = π)
)
