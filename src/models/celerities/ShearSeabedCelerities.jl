module ShearSeabedCelerities

using ...Structures: Celerity

"""
Taken from Table 1.3 of Jensen, et al (2011).
"""
clay = Celerity(50.0)

"""
Taken from Table 1.3 of Jensen, et al (2011).
"""
silt = Celerity((x, z) -> 80z^0.3)

"""
Taken from Table 1.3 of Jensen, et al (2011).
"""
sand = Celerity((x, z) -> 110z^0.3)

"""
Taken from Table 1.3 of Jensen, et al (2011).
"""
gravel = Celerity((x, z) -> 180z^0.3)

"""
Taken from Table 1.3 of Jensen, et al (2011).
"""
moraine = Celerity(600.0)

"""
Taken from Table 1.3 of Jensen, et al (2011).
"""
chalk = Celerity(1000.0)

"""
Taken from Table 1.3 of Jensen, et al (2011).
"""
limestone = Celerity(1500.0)

"""
Taken from Table 1.3 of Jensen, et al (2011).
"""
basalt = Celerity(2500.0)

end