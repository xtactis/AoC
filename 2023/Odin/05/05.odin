package Day05

import "core:fmt"
import "core:math"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:unicode"

import AOC ".."

Input :: struct {
    seeds : []int,
    conv: [7][][]int,
}

solve :: proc(input: Input) -> (int, int) {
    part1, part2 := 0, 0

    seeds := slice.clone(input.seeds)
    for conv in input.conv {
        done := make([]bool, len(seeds))
        for l in conv {
            d, s, r := l[0], l[1], l[2]
            for seed, i in seeds {
                if done[i] do continue
                if seed >= s && seed < s + r {
                   seeds[i] = seed-s+d 
                   done[i] = true
                }
            }
        }
    }
    part1 = seeds[0]
    for s in seeds {
        part1 = min(s, part1)
    }

    Seed :: struct {
        s: int,
        r: int,
    }
    sr := make([]Seed, len(input.seeds)/2)
    for i := 0; i < len(input.seeds)/2; i += 1 {
        sr[i] = Seed{s = input.seeds[2*i], r = input.seeds[2*i+1]}
    }
    merged : [dynamic]Seed
    for conv in input.conv {
        fmt.println(conv)
        results : [dynamic]Seed
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
                    append(&results, Seed{s = seed.s+j, r = 1})
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
                    append(&results, Seed{s = seed.s+j, r = 1})
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
    part2 = sr[0].s
    for r in sr {
        part2 = min(r.s, part2)
    }

    return part1, part2
}

parse :: proc(input: string) -> Input {
    sections := strings.split(input, "\n\n")

    result: Input

    sseeds := strings.split(sections[0], " ")[1:]
    result.seeds = AOC.parse_ints(sseeds)

    for i in 0..<len(result.conv) {
        lines := strings.split(sections[i+1], "\n")[1:]
        result.conv[i] = make([][]int, len(lines))
        for s, j in lines {
            result.conv[i][j] = AOC.parse_ints(strings.split(s, " "))
        }
        slice.sort_by(result.conv[i], proc(x, y: []int) -> bool {
            return x[1] < y[1]
        })
    }

    return result
}

main :: proc() {
    input := AOC.get_input()
    parsed := parse(input) 
    fmt.printf("%d\n%d", solve(parsed))
}
