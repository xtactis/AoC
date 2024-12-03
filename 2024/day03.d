import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math, std.regex;

auto readLines(string file) {
    return readText(file).split("\n").filter!(l => l.length != 0);
}

int solvePart1(string line) {
    int ret = 0;
    auto r = ctRegex!(`mul\(([0-9]+),([0-9]+)\)`, "s");
    return matchAll(line, r).fold!((a, c) => a + to!int(c[1])*to!int(c[2]))(0);
}

void main() {
    string line = "do()"~readText("input/03.in")~"don't()";
    int part1 = solvePart1(line);

    auto r = ctRegex!(`do\(\)(.*?)don't\(\)`, "s");
    int part2 = matchAll(line, r).fold!((a, c) => a + solvePart1(c[1]))(0);

    writeln("part 1: ", part1);
    writeln("part 2: ", part2);
}
