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

Node :: struct {
    type: u8,
    state: bool,
    ins: map[string]bool
}
Input :: struct {
    nodes: []Node,
    s2n: map[string]int, // node index
    adj: map[string][]string,
}

solve :: proc(input: Input) -> (part1, part2: int) {
    using input
    Signal :: struct {
        source: string,
        destination: string,
        pulse: bool
    }
    q: queue.Queue(Signal)
    queue.init(&q)

    lows : int
    highs : int

    cache : map[[64]bool]int

    for i := 0; part1 == 0 || part2 == 0; i += 1 {
        queue.push_back(&q, Signal{source = "button", destination = "broadcaster", pulse = false})
        if i % 1000000 == 0 do fmt.println(i)
        for queue.len(q) > 0 {
            cur := queue.pop_front(&q)
            using cur
            if pulse do highs += 1 
            else do lows += 1
            if !pulse && destination == "rx" {
                part2 = i
                return
            }
            if destination not_in s2n do continue
            cnode := &nodes[s2n[destination]]
            switch cnode.type {
            case 0:
                for name in adj[destination] {
                    queue.push_back(&q, Signal{source = destination, destination = name, pulse = pulse})
                }
            case '%':
                if pulse do continue
                cnode.state = !cnode.state
                for name in adj[destination] {
                    queue.push_back(&q, Signal{source = destination, destination = name, pulse = cnode.state})
                }
            case '&':
                cnode.ins[source] = pulse
                all_high := true
                for _, state in cnode.ins {
                    all_high &= state
                }
                for name in adj[destination] {
                    queue.push_back(&q, Signal{source = destination, destination = name, pulse = !all_high})
                }
            }
        }
        if i == 1000-1 {
            part1 = lows * highs
        }
    }
    return part1, part2
}

parse :: proc(lines: []string) -> (result: Input) {
    result.nodes = make([]Node, len(lines))
    for line, i in lines {
        t := strings.split(line, " -> ")
        name : string
        type : u8
        if t[0][0] == '%' || t[0][0] == '&' {
            name = t[0][1:]
            type = t[0][0]
        } else {
            name = t[0]
            type = 0
        }
        result.nodes[i] = Node {type = type, state = false, ins = make(map[string]bool)}
        result.s2n[name] = i
        result.adj[name] = slice.clone(strings.split(t[1], ", "))
    }
    for name, _ in result.s2n {
        for n in result.adj[name] {
            if result.nodes[result.s2n[n]].type != '&' do continue
            result.nodes[result.s2n[n]].ins[name] = false
        }
    }
    return result
}

main :: proc() {
    AOC.bench(proc() -> (p1, p2: int) {
        return solve(parse(AOC.get_lines()))
    })
}
