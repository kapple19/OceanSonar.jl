#import "@preview/diverential:0.2.0": *
#import "@preview/jlyfish:0.1.0": *

#set page(numbering: "1 of 1")
#set heading(numbering: "1.1)")
#set math.equation(numbering: "(1)")
#show table.cell.where(y: 0): strong
#set cite(form: "prose")

#show raw.where(block: true): block.with(
  fill: luma(220),
  inset: 10pt,
  radius: 4pt,
)

#show raw.where(block: false): box.with(
  fill: luma(220),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

#let cis = $upright("cis")$

#let avec = $arrow(a)$
#let bvec = $arrow(b)$

#read-julia-output(json("ParabolicEquations-jlyfish.json"))
#jl-pkg(
  "AlgebraOfGraphics",
  "CairoMakie",
  "Makie",
  "MethodInspector",
  "Symbolics",
  "Typstry"
)

#align(center,
  text(size: 17pt, weight: "bold")[
    Parabolic Equations in Ocean Acoustics
  ]
)

#outline()

= Background

== Programming

This document uses #link("https://julialang.org/")[Julia], along with the following Julia packages:

#jl(code: true,
```julia
using AlgebraOfGraphics
using CairoMakie
using Makie
using MethodInspector
using Symbolics
using Typstry
```)

Some auxiliary code definitions follow.

Convenience pluralisation of a word

#jl(code: true,
```julia
pluralise(::Val{S}) where {S} = string(S, "s")
pluralise(s::AbstractString) = pluralise(s |> Symbol |> Val)

function pluralise(val::Number, desc::AbstractString)
  string(val, " ", val == 1 ? desc : pluralise(desc |> Symbol |> Val))
end
```)

== Mathematics

The function $cis$ is a convenience defined as

$
cis(x) := exp(i x)
$

Cylindrical coordinates are expressed in terms of
horizontal range $r$,
azimuth $phi$ (orientation not required for this document),
and depth $z$ which is positive downwards.

Wave theory variables applied for ocean acoustics used include
angular wavenumber $k$,
sound speed $c in RR$ ($c in CC$ might be explored)
("c" stands for celerity which is synonymous to speed),
index of refraction $n in RR$,
acoustic pressure $p in CC$,
displacement potential $psi in CC$.

= Derivation

The 3D Helmholtz equation for a constant-density medium in cylindrical coordinates:

$
1/r dvp(, r) (r dvp(p, r))
+ 1/r^2 dvp(p, phi, deg: 2)
+ dvp(p, z, deg: 2)
+ omega^2 / (c^2(r, phi, z)) p
= 0
$

Assuming azimuthal symmetry,

$
dvp(p, r, deg: 2) + 1/r dvp(p, r) + dvp(p, z, deg: 2) + k_0^2 n^2 p = 0
$ <2D-cylindrical-helmholtz-azimuthal-symmetry>

where

#table(columns: 2,
  [$p(r, z)$], [pressure],
  [$k_0 = omega \/ c_0$], [reference wavenumber],
  [$n(r, z) = c_0 \/ c(r, z)$], [index of refraction]
)

== Standard PE Derivation

Assume solution form

$
p(r, z) = psi(r, z) H_0^((1))(k_0 r)
$ <tappert-solution-form>

which is a cylindrical wave solution.
It is assumed that $psi(r, z)$ slowly varies with range.

$H_0^((1))(k_0 r)$ is the Hankel function which satisfies the Bessel differential equation.
We replace it by its asymptotic form for $k_0 r >> 1$:

$
H_0^((1))(k_0 r) approx sqrt(2 / (pi k_0 r)) cis(k_0 r - pi/4)
$ <hankel-function-asymptotic>

Substituting @tappert-solution-form into @2D-cylindrical-helmholtz-azimuthal-symmetry:

$
dvp(psi, r, deg: 2)
+ (
  2 / (H_0^((1))(k_0 r)) dvp(
    H_0^((1))(k_0 r),
    r
  ) + 1 / r
) dvp(psi, r)
+ dvp(psi, z, deg: 2)
+ k_0^2 (n^2 - 1) psi
= 0
$ <2D-cylindrical-tappert>

Apply the farfield assumption $k_0 r >> 1$ along with @hankel-function-asymptotic
to @2D-cylindrical-tappert:

$
dvp(psi, r, deg: 2) + 2 i k_0 dvp(psi, r) + dvp(psi, z, deg: 2) + k_0^2 (n^2 - 1) psi = 0
$ <2D-cylindrical-elliptic-wave-equation>

The paraxial approximation is

$
dvp(psi, r, deg: 2) << 2 i k_0 dvp(psi, r)
$ <paraxial-approximation>

which, applied to @2D-cylindrical-elliptic-wave-equation yields

$
2 i k_0 dvp(psi, r) + dvp(psi, z, deg: 2) + k_0^2 (n^2 - 1) psi = 0
$ <standard-parabolic-equation>

== Generalised PE Derivation

Introduce operators

$
p &= dvp(, r) & Q &= sqrt(
  n^2 + 1 / k_0^2 dvp(, z, deg: 2)
)
$

