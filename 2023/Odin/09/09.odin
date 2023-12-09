package Day09

import "core:fmt"
import "core:math"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:time"
import "core:unicode"

import AOC ".."

Input :: [][]int

extrapolate_iter :: proc(a: []int) -> (p1, p2: int) {
    last := len(a)-1
    p1, p2 = a[last], a[0]
    for !(a[0] == 0 && a[last] == 0) {
        for e, i in a[1:last+1] {
            a[i] = e-a[i]
        }
        last -= 1
        p1 += a[last]
        p2 = (len(a)-1 - last) % 2 == 1 ? p2 - a[0] : p2 + a[0]
    }
    return
}

extrapolate :: proc(a: []int) -> (p1, p2: int) {
    if a[0] == 0 && a[len(a)-1] == 0 do return 0, 0
    for e, i in a[1:] {
        a[i] = e-a[i]
    }
    first := a[0]
    d1, d2 := extrapolate(a[:len(a)-1])
    p1, p2 = a[len(a)-2] + d1, first - d2
    return
}

solve :: proc(input: Input) -> (part1, part2: int) {
    for inp in input {
        d1, d2 := extrapolate_iter(inp)
        part1 += d1
        part2 += d2
    }
    return
}

parse :: proc(lines: []string) -> (result: Input) {
    result = make(Input, len(lines))
    for line, i in lines {
        result[i] = AOC.parse_ints(strings.split(line, " "))
    }
    return
}

main :: proc() {
    x := 0b10101
    start := time.now()
    p1, p2 := solve(parse(AOC.get_lines()))
    fmt.println(time.since(start))
    fmt.printf("%d\n%d\n", p1, p2)
}
