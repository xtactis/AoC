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

PosWithoutDir :: struct {
    x, y: i8
}

Pos :: struct {
    x, y: i8,
    direction: i8
}

Input :: []string
pos_set :: map[PosWithoutDir]struct{}
posdir_set :: map[Pos]struct{} 

move :: proc(p: Pos, dir: i8) -> Pos {
    switch dir {
    case 0: return Pos{p.x+1, p.y, dir}
    case 1: return Pos{p.x, p.y+1, dir}
    case 2: return Pos{p.x-1, p.y, dir}
    case 3: return Pos{p.x, p.y-1, dir}
    }
    fmt.panicf("AAAAAAA", p, dir)
}

merge :: proc (m1: ^pos_set, m2: pos_set) {
    for k, _ in m2 {
        m1^[k] = {}
    }
    return
}

dp := make(map[Pos]pos_set)
seen := make(posdir_set)
dfs :: proc(input: Input, c: Pos) -> (result: pos_set) {
    if c.y < 0 || c.x < 0 || int(c.y) >= len(input) || int(c.x) >= len(input[0]) || c in seen do return
    if s, exists := dp[c]; exists {
        return s
    }

    seen[c] = {}
    result[{c.x, c.y}] = {}

    switch input[c.y][c.x] {
    case '.':
        merge(&result, dfs(input, move(c, c.direction)))
    case '\\': 
        if c.direction % 2 == 0 do merge(&result, dfs(input, move(c, (c.direction+1)&3)))
        else                    do merge(&result, dfs(input, move(c, (c.direction-1)&3)))
    case '/': 
        if c.direction % 2 == 1 do merge(&result, dfs(input, move(c, (c.direction+1)&3)))
        else                    do merge(&result, dfs(input, move(c, (c.direction-1)&3)))
    case '-':
        if c.direction % 2 == 0 {
            merge(&result, dfs(input, move(c, c.direction)))
        } else {
            merge(&result, dfs(input, move(c, (c.direction+1)&3)))
            merge(&result, dfs(input, move(c, (c.direction-1)&3)))
        }
    case '|':
        if c.direction % 2 == 1 {
            merge(&result, dfs(input, move(c, c.direction)))
        } else {
            merge(&result, dfs(input, move(c, (c.direction+1)&3)))
            merge(&result, dfs(input, move(c, (c.direction-1)&3)))
        }
    }
    delete_key(&seen, c)
    dp[c] = result
    return
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
            if c.direction % 2 == 0 do queue.push(&q, move(c, (c.direction+1)&3))
            else                    do queue.push(&q, move(c, (c.direction-1)&3))
        case '/': 
            if c.direction % 2 == 1 do queue.push(&q, move(c, (c.direction+1)&3))
            else                    do queue.push(&q, move(c, (c.direction-1)&3))
        case '-':
            if c.direction % 2 == 0 {
                queue.push(&q, move(c, c.direction))
                continue
            }
            queue.push(&q, move(c, (c.direction+1)&3))
            queue.push(&q, move(c, (c.direction-1)&3))
        case '|':
            if c.direction % 2 == 1 {
                queue.push(&q, move(c, c.direction))
                continue
            }
            queue.push(&q, move(c, (c.direction+1)&3))
            queue.push(&q, move(c, (c.direction-1)&3))
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
    part1 = len(dfs(input, {0, 0, 0}))
    part2 = part1
    for i in 0..<len(input) {
        part2 = max(part2, len(dfs(input, {0, i8(i), 0})))
        part2 = max(part2, len(dfs(input, {i8(len(input[0])-1), i8(i), 2})))
    }
    for i in 0..<len(input[0]) {
        part2 = max(part2, len(dfs(input, {i8(i), 0, 1})))
        part2 = max(part2, len(dfs(input, {i8(i), i8(len(input)-1), 3})))
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
