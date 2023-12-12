package Day12

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

Input :: []string

find_vertical_reflect :: proc(pattern: Input, p2: bool=false) -> (res: int, ok: bool) {
    for reflection_point in 1..<len(pattern[0])-0 {
        cp2 := p2
        found := true
        current: for row in pattern {
            for i in 0..<reflection_point {
                j := 2*reflection_point-i-1
                if j >= len(row) do continue
                if row[i] != row[j]  {
                    if cp2 {
                        cp2 = false
                        continue
                    }
                    found = false
                    break current
                }
            }
        }
        if p2 && cp2 do continue
        if found do return reflection_point, true
    }
    return 0, false
}

find_horizontal_reflect :: proc(pattern: Input, p2: bool = false) -> (res: int, ok: bool) {
    for reflection_point in 1..<len(pattern)-0 {
        found := true
        cp2 := p2
        current: for i in 0..<reflection_point {
            j := 2*reflection_point-i-1
            if j >= len(pattern) do continue
            for k in 0..<len(pattern[i]) {
                if pattern[i][k] != pattern[j][k] {
                    if cp2 {
                        cp2 = false
                        continue
                    }
                    found = false
                    break current
                }
            }
        }
        if p2 && cp2 do continue
        if found do return reflection_point*100, true
    }
    return 0, false
}

solve :: proc(input: []Input) -> (part1, part2: int) {
    for pattern in input {
        part1 += find_vertical_reflect(pattern) or_else (find_horizontal_reflect(pattern) or_else 0)
        part2 += find_horizontal_reflect(pattern, true) or_else (find_vertical_reflect(pattern, true) or_else 0)
    }
    return
}

parse :: proc(lines: string) -> (result: []Input) {
    tmp := strings.split(lines, "\n\n")
    result = make([]Input, len(tmp))
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
