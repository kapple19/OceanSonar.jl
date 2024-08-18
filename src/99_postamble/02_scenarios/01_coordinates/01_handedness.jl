export Handedness
export LHanded
export RHanded

abstract type Handedness end

struct LHanded <: Handedness end
struct RHanded <: Handedness end
