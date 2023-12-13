package Day13

import "core:container/queue"
import "core:fmt"
import "core:math"
import "core:os"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:thread"
import "core:time"
import "core:unicode"

import AOC ".."

Row :: bit_set[0..<32;u32]

Input :: struct {
    rows: []Row,
    cols: []Row,
}

find_reflect :: proc(pattern: []Row, p2: bool=false) -> (res: int, ok: bool) {
    outer: for reflection_point in 1..<len(pattern) {
        diff := 0
        for i in 0..<reflection_point {
            j := 2*reflection_point-i-1
            if j >= len(pattern) do continue
            diff += card(pattern[i] ~ pattern[j])
            if diff == 0 do continue
            if diff > 1 || !p2 do continue outer
        }
        if (p2 && diff == 1) || (!p2 && diff == 0) do return reflection_point, true
    }
    return 0, false
}

solve :: proc(input: [][]string) -> (part1, part2: int) {
    rows := make([dynamic]Row, 0, 32)
    cols := make([dynamic]Row, 0, 32)
    for spattern in input {
        clear(&rows)
        clear(&cols)
        for _ in spattern[0] do append(&cols, Row{})
        for line, i in spattern {
            append(&rows, Row{})
            for c, j in line {
                if c == '#' {
                    rows[i] += {j}
                    cols[j] += {i}
                }
            }
        }
        
        part1 += find_reflect(cols[:]) or_else (find_reflect(rows[:]) or_else 0)*100
        part2 += find_reflect(cols[:], true) or_else (find_reflect(rows[:], true) or_else 0)*100
    }
    return
}

parse :: proc(lines: string) -> (result: [][]string) {
    tmp := strings.split(lines, "\n\n")
    result = make([][]string, len(tmp))
    for t, i in tmp {
        result[i] = strings.split_lines(t)
    }
    return
}

main :: proc() {
    AOC.bench(proc() -> (p1, p2: int) {
        p1, p2 = solve(parse(AOC.get_input()))
        return
    })
}
