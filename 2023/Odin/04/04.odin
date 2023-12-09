package Day04

import "core:fmt"
import "core:math"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:time"
import "core:unicode"

import AOC ".."

Card :: struct {
    winning: []int,
    mine: []int,
}

solve :: proc(cards: []Card) -> (part1, part2: int) {
    p2cards := make([]int, len(cards))
    for card, id in cards {
        using card
        part2 += 1 + p2cards[id]
        cnt := 0
        for n in mine {
            if slice.contains(winning, n) {
                cnt += 1
                p2cards[id+cnt] += 1 + p2cards[id]
            }
        }
        part1 += (1 << uint(cnt)) / 2
    }
    return part1, part2
}

parse :: proc(lines: []string) -> []Card {
    result := make([]Card, len(lines))
    for line, i in lines {
        cards := strings.split(line, ": ")[1]
        scards := strings.split(cards, " | ")
        swinning := strings.split_multi(strings.trim_space(scards[0]), {"  ", " "})
        result[i].winning = make([]int, len(swinning))
        for swin, j in swinning {
            result[i].winning[j] = strconv.parse_int(swin) or_else fmt.panicf("aaaa %s\n'%s' %d", swinning, swin, j)
        }
        smine := strings.split_multi(strings.trim_space(scards[1]), {"  ", " "})
        result[i].mine = make([]int, len(smine))
        for smin, j in smine {
            result[i].mine[j] = strconv.parse_int(smin) or_else fmt.panicf("aaaa %s\n'%s' %d", smine, smin, j)
        }
    }
    return result
}

main :: proc() {
    start := time.now()
    input := AOC.get_lines()
    cards := parse(input) 
    p1, p2 := solve(cards)
    fmt.println(time.since(start))
    fmt.printf("%d\n%d\n", p1, p2)
}
