package AOC

import "core:c/libc"
import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strings"
import "core:time"

get_input :: proc(loc := #caller_location) -> (input: string, success: bool) {
    stem := filepath.short_stem(loc.file_path)
    infile := strings.concatenate({stem, ".in"})
    if !os.exists(infile) {
        libc.system(fmt.ctprintf("get_input %s", stem))
    }
    u8input : []u8
    u8input, success = os.read_entire_file_from_filename(infile)
    input = string(u8input)
    return
}
