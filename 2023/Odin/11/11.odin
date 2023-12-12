package Day11

import "core:container/queue"
import "core:fmt"
import "core:math"
import "core:os"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:time"
import "core:unicode"

import AOC ".."

Pos :: struct {
    x, y: int
}

Input :: struct {
    galaxies: [dynamic]Pos,
    empty_x: [dynamic]int,
    empty_y: [dynamic]int
}

solve :: proc(input: Input) -> (part1, part2: int) {
    using input
    for g1, i in galaxies[:len(galaxies)-1] {
        for g2 in galaxies[i+1:] {
            part1 += abs(g2.x-g1.x) + abs(g2.y-g1.y)
            part2 += abs(g2.x-g1.x) + abs(g2.y-g1.y)
            for x in empty_x {
                if x < min(g2.x, g1.x) do continue
                if x > max(g2.x, g1.x) do break
                part1 += 2-1
                part2 += 1000000-1
            }
            for y in empty_y {
                if y < min(g2.y, g1.y) do continue
                if y > max(g2.y, g1.y) do break
                part1 += 2-1
                part2 += 1000000-1
            }
        }
    }
    return
}

parse :: proc(lines: []string) -> (result: Input) {
    result.galaxies = make([dynamic]Pos, 0, 8)
    result.empty_x = make([dynamic]int, 0, 8)
    result.empty_y = make([dynamic]int, 0, 8)
    for line, y in lines {
        empty_line := true
        for c, x in line {
            if c == '#' {
                append(&result.galaxies, Pos{x=x, y=y})
                empty_line = false
            }
        }
        if empty_line do append(&result.empty_y, y)
    }
    for x in 0..<len(lines[0]) {
        empty_col := true
        for line in lines {
            if line[x] == '#' do empty_col = false
        }
        if empty_col do append(&result.empty_x, x)
    }
    return
}

main :: proc() {
    AOC.bench(proc() -> (p1, p2: int) {
        p1, p2 = solve(parse(AOC.get_lines()))
        return
    })
}
