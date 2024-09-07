# Ocean Sonar Development Notes

I have so many iterations,
because all the layers depend on each other.
My discoveries on such are documented below.

## Models

Have a `Model` type that stores a model name as a `Symbol`.
Functions will dispatch off of `Model`.

## Profiles

Two types of models:

* Pure mathematical functions.
* Interpolated off data.

Types of metric profiles for modelling:

* Sound speed.
* Bathymetry.
* Reflection coefficient.

Three layers:

1. Data-interpolated models stored in a dictionary.
2. Pure mathematical functions implemented as `Model`led function, and falls back to dictionary.
3. Functor that subtypes `Function` for use in higher level containers.

Thus need a generalised system of `struct`ures that store the interpolated data
as well as the interpolation function.

TODO: Figure out which layers of profiles and propagation need coordinate transforms.

## Propagation

Layers:

1. Propagation models implemented in purest form as a function.
2. `Propagation2D` and `Propagation3D` `struct`s that dispatch off `Model` instance.
3. Some `Propagation3D` models are defined as repeated `Propagation2D` models.

## Sonar

```julia
abstract type TransmittingStatus end
abstract type ReceivingStatus end

struct NotTransmitting <: TransmissionStatus end
struct Transmitting <: TransmissionStatus end

struct NotReceiving <: ReceivingStatus end
struct Receiving <: ReceivingStatus end
```

Parametric `Entity{<:TransmissionStatus, <:ReceivingStatus}` type for dispatching.

```julia
struct Propagation
    SL
    PL
    TS
    NL
    AG
    RL
    SNR
    DT
    SE
    POD
end

function Propagation(env::Environment, proc::Processing, ents::AbstractVector{<:Entity})
    # hmm
end
```

## Sonar (Old)

Parametric `Entity{<:EmissionType}` type for dispatching sonar term calculations:

1. Sonar term calculations implemented in individual functions, dependent on numeric parameters.
2. Sonar terms (`source_level`, `target_strength`, etc.) dispatch off `own::Entity{ownET}`, `tgt::Entity{tgtET}`, and `cat::Entity{catET}` ("catalyst").
3. `Performance` calls the sonar term functions for appropriate respective dispatch.
   1. `Propagation` is called once for `own` and `cat`, and used twice each for `propagation_loss` and `reverberation_level`.
