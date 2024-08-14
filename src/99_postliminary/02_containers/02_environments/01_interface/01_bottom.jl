AcousticInterface{BottomInterface}(::ModelName{:ReflectiveDeep}) = AcousticInterface{BottomInterface}(
    dpt = BathymetryProfile(:Deep),
    rfl = ReflectionCoefficientProfile(:Reflective),
)

AcousticInterface{BottomInterface}(::ModelName{:AbsorbentDeep}) = AcousticInterface{BottomInterface}(
    dpt = BathymetryProfile(:Deep),
    rfl = ReflectionCoefficientProfile(:Absorbent)
)

AcousticInterface{BottomInterface}(::ModelName{:TranslucentDeep}) = AcousticInterface{BottomInterface}(
    dpt = BathymetryProfile(:Deep),
    rfl = ReflectionCoefficientProfile(:Translucent)
)

AcousticInterface{BottomInterface}(::ModelName{:ParabolicBathymetry}) = AcousticInterface{BottomInterface}(
    dpt = BathymetryProfile(:Parabolic),
    rfl = ReflectionCoefficientProfile(:Reflective)
)

AcousticInterface{BottomInterface}(::ModelName{:AbsorbentMesopelagic}) = AcousticInterface{BottomInterface}(
    dpt = BathymetryProfile(:Mesopelagic),
    rfl = ReflectionCoefficientProfile(:Absorbent)
)
