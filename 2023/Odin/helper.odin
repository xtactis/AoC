package AOC

import "core:c/libc"
import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"
import "core:time"

get_raw_input :: proc(loc := #caller_location) -> string {
    stem := filepath.short_stem(loc.file_path)
    infile := strings.concatenate({stem, ".in"})
    if !os.exists(infile) {
        libc.system(fmt.ctprintf("get_input %s", strings.trim(stem, "0")))
    }
    u8input := os.read_entire_file_from_filename(infile) or_else fmt.panicf("failed to get input!!!")
    return string(u8input)
}

get_raw_lines :: proc(loc := #caller_location) -> []string {
    return strings.split_lines(get_raw_input(loc)) 
}

get_input :: proc(loc := #caller_location) -> string {
    return strings.trim_space(get_raw_input(loc))
}

get_lines :: proc(loc := #caller_location) -> []string {
    return strings.split_lines(get_input(loc))
}
