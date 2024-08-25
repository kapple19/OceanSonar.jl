"""
```
struct Tracer <: OcnSon
```
"""
struct Tracer <: OcnSon
    TraceType::DataType
    def_trace::Function
    prep_init_conds::Function
    def_update_init_conds::Function
end