"""
The purpose of this test is to:

* Ensure the `::MetricFunction`s run without error.
* Ensure that the model output is "stable" to the model name input form, i.e. `Symbol`, `String`, or `Model`.
"""

using OceanSonar
using Supposition
using Test
using InteractiveUtils

floatgen = Supposition.Data.Floats()

@testset "$fcn_type" for fcn_type in subtypes(OceanSonar.MetricFunction)
    fcn = fcn_type()
    @testset "$model_title" for model_title in listmodels(fcn)
        model = Model(model_title)
        model_symbol = Symbol(model)
        model_string = String(model)
        model_forms = [model, model_symbol, model_string, model_title]

        for arguments in listarguments(fcn, model)
            inputs = arguments.inputs

            if isempty(inputs)
                @test allequal(model_forms .|> fcn)
                continue
            end

            if length(inputs) == 1
                @check function stability(x = floatgen)
                    allequal(
                        [
                            fcn(model_form, x)
                            for model_form in model_forms
                        ]
                    )
                end
                continue
            end

            error("Stability test for $(inputs |> length) inputs not implemented.")
        end
    end
end