Write @2D-cylindrical-elliptic-wave-equation in the form

$
[P^2 + 2 i k_0 P + k_0^2 (Q^2 - 1)] psi = 0
$

Factor into incoming and outgoing components:

$
(P + i k_0 - i k_0 Q) (P + i k_0 + i k_0 Q) psi - i k_0 [P, Q] psi = 0
$

where

$
[P, Q] psi = P Q psi - Q P psi
$

For range-independent media, $[P, Q] psi = 0$.

Isolating the outgoing component:

$
P psi = i k_0 (Q - 1) psi
$

or

$
dvp(psi, r) = i k_0 (
  sqrt(
    n^2 + 1 / k_0^2 dvp(, z, deg: 2)
  ) - 1
) psi
$ <2D-generalised-parabolic-equation>

which is a one-way wave equation,
which for range-independent environments is exact within the limits of the farfield approximation.

=== Summary of Approximations for Derivation

+ Farfield, i.e. $k_0 r >> 1$.
+ Commutator is negligible, i.e. $[P, Q] psi = 0$.
+ Backscattering is negligible, i.e. the one-way wave component has been isolated.

== Expansion of the Square-Root Operator

Define the follosing abbreviation conveniences

$
epsilon &= n^2 - 1 \
mu &= 1 / k_0^2 dvp(, z, deg: 2) \
q &= epsilon + mu
$

so

$
Q = sqrt(1 + q)
$

which we implement in Julia as

#jl(code: true,
```julia
square_root_operator(q::Number) = sqrt(1 + q)
```)

Taylor series of $Q$:

$
Q = sqrt(1 + q) = 1 + q/2 - q^2/8 + q^3/16 + ...
$

which requires $|q| < 1$ for convergence.
This requirement is equivalent to the paraxial approximation (@paraxial-approximation).
See @representations-of-the-paraxial-approximation for an excursion into showing that
when the reference sound speed is taken to be the sound speed at the
acoustic source, we obtain

$
q = -sin^2(theta_0)
$

where $theta_0$ is the initial angle of acoustic propagation in consideration,
and we note that the small $q$ requirement
is thus equivalent to a small $theta_0$ requirement,
i.e. the paraxial approximation.
We thus take continue considering our Taylor expansion of $Q$ about $q = 0$
with this property in mind.

We shall hereforth explore approximations of the form

$
Q = sqrt(1 + q) approx 1 + sum_(j = 1)^m (a_(j, m) q) / (1 + b_(j, m) q)
$ <square-root-approximator-form>

for upper triangular matrices $a = [a_(j, m)]$ and $b = [b_(j, m)]$
for $j in 1, 2, ..., m$ and $m = 1, 2, ..., M$
with $M$ the number of terms in the expansion.

Our first example of a square root approximator is attributed to Tappert.
It is obtained by retaining only the first two terms ($M = 1$) of $Q$
in its Taylor expansion, which is equivalent to

$
a &= [0.5] \
b &= [0]
$

which yields

$
Q &approx 1 + q/2 \
&= 1 + (n^2 - 1) / 2 + 1 / (2 k_0^2) dvp(, z, deg: 2)
$

Substitution into @2D-generalised-parabolic-equation
yields the standard parabolic equation (@standard-parabolic-equation).

=== Implementations of the Square-Root Operator

The Julia structure containing the square-root operator coefficients
is implemented as holding offset vectors (base-index 0)
for `a` and `b` coefficients:

#jl(code: true,
```julia
struct SquareRootApprox{M}
  a::Vector{Float64}
  b::Vector{Float64}

  function SquareRootApprox(a::AbstractVector{<:Real}, b::AbstractVector{<:Real})
    M = length(a)
    @assert M == length(b)
    new{M}(a, b)
  end
end
```)

and we implement `SquareRootApprox` instances as functors by:

#jl(code: true,
```julia
getM(Q::SquareRootApprox{M}) where {M} = M

(Q::SquareRootApprox{M} where {M})(q::Number) = 1.0 + sum(
  Q.a[m] * q / (1 + Q.b[m] * q) for m in 1:getM(Q)
)
```)

Amalgamation of @2D-generalised-parabolic-equation
with @square-root-approximator-form
leads to

$
A_1 dvp(psi, r)
+ A_2 dvp(psi, #($x$, 2), r)
= A_3 psi
+ A_4 dvp(psi, z, deg: 2)
$ <2D-compact-parabolic-wave-equation>

where

$
A_1 &= b_0 + b_1 (n^2 - 1) \
A_2 &= b_1 / k_0^2 \
A_3 &= i k_0 [
  (a_0 - b_0) + (a_1 - b_1) (n^2 - 1)
] \
A_4 &= (a_1 - b_1) i / k_0
$

@2D-compact-parabolic-wave-equation can be solved by finite-difference
or finite-element techniques.
However, only the Tappert equation
--- which has $A_2 = 0$ ---
can be solved by the split-step Fourier technique.


Some specific approximations#footnote[
  I will next need to explore the derivations
  of the coefficient values for the square root approximators.
  Some of the representations given by @jensen-et-al
  are difficult to represent in the generalised form of
  @square-root-approximator-form.
]:

