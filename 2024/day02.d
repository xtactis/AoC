import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;

auto readLines(string file) {
    return readText(file).split("\n").filter!(l => l.length != 0);
}

bool checkSafe(int[] ns) {
    return ns.slide(2)
             .map!(ds => abs(ds[0]-ds[1]))
             .map!(d => 0 < d && d < 4).all
           && (ns.isSorted || ns.isSorted!"a > b");
}

void main() {
    int part1 = 0;
    int part2 = 0;
    foreach (line; readLines("input/02.in")) {
        auto ns = line.split.map!(a => parse!int(a)).array();
        bool safe = checkSafe(ns);
        part1 += safe;
        safe |= iota(ns.length).map!(i => checkSafe(ns[0..i]~ns[i+1..$])).any;
        part2 += safe;
    }
    writeln("part 1: ", part1);
    writeln("part 2: ", part2);
}
