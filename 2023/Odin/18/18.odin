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
    hex: string
}
Input :: []Command


solve :: proc(input: Input) -> (part1, part2: int) {
    grid : map[Pos]struct{}
    pos := Pos{0, 0}
    d : map[u8]Pos = {
        'U' = {0, -1},
        'R' = {1, 0},
        'D' = {0, 1},
        'L' = {-1, 0}
    }
    miny, maxy, minx, maxx := 0, 0, 0, 0
    for cmd in input {
        using cmd
        for i in 0..<len {
            pos += d[dir]
            grid[pos] = {}
            miny = min(miny, pos.y)
            maxy = max(maxy, pos.y)
            minx = min(minx, pos.x)
            maxx = max(maxx, pos.x)
        }
    }

    fmt.println(miny, maxy, minx, maxx)
    for y in (miny+1)..<maxy {
        hits := 0
        for x in minx..<maxx {
            if ({x, y}) in grid && ({x+1, y}) not_in grid {
                hits += 1
                continue
            }
            if hits % 2 == 1 && ({x, y}) not_in grid {
                part1 += 1
            }
        }
    }
    fmt.println(part1)

    part1 += len(grid)
    return
}

parse :: proc(lines: []string) -> (result: Input) {
    result = make(Input, len(lines))
    for line, i in lines {
        t := strings.split(line, " ")
        result[i] = Command{dir = t[0][0], len = AOC.parse_int(t[1]), hex = t[2]}
        
    }
    return result
}

main :: proc() {
    AOC.bench(proc() -> (p1, p2: int) {
        return solve(parse(AOC.get_lines()))
    })
}
