export altimetry
export Altimetry

altimetry(::Val{:flat}, ::Real) = 0.0

@add_model_conversion_methods altimetry

Altimetry() = Boundary{:altimetry}()
Altimetry(model) = Boundary{:altimetry}(model)

function (bnd::Boundary{:altimetry})(args...; kwargs...)
    altimetry(bnd.model, args...; kwargs...)
end