# Checks the `OceanSonar.MathFunctions`:
# * That they work.
# * That they behave like `NaNMath` functions.
using OceanSonar
using Supposition
using InteractiveUtils: subtypes

floats = Supposition.Data.Floats{Float16}()

for fcn_name in names(OceanSonar.MathFunctions)
    fcn_name == :MathFunctions && continue
    @check function behaves_nanlike(x = floats)
        @eval isequal(
            OceanSonar.NaNMath.($fcn_name)(x),
            OceanSonar.($fcn_name)(x)
        )
    end
end

# @check function behaves_nanlike(x = floats)
#     isequal(
#         OceanSonar.NaNMath.sqrt(x),
#         OceanSonar.sqrt(x)
#     )
# end
