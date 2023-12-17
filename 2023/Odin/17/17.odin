package Day17

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

Pos :: [2]i16
Input :: [][]u8

solve_one :: proc(input: Input, start: Pos, maxdir: u8, mindir: u8 = 1) -> (res: u16) {
    d := make(map[struct {p: Pos, dir: u8, dircnt: u8}]u16)
    d[{start, 5, 1}] = 0 // intentionally invalid direction

    PQPos :: struct {
        cost: u16,
        pos: Pos,
        dir: u8,
        dircnt: u8
    }
    q : priority_queue.Priority_Queue(PQPos)
    priority_queue.init(&q, proc(a, b: PQPos) -> bool {
        return a.cost < b.cost
    }, priority_queue.default_swap_proc(PQPos))

    priority_queue.push(&q, PQPos{cost = 0, pos = start, dir = 5, dircnt = 1})
    for priority_queue.len(q) > 0 {
        c := priority_queue.pop(&q)
        using c

        if d[{pos, dir, dircnt}] != cost do continue
        dx := [?]i16{-1, 0, 1,  0}
        dy := [?]i16{ 0, 1, 0, -1}
        for i in 0..<u8(4) {
            np := pos + Pos{dx[i], dy[i]}

            // we should stay within the bounds of the map
            if np.y < 0 || np.x < 0 || int(np.y) >= len(input) || int(np.x) >= len(input[0]) do continue
            
            // we're not allowed to go directly back 
            if (dir+2) % 4 == i do continue
            
            // we have to go in the same direction at least mindir times
            if dir < 5 && dir != i && dircnt < mindir do continue

            // we're not allowed to move along the same axis for more than 4 steps
            ndircnt := 1 if dir != i else dircnt+1
            if dir == i && ndircnt > maxdir do continue

            if ncost := cost + u16(input[np.y][np.x]); ({np, i, ndircnt}) not_in d || ncost < d[{np, i, ndircnt}] {
                d[{np, i, ndircnt}] = ncost
                priority_queue.push(&q, PQPos{
                    cost = ncost,
                    pos = np,
                    dir = i,
                    dircnt = ndircnt
                })
            }
        }
    }
    res = 65535
    end := Pos{i16(len(input[0])-1), i16(len(input)-1)}
    for k, v in d {
        if k.p != end do continue
        res = min(res, v)
    }
    return res
}

solve :: proc(input: Input) -> (part1, part2: int) {
    part1 = int(solve_one(input, {0, 0}, 3))
    part2 = int(solve_one(input, {0, 0}, 10, 4))
    return
}

parse :: proc(lines: []string) -> (result: Input) {
    result = make(Input, len(lines))
    for line, i in lines {
        result[i] = make([]u8, len(line))
        for c, j in line {
            result[i][j] = u8(c-'0')
        }
    }
    return result
}

main :: proc() {
    AOC.bench(proc() -> (p1, p2: int) {
        return solve(parse(AOC.get_lines()))
    })
}


// this is just how I solved part1, it's obviously bad, but I'm a stubborn asshole
solve_old :: proc(input: Input, start: Pos) -> (res: int) {
    d := make(map[struct {p: Pos, last3: [3]Pos}]int)
    d[{start, {start, start, start}}] = 0

    PQPos :: struct {
        cost: int,
        pos: Pos,
        last3: [3]Pos,
    }
    q : priority_queue.Priority_Queue(PQPos)
    priority_queue.init(&q, proc(a, b: PQPos) -> bool {
        return a.cost < b.cost
    }, priority_queue.default_swap_proc(PQPos))

    priority_queue.push(&q, PQPos{cost = 0, pos = start, last3 = {start, start, start}})
    for priority_queue.len(q) > 0 {
        c := priority_queue.pop(&q)
        using c

        if d[{pos, last3}] != cost do continue
        dx := [?]i16{-1, 0, 1,  0}
        dy := [?]i16{ 0, 1, 0, -1}
        for i in 0..<4 {
            np := pos + Pos{dx[i], dy[i]}
            // we should stay within the bounds of the map
            if np.y < 0 || np.x < 0 || int(np.y) >= len(input) || int(np.x) >= len(input[0]) do continue
            // we're not allowed to go directly back 
            if last3[2] == np do continue
            // we're not allowed to move along the same axis for more than 4 steps
            if abs(np.y-last3[0].y) > 3 || abs(np.x-last3[0].x) > 3 do continue
            nlast3 := [3]Pos{last3[1], last3[2], pos}
            if ncost := cost + int(input[np.y][np.x]); ({np, nlast3}) not_in d || ncost < d[{np, nlast3}] {
                d[{np, nlast3}] = ncost
                priority_queue.push(&q, PQPos{
                    cost = ncost,
                    pos = np,
                    last3 = nlast3,
                })
            }
        }
    }
    res = 65535
    end := Pos{i16(len(input[0])-1), i16(len(input)-1)}
    for k, v in d {
        if k.p != end do continue
        res = min(res, v)
    }
    return res
}
