package Day16

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

Pos :: struct {
    x, y, direction: u8
}

Input :: []string

move :: proc(p: Pos, dir: u8) -> Pos {
    switch dir {
    case 0: return Pos{p.x+1, p.y, dir}
    case 1: return Pos{p.x, p.y+1, dir}
    case 2: return Pos{p.x-1, p.y, dir}
    case 3: return Pos{p.x, p.y-1, dir}
    }
    panic("AAAAAAA")
}

solve_one :: proc(input: Input, start: Pos) -> (res: int) {
    been := make([][][]bool, len(input))
    for &b in been {
        b = make([][]bool, len(input[0]))
        for &bb in b {
            bb = make([]bool, 4)
        }
    }
    q : queue.Queue(Pos)
    queue.init(&q)
    queue.push(&q, start)
    for queue.len(q) > 0 {
        c := queue.pop_front(&q)
        if c.y < 0 || c.x < 0 || int(c.y) >= len(input) || int(c.x) >= len(input[0]) || been[c.y][c.x][c.direction] do continue
        been[c.y][c.x][c.direction] = true
        switch input[c.y][c.x] {
        case '.': queue.push(&q, move(c, c.direction))
        case '\\': 
            if c.direction % 2 == 0 do queue.push(&q, move(c, (c.direction+1)%4))
            else                    do queue.push(&q, move(c, (c.direction-1)%4))
        case '/': 
            if c.direction % 2 == 1 do queue.push(&q, move(c, (c.direction+1)%4))
            else                    do queue.push(&q, move(c, (c.direction-1)%4))
        case '-':
            if c.direction % 2 == 0 {
                queue.push(&q, move(c, c.direction))
                continue
            }
            queue.push(&q, move(c, (c.direction+1)%4))
            queue.push(&q, move(c, (c.direction-1)%4))
        case '|':
            if c.direction % 2 == 1 {
                queue.push(&q, move(c, c.direction))
                continue
            }
            queue.push(&q, move(c, (c.direction+1)%4))
            queue.push(&q, move(c, (c.direction-1)%4))
        }
    }
    for line, y in been {
        for b, x in line {
            if slice.any_of(b, true) do res += 1
        }
    }
    return
}

solve :: proc(input: Input) -> (part1, part2: int) {
    part1 = solve_one(input, {0, 0, 0})
    part2 = part1
    for i in 0..<len(input) {
        part2 = max(part2, solve_one(input, {0, u8(i), 0}))
        part2 = max(part2, solve_one(input, {u8(len(input[0])-1), u8(i), 2}))
    }
    for i in 0..<len(input[0]) {
        part2 = max(part2, solve_one(input, {u8(i), 0, 1}))
        part2 = max(part2, solve_one(input, {u8(i), u8(len(input)-1), 3}))
    }
    return
}

parse :: proc(lines: []string) -> (result: Input) {
    return lines
}

main :: proc() {
    AOC.bench(proc() -> (p1, p2: int) {
        p1, p2 = solve(parse(AOC.get_lines()))
        return
    })
}
