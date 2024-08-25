## Attempt #1
# struct SonarMode <: Oac
# 	n_mode::Int8
# end
# const Passive = SonarMode(1)
# const Intercept = SonarMode(2)
# const Active = SonarMode(3)
# const Bistatic = SonarMode(4)

## Attempt #2
# abstract type SonarMode <: Oac end
# struct Passive <: SonarMode end
# struct Intercept <: SonarMode end
# struct Active <: SonarMode end
# struct Bistatic <: SonarMode end

## Attempt #3
@enum SonarMode Passive Intercept Active Bistatic