import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math, std.regex;

int solvePart1(string line) {
    auto r = ctRegex!(`mul\(([0-9]+),([0-9]+)\)`, "s");
    return matchAll(line, r).map!(c => to!int(c[1])*to!int(c[2])).sum;
}

void main() {
    string line = "do()"~readText("input/03.in")~"don't()";
    int part1 = solvePart1(line);

    auto r = ctRegex!(`do\(\)(.*?)don't\(\)`, "s");
    int part2 = matchAll(line, r).map!(c => solvePart1(c[1])).sum;

    writeln("part 1: ", part1);
    writeln("part 2: ", part2);
}
