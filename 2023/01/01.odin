package Day01

import "core:fmt"

import helper ".."

main :: proc() {
    input, ok := helper.get_input()
    if !ok {
        fmt.panicf("failed to get input!!!")
    }

    fmt.printf(input)
}
