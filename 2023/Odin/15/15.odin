package Day15

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

Input :: []string

Value :: struct {
    label: string,
    lens: int,
    removed: bool
}

solve :: proc(input: Input) -> (part1, part2: int) {
    hmap : [256][dynamic]Value
    for step in input {
        cur :u8= 0
        for c, i in step {
            switch c {
            case '=':
                lens := AOC.parse_int(step[i+1:])
                found := false
                for &v in hmap[cur] {
                    if v.removed do continue
                    if step[:i] == v.label {
                        v.lens = lens
                        found = true
                    }
                }
                if !found do append(&hmap[cur], Value{label = step[:i], lens = lens, removed = false})
            case '-':
                for &v in hmap[cur] {
                    if step[:i] == v.label {
                        v.removed = true
                    }
                }
            }
            cur += u8(c)
            cur *= 17
        }
        part1 += int(cur)
    }
    for i in 0..<256 {
        j := 1
        for v in hmap[i] {
            if v.removed do continue
            part2 += (i+1)*j*v.lens
            j += 1
        }
    }
    return
}

parse :: proc(lines: string) -> (result: Input) {
    return strings.split(lines, ",")
}

main :: proc() {
    AOC.bench(proc() -> (p1, p2: int) {
        p1, p2 = solve(parse(AOC.get_input()))
        return
    })
}
