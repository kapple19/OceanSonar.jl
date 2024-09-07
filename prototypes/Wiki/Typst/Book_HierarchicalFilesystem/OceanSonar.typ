//// Setup
// Imports
#import "@preview/unify:0.6.0": unit, qty
#import "@preview/jlyfish:0.1.0": *

// Equations
#set math.equation(numbering: "(1)")
#set cite(form: "prose")

// Pages
#set page(fill: luma(30))
#set text(
  fill: luma(210)
)

// Headings
#show heading.where(level: 1): it => {pagebreak(weak: false); it}
#show heading.where(level: 2): it => {pagebreak(weak: false); it}

// Julia
#read-julia-output(json("OceanSonar-jlyfish.json"))
#jl-pkg("InteractiveUtils", "AbstractTrees")
#jl(```
using InteractiveUtils
using AbstractTrees
```)

//// Document
#align(center, text(17pt)[Ocean Sonar])

// Preamble
#include "preamble/main.typ"

#outline(depth: 3, indent: auto)

#set heading(numbering: "1.1)")

#include "00_background/main.typ"

#jl(code: true, ```
using InteractiveUtils
subtypes(Real)
```)

#jl(code: true, ```
using InteractiveUtils
abstract type MyType end
struct A <: MyType end
abstract type B <: MyType end
struct C <: B end
subtypes(MyType)
```)

#jl(code: true, ```
using AbstractTrees
using InteractiveUtils
AbstractTrees.children(::Type{T}) where {T <: Real} = subtypes(T)
print_tree(Real)
```)

#include "01_oceanography/main.typ"
#include "02_acoustics/main.typ"
#include "03_processing/main.typ"
#include "04_detection/main.typ"

// Appendices
#set heading(numbering: "A.1)")
#counter(heading).update(0)

#include "A_derivations/main.typ"

// Postamble
#set heading(numbering: none)

#include "postamble/main.typ"
