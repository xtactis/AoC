package Day02

import "core:fmt"
import "core:math"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:text/match"
import "core:time"

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

parse :: proc(lines: []string) -> []Game {
    games := make([]Game, len(lines))
    for line, i in lines {
        sdata := strings.split_multi(line, {": ", ", ", "; "})
        colors :: [3]string{"red", "green", "blue"}
        for color in colors {
            matcher := match.matcher_init(line, strings.concatenate({"(%d+) ", color}))
            for snum, index in match.matcher_match_iter(&matcher) {
                games[i][color] = max(
                    strconv.parse_int(snum) or_else fmt.panicf("input is ill-formed!!!"),
                    games[i][color]
                )
            }
        }
    }

    return games
}

main :: proc() {
    AOC.bench(proc() -> (p1, p2: int) {
        games := parse(AOC.get_lines()) 
        p1, p2 = part1(games), part2(games)
        return
    })
}
