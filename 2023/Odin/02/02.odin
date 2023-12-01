package Day02

import "core:fmt"
import "core:math"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:text/match"

import AOC ".."

Game :: map[string]int

part1 :: proc(games: []Game) -> int {
    result := 0

    for game, id in games {
        if game["red"] <= 12 && game["green"] <= 13 && game["blue"] <= 14 do result += id+1
    }
    return result
}

part2 :: proc(games: []Game) -> int {
    result := 0

    for game, _ in games {
        result += game["red"] * game["green"] * game["blue"]
    }
    return result
}

parse :: proc(lines: []string) -> (games: []Game, ok: bool) {
    games, ok = make([]Game, len(lines)), true
    for line, i in lines {
        sdata := strings.split_multi(line, {": ", ", ", "; "})
        colors :: [3]string{"red", "green", "blue"}
        for color in colors {
            matcher := match.matcher_init(line, strings.concatenate({"(%d+) ", color}))
            for snum, index in match.matcher_match_iter(&matcher) {
                games[i][color] = max(
                    strconv.parse_int(snum) or_return,
                    games[i][color]
                )
            }
        }
    }

    return
}

main :: proc() {
    input := AOC.get_lines()
    games := parse(input) or_else fmt.panicf("input is ill-formed!!!")
    fmt.printf("%d\n", part1(games))
    fmt.printf("%d\n", part2(games))
}
