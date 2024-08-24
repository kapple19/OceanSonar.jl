export sound_speed_profile

ranges = 1e3 * [0, 12.5, 25.0, 37.5, 50.0, 75.0, 100, 125.0, 201.0]
depths = 1e3 * [0, 0.2, 0.7, 0.8, 1.2, 1.5, 2, 3, 4, 5]
sound_speeds = [
	1536 1536 1536 1536 1536 1536 1536 1536 1536
	1506 1508.75 1511.5 1514.25 1517 1520 1524 1528 1528
	1503 1503 1503 1502.75 1502.5 1502 1502 1502 1502
	1508 1507 1506 1505 1504 1503 1501.5 1500 1500
	1508 1506.6 1505 1503.75 1502.5 1500.5 1499 1497 1497
	1497 1497 1497 1497 1497 1497 1497 1497 1497
	1500 1500 1500 1500 1500 1500 1500 1500 1500
	1512 1512 1512 1512 1512 1512 1512 1512 1512
	1528 1528 1528 1528 1528 1528 1528 1528 1528
	1545 1545 1545 1545 1545 1545 1545 1545 1545
	]

itps = [
    LinearInterpolation(sound_speeds[:, n], depths, extrapolate = true)
    for n in eachindex(ranges)
]

rs = copy(ranges)
push!(rs, Inf64)
function sound_speed_profile_(r, z)
    cs = [itp(z) for itp in itps]

    push!(cs, cs[end])
    
    itp = LinearInterpolation(cs, rs, extrapolate = true)
    # @show r
    return itp(r |> abs)
end

myhypot(x, y) = if x == 0
    abs(y)
elseif y == 0
    abs(x)
else
    hypot(x, y)
end

sound_speed_profile(x, y, z) = sound_speed_profile_(myhypot(x, y), z)
