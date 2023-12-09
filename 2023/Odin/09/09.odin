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

N :: 25
dp : [N][N]int
C :: proc(n, k: int) -> int {
    if k == 0 || n == k do return 1
    if dp[n][k] != -1 do return dp[n][k]
    dp[n][k] = C(n-1, k-1) + C(n-1, k)
    return dp[n][k]
}

flip :: proc(x: int) -> int {
    return x % 2 == 0 ? 1 : -1
}

lagrange :: proc(a: []int) -> (p1, p2: int) {
    for x, i in a {
        p1 += x*C(len(a), i)*flip(len(a)-1-i)
        p2 += x*C(len(a), i+1)*flip(i)
    }
    return
}

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
        d1, d2 := lagrange(inp)
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
    AOC.bench(proc() -> (p1, p2: int) {
        for i in 0..<N do for j in 0..<N do dp[i][j] = -1
        p1, p2 = solve(parse(AOC.get_lines()))
        return
    })
}
