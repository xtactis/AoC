package Day05

import "core:fmt"
import "core:math"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:time"
import "core:unicode"

import AOC ".."

Input :: struct {
    seeds : []int,
    conv: [7][][3]int,
}

Seed :: struct {
    s: int,
    r: int,
}

find_min :: proc(sr: []Seed, _conv: [7][][3]int) -> (result: int) {
    sr := slice.clone(sr)
    merged := make([dynamic]Seed, 0, len(sr)*4)
    results := make([dynamic]Seed, 0, len(sr)*4)
    defer delete(merged)
    defer delete(results)
    for conv in _conv {
        clear(&results)
        for seed, i in sr {
            for j := 0; j < seed.r; j += 1 {
                L, R := -1, len(conv)
                for R-L > 1 {
                    m := (L+R)/2
                    if seed.s+j < conv[m][1] do R = m
                    else do L = m
                }
                l := L
                if l == -1 {
                    r := min(seed.r-j, conv[0][1]-(seed.s+j))
                    append(&results, Seed{s = seed.s+j, r = r})
                    j += r-1
                    continue
                }
                d, s, r := conv[l][0], conv[l][1], conv[l][2]
                if seed.s+j >= s && seed.s+j < s + r {
                    ns := Seed {
                        s = seed.s+j - s + d,
                        r = min(s+r-(seed.s+j), seed.r-j),
                    }
                    append(&results, ns)
                    j += ns.r-1
                } else {
                    if l == len(conv)-1 {
                        append(&results, Seed{s = seed.s+j, r = seed.r-j})
                        j = seed.r
                    } else {
                        r := min(seed.r-j, conv[l+1][1]-(seed.s+j))
                        append(&results, Seed{s = seed.s+j, r = r})
                        j += r-1
                    }
                }
            }
        }
        slice.sort_by(results[:], proc(x, y: Seed) -> bool {
            return x.s < y.s
        })
        clear(&merged)
        append(&merged, results[0])
        for seed in results[1:] {
            if merged[len(merged)-1].s+merged[len(merged)-1].r >= seed.s {
                merged[len(merged)-1].r = seed.s + seed.r - merged[len(merged)-1].s
            } else {
                append(&merged, seed)
            }
        }
        sr = merged[:]
    }
    result = sr[0].s
    for r in sr {
        result = min(r.s, result)
    }
    return
}

solve :: proc(input: Input) -> (part1, part2: int) {
    sr := make([dynamic]Seed, 0, len(input.seeds))
    defer delete(sr)

    for i := 0; i < len(input.seeds); i += 1 {
        append(&sr, Seed{s = input.seeds[i], r = 1})
    }
    part1 = find_min(sr[:], input.conv)

    clear(&sr)
    for i := 0; i < len(input.seeds)/2; i += 1 {
        append(&sr, Seed{s = input.seeds[2*i], r = input.seeds[2*i+1]})
    }
    part2 = find_min(sr[:], input.conv)

    return
}

parse :: proc(input: string) -> Input {
    sections := strings.split(input, "\n\n")

    result: Input

    sseeds := strings.split(sections[0], " ")[1:]
    result.seeds = AOC.parse_ints(sseeds)

    for i in 0..<len(result.conv) {
        lines := strings.split(sections[i+1], "\n")[1:]
        result.conv[i] = make([][3]int, len(lines))
        for s, j in lines {
            copy(result.conv[i][j][:], AOC.parse_ints(strings.split(s, " ")))
        }
        slice.sort_by(result.conv[i], proc(x, y: [3]int) -> bool {
            return x[1] < y[1]
        })
    }

    return result
}

main :: proc() {
    AOC.bench(proc() -> (p1, p2: int) {
        p1, p2 = solve(parse(AOC.get_input()))
        return
    })
}