#jl(code: true,
```julia
SquareRootApprox(::Val{:Tappert}) = SquareRootApprox([0.5], [0.0])
# SquareRootApprox(::Val{:Greene}) = SquareRootApprox(0.99987, 0.79624, 1, 0.30102)
greene_square_root_approx(q::Number) = (0.99987 + 0.79624q) / (1 + 0.30102q)
SquareRootApprox(::Val{:Pade}, M::Int) = SquareRootApprox(
  [2 / (2M + 1) * sin(m*π / (2M + 1))^2 for m in 1:M],
  [cos(m*π / (2M + 1))^2 for m in 1:M]
)
SquareRootApprox(::Val{:Claerbout}) = SquareRootApprox(:Pade |> Val, 2)
```)

For example,

#jl(code: true,
```julia
Qpade = SquareRootApprox(:Pade |> Val, 3)
```)

and then evaluate as

#jl(code: true,
```julia
Qpade(1.0)
```).

Let's compare them to the square root operator.

#jl(code: true,
```julia
@show SquareRootApprox(:Tappert |> Val)
@show SquareRootApprox(:Claerbout |> Val)
```)

#jl(code: true,
```julia
let
  @variables q
  Q = SquareRootApprox(:Tappert |> Val)
  Q(q) |> println
end
```)

#jl(code: true,
```julia
function plot_square_root_approximators()
  # TODO
end
```)

#figure(kind: image,
  caption: [Comparing the square root operator with its approximators.],
  align(left, jl(code: true, ```julia plot_square_root_approximators()```))
)

=== Phase Errors

Let's view the square root approximation models implemented.

#jl(code: true,
```julia
function plot_phase_errors()
  getmodel(::Type{Val{M}}) where {M} = M

  models = [
    [
      arg_type |> getmodel
      for arg_type in arg_types(method)
      if arg_type <: Val
    ] |> only
    for method in methods(SquareRootApprox)
    if any(arg_types(method) .<: Val)
  ]
  
  θ₀ = 0 : 0.1 : 90
  q = @. -sind(θ₀)^2
  Q = square_root_operator.(q)

  fig = Figure()
  axes = Dict(
    2e-3 => Axis(fig[1, 1]),
    2e-4 => Axis(fig[2, 1]),
  )

  for Ethresh in keys(axes)
    axis = axes[Ethresh]
    ylims!(axis, 0, 5Ethresh)
    hlines!(axis, Ethresh, linestyle = :dash, color = :black)
    axis.xticks = 0 : 15 : 90
    axis.yticks = 0 : Ethresh : 5Ethresh
  end

  for model in models
    for M in 1 : (model == :Pade ? 5 : 1)
      Qapprox = if model == :Pade
        SquareRootApprox(model |> Val, M)
      else
        SquareRootApprox(model |> Val)
      end

      E = abs.(Q - Qapprox.(q))
      for Ethresh in keys(axes)
        lines!(axes[Ethresh], θ₀, E, label = string(model, " (", pluralise(M, "Term"), ")"))
      end
    end
  end

  fig[:, 2] = Legend(fig, axes[2e-3], "Trig Functions", framevisible = true)

  fig
end
```)

#figure(kind: image,
  caption: [Replicating Figure 6.1 of @jensen-et-al],
  align(left, jl(code: true, ```julia plot_phase_errors()```))
)

#counter(heading).update(0)
#set heading(numbering: "A)")

#pagebreak()
= Representations of the Paraxial Approximation
<representations-of-the-paraxial-approximation>

Consider a trial plane-wave solution of the form

$
psi = cis(k_r r plus.minus k_z z)
$ <trial-plane-wave-solution>

where the wavenumbers and propagation angle $theta$ are related as

$
k^2 &= k_r^2 + k_z^2 \
sin(theta) &= plus.minus k_z / k
$

We note that applying the operator $mu$ to @trial-plane-wave-solution
is equivalent to multiplication of $psi$ by $k_z^2$, so

$
mu &= 1 / k_0^2 dvp(, z, deg: 2)
&= - k_z^2 / k_0^2
$

Also noting that under Snell's law, $n = k \/ k_0$, so substituting for $theta$ then yields

$
mu &= - k^2 / k_0^2 sin^2(theta) \
&= -n^2 sin^2(theta)
$

Snell's law again as $cos(theta_0) \/ cos(theta) = n$ yields

$
q &= epsilon + mu \
&= (n^2 - 1) - n^2 sin^2(theta) \
&= -sin^2(theta_0)
$

If we select $c_0$ as the sound speed at the source,
then $q$ becomes dependent only on the source radiation angle $theta_0$.
The small $q$ requirement for Taylor series convergence
thus implies small source radiation angle $theta_0$
which is equivalent to the paraxial approximation.

#bibliography(
  title: "Bibliography",
  style: "iso-690-author-date",
  "bib.yml"
)
