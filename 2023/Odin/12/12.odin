package Day12

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

Input :: struct {
    record: string,
    hint: []int
}

State :: struct {
    rec_index, hint_index, cur: u8
}
@(thread_local)
dp : map[State]int

count :: proc(input: Input, rec_index, hint_index, cur: int) -> int {
    using input
    if rec_index == len(record) do return 1 if (hint_index == len(hint) && cur == 0) || (hint_index == len(hint)-1 && cur == hint[hint_index]) else 0
    if hint_index == len(hint) do return 0 if cur != 0 || strings.contains_rune(record[rec_index:], '#') else 1
    if cur > hint[hint_index] do return 0
    state := State{u8(rec_index), u8(hint_index), u8(cur)}
    if saved, exists := dp[state]; exists do return saved
    res := 0
    switch record[rec_index] {
    case '.':
        if cur != 0 {
            if hint[hint_index] == cur {
                res = count(input, rec_index+1, hint_index+1, 0)
            }
        } else {
            res = count(input, rec_index+1, hint_index, 0)
        }
    case '#':
        res = count(input, rec_index+1, hint_index, cur+1)
    case '?':
        if cur != 0 {
            // become '.'
            if hint[hint_index] == cur {
                res = count(input, rec_index+1, hint_index+1, 0)
            }
            // or '#'
            res += count(input, rec_index+1, hint_index, cur+1)
        } else {
            res = count(input, rec_index+1, hint_index, 1) + count(input, rec_index+1, hint_index, 0)
        }
    }
    dp[state] = res
    return res
}

solve :: proc(input: []Input) -> (part1, part2: int) {
    dp = make(map[State]int)
    h := make([dynamic]int, 0, 75)
    s := make([dynamic]u8, 0, 75)
    for line in input {
        clear(&dp)
        part1 += count(line, 0, 0, 0)
        clear(&s)
        clear(&h)
        for j in 0..<5 {
            for i in 0..<len(line.record) {
                append(&s, line.record[i])
            }
            if j != 4 do append(&s, '?')
            for i in 0..<len(line.hint) {
                append(&h, line.hint[i])
            }
        }
        clear(&dp)
        part2 += count(Input {record = string(s[:]), hint = h[:]}, 0, 0, 0)
    }
    return
}

solve_para :: proc(input: []Input) -> (part1, part2: int) {
    ts := make([]^thread.Thread, 8)
    p1s := make([]int, len(ts))
    p2s := make([]int, len(ts))
    chunk_len := len(input) / len(ts)

    runner :: proc(input: []Input, part1, part2: ^int) {
        part1^, part2^ = solve(input)
    }

    for &t, i in ts {
        t = thread.create_and_start_with_poly_data3(input[i * chunk_len : (i+1) * chunk_len], &p1s[i], &p2s[i], runner)
    }

    thread.join_multiple(..ts)

    part1 = math.sum(p1s)
    part2 = math.sum(p2s)

    return
}

parse :: proc(lines: []string) -> (result: []Input) {
    result = make([]Input, len(lines))
    ml := 0
    for line, i in lines {
        tmp := strings.split(line, " ")
        result[i].record = tmp[0]
        ml = max(ml, len(tmp[0]))
        result[i].hint = AOC.parse_ints(strings.split(tmp[1], ","))
    }
    return
}

main :: proc() {
    AOC.bench(proc() -> (p1, p2: int) {
        p1, p2 = solve_para(parse(AOC.get_lines()))
        return
    })
}
