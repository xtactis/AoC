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

Input :: [][]u8

solve :: proc(input: Input) -> (part1, part2: int) {
    Key :: [2]int
    cache := make(map[Key]int)
    rev_cache := make([dynamic]int, 0, 128)
    N :: 1_000_000_000
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
        if cycle == 0 do part1 = key[0]
        if c, exists := cache[key]; exists {
            part2 = rev_cache[c-1 + ((N - cycle) % (cycle-c))]
            return
        }
        cache[key] = cycle
        append(&rev_cache, load)
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
        p1, p2 = solve(parse(AOC.get_lines()))
        return
    })
}
