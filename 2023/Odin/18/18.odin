package Day18

import "core:builtin"
import "core:container/queue"
import "core:container/priority_queue"
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

Pos :: [2]int
Command :: struct {
    dir: u8,
    len: int,
}
Input :: #soa[dynamic][2]Command

solve :: proc(input: Input) -> (part1, part2: int) {
    calc :: proc(cmds: []Command) -> int {
        d : map[u8]Pos = {
            'U' = {0, -1},
            'R' = {1, 0},
            'D' = {0, 1},
            'L' = {-1, 0}
        }
        pos := Pos{0, 0}
        area := 0
        b := 0
        for cmd in cmds {
            using cmd
            prev := pos
            pos += len*d[dir]
            if dir == 'L' || dir == 'R' {
                area += (prev.x-pos.x) * pos.y
            }
            b += len
        }
        return abs(area)+1+b/2
    }

    a, b := soa_unzip(input[:])
    part1 = calc(a)
    part2 = calc(b)

    return
}

parse :: proc(lines: []string) -> (result: Input) {
    for line, i in lines {
        t := strings.split(line, " ")
        i2d := [4]u8{'R', 'D', 'L', 'U'}
        append_soa(&result, [2]Command{{dir = t[0][0], len = AOC.parse_int(t[1])}, {dir = i2d[t[2][7]-'0'], len = AOC.parse_int(t[2][2:7], 16)}})
        
    }
    return result
}

main :: proc() {
    AOC.bench(proc() -> (p1, p2: int) {
        return solve(parse(AOC.get_lines()))
    })
}
