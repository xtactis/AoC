package Day06

import "core:fmt"
import "core:math"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:time"
import "core:unicode"

import AOC ".."

Input :: struct {
    time, dist: int
}

quad :: proc(_a, _b, _c: int) -> (int, int) {
    a, b, c : f64 = f64(_a), f64(_b), f64(_c)
    r1 := (-b + math.sqrt(b*b - 4*a*c)) / (2 * a)
    r2 := (-b - math.sqrt(b*b - 4*a*c)) / (2 * a)
    return int(r1), int(r2)
}

ndigits :: proc(x: int) -> (cnt: int) {
    for x := x; x > 0; x /= 10 do cnt += 1
    return
}

pow :: proc(x: int, e: int) -> int {
    if e == 0 do return 1
    if e&1 == 0 do return pow(x*x, e >> 1)
    return x*pow(x, e-1)
}

solve :: proc(input: []Input) -> (part1, part2: int) {
    part1 = 1
    for i in input {
        r1, r2 := quad(-1, i.time, -i.dist)
        part1 *= math.abs(r2-r1)
    }

    t, d := 0, 0
    for i in input {
        t *= pow(10, ndigits(i.time))
        t += i.time
        d *= pow(10, ndigits(i.dist))
        d += i.dist
    }

    r1, r2 := quad(-1, t, -d)
    part2 = math.abs(r2-r1)

    return
}

parse :: proc(lines: []string) -> (result: []Input) {
    times := AOC.parse_ints(strings.split(lines[0], " ")[1:])
    dists := AOC.parse_ints(strings.split(lines[1], " ")[1:])
    result = make([]Input, len(times))
    for v, i in soa_zip(time=times, dist=dists) {
        result[i] = Input{time = v.time, dist = v.dist}
    }
    return
}

main :: proc() {
    AOC.bench(proc() -> (p1, p2: int) {
        p1, p2 = solve(parse(AOC.get_lines()))
        return
    })
}
