#import "@preview/jlyfish:0.1.0": *

#set math.equation(numbering: "(1)")

#jl-pkg(
  "CairoMakie"
)
#read-julia-output(json("OceanSonarSimpleMultipath-jlyfish.json"))

= Ocean Sonar Simple Multipath

== Direct Ray

#jl(recompute: false, code: true,
```
f(x) = x^2
```
)

#jl(recompute: false, code: true,
```
f(2)
```
)
