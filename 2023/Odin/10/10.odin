package Day10

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
    x, y, dist: int
}

Input :: struct {
    grid: []string,
    s : Pos
}

solve :: proc(input: Input) -> (part1, part2: int) {
    using input
    S_IS := 'S'
    q : queue.Queue(Pos)
    queue.init(&q)
    seen := make([][]int, len(grid))
    for s,i in seen {
        seen[i] = make([]int, len(grid[0]))
    }
    queue.push(&q, input.s)
    for queue.len(q) > 0{
        c := queue.pop_front(&q)
        if c.x < 0 || c.y < 0 || c.x >= len(grid[0]) || c.y >= len(grid) || seen[c.y][c.x] == 42 do continue
        seen[c.y][c.x] = 42
        // fmt.println(rune(grid[c.y][c.x]), c)
        part1 = max(part1, c.dist)
        switch grid[c.y][c.x] {
        case 'S':
            v, h := 0, 0
            vb := false
            if c.y+1 < len(grid) do switch grid[c.y+1][c.x] {
            case '|': fallthrough
            case 'J': fallthrough
            case 'L':
                queue.push(&q, Pos{x = c.x, y = c.y+1, dist = c.dist+1})
                v += 1
                vb = true
            }
            if c.y-1 >= 0 do switch grid[c.y-1][c.x] {
            case '|': fallthrough
            case '7': fallthrough
            case 'F':
                queue.push(&q, Pos{x = c.x, y = c.y-1, dist = c.dist+1})
                v -= 1
                vb = true
            }
            if c.x+1 < len(grid[0]) do switch grid[c.y][c.x+1] {
            case '-': fallthrough
            case 'J': fallthrough
            case '7':
                queue.push(&q, Pos{x = c.x+1, y = c.y, dist = c.dist+1})
                h += 1
            }
            if c.x-1 >= 0 do switch grid[c.y][c.x-1] {
            case '-': fallthrough
            case 'F': fallthrough
            case 'L':
                queue.push(&q, Pos{x = c.x-1, y = c.y, dist = c.dist+1})
                h -= 1
            }
            // this bit is wrong, but it works for me :)
            special_sauce := []string{"J|L", "-.-", "7|F"}
            S_IS = rune(special_sauce[v+1][h+1])
            if S_IS == '.' {
                S_IS = vb ? '|' : '-' 
            }
        case '|':
            queue.push(&q, Pos{x = c.x, y = c.y-1, dist = c.dist+1})
            queue.push(&q, Pos{x = c.x, y = c.y+1, dist = c.dist+1})
        case '-':
            queue.push(&q, Pos{x = c.x-1, y = c.y, dist = c.dist+1})
            queue.push(&q, Pos{x = c.x+1, y = c.y, dist = c.dist+1})
        case 'F':
            queue.push(&q, Pos{x = c.x, y = c.y+1, dist = c.dist+1})
            queue.push(&q, Pos{x = c.x+1, y = c.y, dist = c.dist+1})
        case 'J':
            queue.push(&q, Pos{x = c.x, y = c.y-1, dist = c.dist+1})
            queue.push(&q, Pos{x = c.x-1, y = c.y, dist = c.dist+1})
        case 'L':
            queue.push(&q, Pos{x = c.x, y = c.y-1, dist = c.dist+1})
            queue.push(&q, Pos{x = c.x+1, y = c.y, dist = c.dist+1})
        case '7':
            queue.push(&q, Pos{x = c.x, y = c.y+1, dist = c.dist+1})
            queue.push(&q, Pos{x = c.x-1, y = c.y, dist = c.dist+1})
        }
    }
    for i in 0..<len(grid) {
        saw := '.'
        hits := 0
        for j in 0..<len(grid[0]) {
            cur := rune(grid[i][j]) == 'S' ? S_IS : rune(grid[i][j])
            if seen[i][j] == 42 && cur == '|' do hits += 1
            if seen[i][j] == 42 && strings.contains_rune("FJ7L", cur) {
                if saw != '.' {
                    if saw == 'L' && cur == '7' do hits += 1
                    else if saw == 'F' && cur == 'J' do hits += 1
                    saw = '.'
                } else {
                    saw = cur
                }
            }
            if seen[i][j] == 0 && int(hits) % 2 == 1 {
                part2 += 1
                seen[i][j] = 42
            }
        }
    }
    
    return
}

parse :: proc(lines: []string) -> (result: Input) {
    result.grid = lines
    for line, i in lines {
        for c, j in line {
            if c == 'S' {
                result.s = Pos {x = j, y = i}
                return
            }
        }
    }
    return
}

main :: proc() {
    AOC.bench(proc() -> (p1, p2: int) {
        p1, p2 = solve(parse(AOC.get_lines()))
        return
    })
}
