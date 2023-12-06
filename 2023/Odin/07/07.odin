package Day07

import "core:fmt"
import "core:math"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:time"
import "core:unicode"

import AOC ".."

Input :: struct {
    hand: string,
    bid: int
}

order  :: "AKQJT98765432"
order2 :: "AKQT98765432J"

hist_eval :: proc(hist: map[rune]int) -> int {
    if len(hist) == 1 do return 6 // five of a kind
    if len(hist) == 2 {
        for k, v in hist {
            if v == 4 do return 5 // four of a kind
            if v == 3 do return 4 // full house
        }
        fmt.panicf("len(hist) is 2 but no valid hands found in ", hist)
    }
    if len(hist) == 3 {
        for k, v in hist {
            if v == 3 do return 3 // three of a kind
            if v == 2 do return 2 // two pair
        }
    }
    if len(hist) == 5 do return 0 // high card
    return 1 // one pair
}

hand :: proc(h: string) -> int {
    hist : map[rune]int
    for r in h {
        hist[r] += 1
    }
    return hist_eval(hist)
}

hand2 :: proc(h: string) -> (result: int) {
    hist : map[rune]int
    for r in h {
        hist[r] += 1
    }
    mk := 'x'
    for k, v in hist {
        if k == 'J' do continue
        if mk == 'x' do mk = k
        else if v > hist[mk] do mk = k
    }
    if mk == 'x' do return 6 // all jokers so five of a kind
    hist[mk] += hist['J']
    delete_key(&hist, 'J')
    return hist_eval(hist)
}

cmp :: proc(ha: string, hb: string, order:=order) -> bool {
    for a, i in ha {
        ia := strings.index_rune(order, a)
        ib := strings.index_rune(order, rune(hb[i]))
        if ia > ib do return true
        if ib > ia do return false
    }
    return false
}

solve :: proc(input: []Input) -> (part1, part2: int) {
    slice.sort_by(input, proc(a, b: Input) -> bool {
        ah, bh := hand(a.hand), hand(b.hand)
        if ah == bh {
            return cmp(a.hand, b.hand)
        }
        return ah < bh
    })
    for h, i in input {
        part1 += h.bid * (i+1)
    }
    slice.sort_by(input, proc(a, b: Input) -> bool {
        ah, bh := hand2(a.hand), hand2(b.hand)
        if ah == bh {
            return cmp(a.hand, b.hand, order2)
        }
        return ah < bh
    })
    for h, i in input {
        part2 += h.bid * (i+1)
    }
    return
}

parse :: proc(lines: []string) -> (result: []Input) {
    result = make([]Input, len(lines))
    for line, i in lines {
        sline := strings.split(line, " ")
        result[i] = Input {hand = sline[0], bid = AOC.parse_int(sline[1])}
    }
    return
}

main :: proc() {
    start := time.now()
    p1, p2 := solve(parse(AOC.get_lines()))
    fmt.println(time.since(start))
    fmt.printf("%d\n%d", p1, p2)
}
