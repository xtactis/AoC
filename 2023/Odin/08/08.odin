package Day08

import "core:fmt"
import "core:math"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:time"
import "core:unicode"

import AOC ".."

Node :: []string

Input :: struct {
    g: map[string]Node,
    instructions: string
}

p1 :: proc(cur: string, input: Input, anyz:bool=false) -> int {
    cur := cur
    for ind := 0; ; ind += 1 {
        if cur == "ZZZ" do return ind
        if anyz && cur[2] == 'Z' do return ind
        if input.instructions[ind % len(input.instructions)] == 'L' {
            cur = input.g[cur][0]
        } else {
            cur = input.g[cur][1]
        }
    }
}

solve :: proc(input: Input) -> (part1, part2: int) {
    part1 = p1("AAA", input)
    
    part2 = -1
    for k, v in input.g {
        if k[2] == 'A' {
            part2 = part2 == -1 ? p1(k, input, true) : math.lcm(part2, p1(k, input, true))
        }
    }
    
    return
}

parse :: proc(lines: []string) -> (result: Input) {
    result.instructions = lines[0]
    for line in lines[2:] {
        sline := strings.split(line, " = ")
        key, rest := sline[0], sline[1]
        snodes := strings.split(rest[1:len(rest)-1], ", ")
        result.g[key] = snodes
    }
    return
}

main :: proc() {
    start := time.now()
    p1, p2 := solve(parse(AOC.get_lines()))
    fmt.println(time.since(start))
    fmt.printf("%d\n%d\n", p1, p2)
}
