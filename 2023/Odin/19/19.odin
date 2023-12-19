package Day19

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

Workflow :: struct {
    category: u8,
    operator: u8,
    value: int,
    iftrue: string,
}

Part :: [4]int

Input :: struct {
    workflows: map[string][]Workflow,
    parts: []Part,
}

solve_p2 :: proc(ranges: [4][2]int, current: string, workflows: map[string][]Workflow) -> (res: int) {
    if current == "R" do return 0
    for range in ranges {
        if range[0] > range[1] do return 0
    }
    if current == "A" {
        res = 1
        for range in ranges {
            res *= range[1]-range[0]+1
        }
        return res
    }
    wf := workflows[current]
    ranges := ranges
    for rule in wf {
        switch rule.operator {
        case '>':
            new_ranges := ranges
            new_ranges[rule.category][0] = rule.value+1
            ranges[rule.category][1] = rule.value
            res += solve_p2(new_ranges, rule.iftrue, workflows)
        case '<':
            new_ranges := ranges
            new_ranges[rule.category][1] = rule.value-1
            ranges[rule.category][0] = rule.value
            res += solve_p2(new_ranges, rule.iftrue, workflows)
        case '!':
            res += solve_p2(ranges, rule.iftrue, workflows)
            break
        }
    }
    return res
}

solve :: proc(input: Input) -> (part1, part2: int) {
    using input
    for part in parts {
        current := "in"
        next_wf: for current != "A" && current != "R" {
            wf := workflows[current]
            for rule in wf {
                switch rule.operator {
                case '>':
                    if part[rule.category] > rule.value {
                        current = rule.iftrue
                        continue next_wf
                    }
                case '<':
                    if part[rule.category] < rule.value {
                        current = rule.iftrue
                        continue next_wf
                    }
                case '!':
                    current = rule.iftrue
                    continue next_wf
                }
            }
        }
        if current == "A" do part1 += part[0]+part[1]+part[2]+part[3]
    }

    part2 = solve_p2([4][2]int{{1, 4000}, {1, 4000}, {1, 4000}, {1, 4000}}, "in", workflows)
    return part1, part2
}

parse :: proc(lines: []string) -> (result: Input) {
    category_mapping:= map[u8]u8 {
        'x' = 0, 'm' = 1, 'a' = 2, 's' = 3
    }
    ind := 0
    for line in lines {
        if len(line) == 0 do break
        t := strings.split(line, "{")
        name := t[0]
        srules := strings.split(t[1][:len(t[1])-1], ",")
        workflows := make([]Workflow, len(srules))
        for srule, i in srules {
            t := strings.split(srule, ":")
            if len(t) == 1 {
                workflows[i] = Workflow{
                    category = 0,
                    operator = '!',
                    value = 0,
                    iftrue = t[0]
                }
            } else {
                workflows[i] = Workflow{
                    category = category_mapping[srule[0]],
                    operator = srule[1],
                    value = AOC.parse_int(t[0][2:]),
                    iftrue = t[1]
                }
            }
        }
        result.workflows[name] = workflows
        ind += 1
    }
    result.parts = make([]Part, len(lines)-ind-1)
    for ind += 1; ind < len(lines); ind += 1 {
        svalues := strings.split(lines[ind][1:len(lines[ind])-1], ",")
        for svalue in svalues { 
            t := strings.split(svalue, "=")
            result.parts[len(lines)-ind-1][category_mapping[t[0][0]]] = AOC.parse_int(t[1])
        }
    }
    return result
}

main :: proc() {
    AOC.bench(proc() -> (p1, p2: int) {
        return solve(parse(AOC.get_lines()))
    })
}
