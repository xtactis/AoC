package Day14

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

Pos :: [2]i8

InputFast :: struct {
    hash_y4x: [][dynamic]i8,
    hash_x4y: [][dynamic]i8,
    
    os: [dynamic]Pos
}

solve_fast :: proc(input: InputFast) -> (part1, part2: int) {
    input := input
    using input
    hist : map[Pos]i8
    N :: 100_000
    for cycle in 0..<N {
        // north
        for &o in os {
            idx, _ := slice.binary_search(hash_x4y[o.x][:], o.y)
            o.y = hash_x4y[o.x][idx-1]
            hist[o] += 1
        }
        i := 0
        for k, v in hist {
            for v := v; v > 0; v -= 1 {
                os[i].x = k.x
                os[i].y = k.y+v
                i += 1
            }
        }
        clear(&hist)
        // west
        for &o in os {
            idx, _ := slice.binary_search(hash_y4x[o.y][:], o.x)
            o.x = hash_y4x[o.y][idx-1]
            hist[o] += 1
        }
        i = 0
        for k, v in hist {
            for v := v; v > 0; v -= 1 {
                os[i].x = k.x+v
                os[i].y = k.y
                i += 1
            }
        }
        clear(&hist)
        // south
        for &o in os {
            idx, _ := slice.binary_search(hash_x4y[o.x][:], o.y)
            o.y = hash_x4y[o.x][idx]
            hist[o] += 1
        }
        i = 0
        for k, v in hist {
            for v := v; v > 0; v -= 1 {
                os[i].x = k.x
                os[i].y = k.y-v
                i += 1
            }
        }
        clear(&hist)
        // east
        for &o in os {
            idx, _ := slice.binary_search(hash_y4x[o.y][:], o.x)
            o.x = hash_y4x[o.y][idx]
            hist[o] += 1
        }
        i = 0
        for k, v in hist {
            for v := v; v > 0; v -= 1 {
                os[i].x = k.x-v
                os[i].y = k.y
                i += 1
            }
        }
        clear(&hist)
    }
    for o in os {
        part2 += len(hash_y4x)-int(o.y)
    }
    return
}

parse_fast :: proc(lines: []string) -> (res: InputFast) {
    res.hash_x4y = make([][dynamic]i8, len(lines[0]))
    res.hash_y4x = make([][dynamic]i8, len(lines))
    for x in 0..<len(lines[0]) do append(&res.hash_x4y[x], -1)
    for line, y in lines {
        append(&res.hash_y4x[y], -1)
        for c, x in line {
            switch c {
            case '.': continue
            case '#':
                append(&res.hash_x4y[x], i8(y))
                append(&res.hash_y4x[y], i8(x))
            case 'O':
                append(&res.os, Pos{i8(x), i8(y)})
            }
        }
        append(&res.hash_y4x[y], i8(len(lines[0])))
    }
    for x in 0..<len(lines[0]) do append(&res.hash_x4y[x], i8(len(lines)))

    return
}

Input :: [][]u8

solve :: proc(input: Input) -> (part1, part2: int) {
    Key :: [2]int
//    cache := make(map[Key]int)
//    rev_cache := make([dynamic]int, 0, 128)
    N :: 100_000
    for cycle in 0..<N {
        key : Key
        load := 0
        for direction in 0..<4 {
            if direction < 2 {
                for line, i in input {
                    for c, j in line {
                        if c != 'O' do continue
                        k : int
                        switch direction {
                        case 0:
                            k = i-1
                            for k >= 0 && input[k][j] == '.' do k -= 1
                            k += 1
                            input[k][j], input[i][j] = input[i][j], input[k][j]
                            key[0] += len(input)-k
                            key[1] += j
                        case 1:
                            k = j-1
                            for k >= 0 && input[i][k] == '.' do k -= 1
                            k += 1
                            input[i][k], input[i][j] = input[i][j], input[i][k]
                        }
                    }
                }
            } else {
                #reverse for line, i in input {
                    #reverse for c, j in line {
                        if c != 'O' do continue
                        k : int
                        switch direction {
                        case 2:
                            k = i+1
                            for k < len(input) && input[k][j] == '.' do k += 1
                            k -= 1
                            input[k][j], input[i][j] = input[i][j], input[k][j]
                        case 3:
                            k = j+1
                            for k < len(input[0]) && input[i][k] == '.' do k += 1
                            k -= 1
                            input[i][k], input[i][j] = input[i][j], input[i][k]
                            load += len(input)-i
                        }
                    }
                }
            }
        }
        /*if cycle == 0 do part1 = key[0]
        if c, exists := cache[key]; exists {
            part2 = rev_cache[c-1 + ((N - cycle) % (cycle-c))]
            return
        }
        cache[key] = cycle
        append(&rev_cache, load)*/
        part2 = load
    }
    return
}

parse :: proc(lines: []string) -> (result: Input) {
    result = make(Input, len(lines))
    for line, i in lines {
        result[i] = transmute([]u8)(line)
    }
    return
}

main :: proc() {
    AOC.bench(proc() -> (p1, p2: int) {
        p1, p2 = solve_fast(parse_fast(AOC.get_lines()))
        return
    })
}
