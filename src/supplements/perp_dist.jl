function perpendicular_distance(
    line_point::NTuple{2, <:Real},
    line_gradient::Real,
    point::NTuple{2, <:Real}
)
    a = line_gradient
    b = -1.0
    c = line_point[2] - line_gradient * line_point[1]

    x0, y0 = point

    d = abs(a*x0 + b*y0 + c) / √(a^2 + b^2)
end

function perpendicular_displacement(
    line_point::NTuple{2, <:Real},
    line_gradient::Real,
    point::NTuple{2, <:Real}
)
    a = line_gradient
    b = -1.0
    c = line_point[2] - line_gradient * line_point[1]

    x0, y0 = point

    d = (a*x0 + b*y0 + c) / √(a^2 + b^2)
end