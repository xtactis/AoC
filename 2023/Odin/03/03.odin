package Day03

import "core:fmt"
import "core:math"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:time"
import "core:unicode"

import AOC ".."

Value :: struct {
    v: int,
    offset: int,
    seen: bool
}

solve :: proc(lines: []string, values: [][]Value) -> (int, int) {
    part1, part2 : int = 0, 0

    dx := [?]int{-1, 0, 1, -1, 1, -1, 0, 1}
    dy := [?]int{-1, -1, -1, 0, 0, 1, 1, 1}

    for line, i in lines {
        for c, j in line {
            if c != '.' && !unicode.is_digit(c) {
                vs : [2]int
                vi := 0
                for k in 0..<len(dx) {
                    ni := i + dy[k]
                    nj := j + dx[k]
                    if nj < 0 || nj >= len(line) || ni < 0 || ni >= len(lines) do continue
                    if values[ni][nj].v == 0 || values[ni][nj-values[ni][nj].offset].seen do continue

                    part1 += int(values[ni][nj].v)
                    if c == '*' && vi != 2 {
                        vs[vi] = int(values[ni][nj].v)
                        vi += 1
                    }
                    values[ni][nj-values[ni][nj].offset].seen = true
                }
                if vi == 2 do part2 += vs[0] * vs[1]
            }
        }
    }

    return part1, part2
}

parse :: proc(lines: []string) -> [][]Value {
    set_new :: proc(i, j, cur: int, values: ^[][]Value) {
        tmp := cur
        k, digits := j-1, 0
        for ; tmp > 0; k-=1 {
            values[i][k].v = cur
            tmp /= 10
            digits += 1
        }
        for l in 0..<digits {
            values[i][k+l+1].offset = l
        }
    }

    values := make([][]Value, len(lines))
    for line, i in lines {
        cur := 0
        values[i] = make([]Value, len(line))
        for c, j in line {
            if c != '.' && unicode.is_digit(c) {
                cur *= 10
                cur += int(c - '0')
            } else {
                set_new(i, j, cur, &values)
                cur = 0
            }
        }
        set_new(i, len(line), cur, &values)
    }

    return values
}

main :: proc() {
    AOC.bench(proc() -> (p1, p2: int) {
        input := AOC.get_lines()
        values := parse(input) 
        p1, p2 = solve(input, values)
        return
    })
}
