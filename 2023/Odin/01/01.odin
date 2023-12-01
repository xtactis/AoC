package Day01

import "core:fmt"
import "core:math"
import "core:strings"
import "core:unicode"

import AOC ".."

main :: proc() {
    lines := AOC.get_lines()

    part1 := 0
    part2 := 0
    for line in lines {
        first : int = -1
        last : int
        for c, index in line {
            if unicode.is_digit(c) {
                if first == -1 {
                    first = index
                }
                last = index
            }
        }
        first_idx := first
        last_idx := last
        first = int(line[first] - '0')
        last = int(line[last] - '0')
        part1 += first*10 + last
        
        for string_digit, index in ([]string{"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}) {
            first_occ := strings.index(line, string_digit)
            if first_occ != -1 && first_occ < first_idx {
                first_idx = first_occ
                first = index+1
            }
            last_occ := strings.last_index(line, string_digit)
            if last_occ != -1 && last_occ > last_idx {
                last_idx = last_occ
                last = index+1
            }
        }
        part2 += first*10 + last
    }
    fmt.printf("%d\n", part1)
    fmt.printf("%d\n", part2)
}
