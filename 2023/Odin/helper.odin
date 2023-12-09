package AOC

import "core:c/libc"
import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strconv"
import "core:strings"
import "core:time"

get_raw_input :: proc(loc := #caller_location) -> string {
    stem := filepath.short_stem(loc.file_path)
    infile := strings.concatenate({"../../input/", stem, ".in"})
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

parse_int :: proc(s: string) -> int {
    return strconv.parse_int(s) or_else fmt.panicf("couldn't parse int from %s", s)
}

parse_ints :: proc(s: []string) -> []int {
    cnt := 0
    for ss in s {
        if ss != "" do cnt += 1
    }
    result := make([]int, cnt)
    i := 0
    for ss in s {
        if ss == "" do continue
        result[i] = parse_int(ss)
        i += 1
    }
    return result
}

bench :: proc(f: #type proc() -> (int, int), runs:=1) {
    runs := runs
    if len(os.args) == 2 {
        runs = strconv.parse_int(os.args[1]) or_else panic("")
    }
    total : time.Duration
    context.allocator = context.temp_allocator
    p1, p2 : int
    for t in 0..<runs {
        start := time.now()
        p1, p2 = f()
        total += time.since(start)
        free_all(context.allocator)
    }
    fmt.println(total / time.Duration(runs))
    fmt.printf("%d\n%d\n", p1, p2)
}
