export VoidEmission
export NoiseOnly
export Signaling

abstract type EmissionType end

struct VoidEmission <: EmissionType end
struct NoiseOnly <: EmissionType end
struct Signaling <: EmissionType end
