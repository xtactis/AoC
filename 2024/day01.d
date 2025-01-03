import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;

auto readLines(string file) {
    return readText(file).split("\n").filter!(l => l.length != 0);
}

void main() {
    int[] a, b;
    int[int] count;
    foreach (line; readLines("input/01.in")) {
        auto ns = line.split.map!(a => parse!int(a));
        a ~= ns[0];
        b ~= ns[1];
        count[b.back()] += 1;
    }
    int part1 = zip(a.sort(), b.sort()).map!(d => abs(d[0]-d[1])).sum();
    writeln("part 1: ", part1);
    int part2 = a.map!(el => el * count.get(el, 0)).sum();
    writeln("part 2: ", part2);
}
