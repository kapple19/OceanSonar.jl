using OceanSonar
using Test

@test series125(1) == [1]
@test series125(2) == [1, 2]
@test series125(3) == [1, 2, 5]
@test series125(4) == [1, 2, 5, 10]
@test series125(5) == [1, 2, 5, 10, 20]
@test series125(6) == [1, 2, 5, 10, 20, 50]
@test series125(7) == [1, 2, 5, 10, 20, 50, 100]
@test series125(8) == [1, 2, 5, 10, 20, 50, 100, 200]
@test series125(9) == [1, 2, 5, 10, 20, 50, 100, 200, 500]
@test series125(10) == [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000]
@test series125(11) == [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000]
@test series125(12) == [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000]
@test series125(13) == [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000]
@test series125(14) == [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000]
@test series125(15) == [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000]
@test series125(16) == [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000]      
@test series125(17) == [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000]
@test series125(18) == [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000]
@test series125(19) == [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000]
@test series125(20) == [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000, 2000000]
@test series125(21) == [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000, 2000000, 5000000]
@test series125(22) == [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000, 2000000, 5000000, 10000000]
@test series125(23) == [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000, 2000000, 5000000, 10000000, 20000000]
@test series125(24) == [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000, 2000000, 5000000, 10000000, 20000000, 50000000]

@test series125(1.0) == [1.0]
@test series125(2.0) == [1.0, 2.0]
@test series125(3.0) == [1.0, 2.0]
@test series125(4.0) == [1.0, 2.0]
@test series125(5.0) == [1.0, 2.0, 5.0]
@test series125(6.0) == [1.0, 2.0, 5.0]
@test series125(7.0) == [1.0, 2.0, 5.0]
@test series125(8.0) == [1.0, 2.0, 5.0]
@test series125(9.0) == [1.0, 2.0, 5.0]
@test series125(10.0) == [1.0, 2.0, 5.0, 10.0]
@test series125(11.0) == [1.0, 2.0, 5.0, 10.0]
@test series125(12.0) == [1.0, 2.0, 5.0, 10.0]
@test series125(13.0) == [1.0, 2.0, 5.0, 10.0]
@test series125(14.0) == [1.0, 2.0, 5.0, 10.0]
@test series125(15.0) == [1.0, 2.0, 5.0, 10.0]
@test series125(16.0) == [1.0, 2.0, 5.0, 10.0]
@test series125(17.0) == [1.0, 2.0, 5.0, 10.0]
@test series125(18.0) == [1.0, 2.0, 5.0, 10.0]
@test series125(19.0) == [1.0, 2.0, 5.0, 10.0]
@test series125(20.0) == [1.0, 2.0, 5.0, 10.0, 20.0]
