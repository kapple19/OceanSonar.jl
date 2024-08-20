function OceanAxis2D(args...;
    yreversed = true,
    xgridvisible = true,
    ygridvisible = true,
    kws...
)
    return Axis(
        args...;
        yreversed = yreversed,
        xgridvisible = xgridvisible,
        ygridvisible = ygridvisible,
        kws...
    )
end
