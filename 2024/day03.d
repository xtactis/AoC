import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math, std.regex;

auto readLines(string file) {
    return readText(file).split("\n").filter!(l => l.length != 0);
}

int solvePart1(string line) {
    int ret = 0;
    auto r = ctRegex!(`mul\(([0-9]+),([0-9]+)\)`);
    foreach (c; matchAll(line, r)) {
        ret += to!int(c[1])*to!int(c[2]);
    }
    return ret;
}

void main() {
    int part1 = 0;
    int part2 = 0;
    string line = "do()"~readText("input/03.in")~"don't()";
    part1 += solvePart1(line);

    while (!line.empty) {
        long firstDo = countUntil(line, "do()");
        if (firstDo == -1) break;
        line = line[firstDo..$];
        long end = countUntil(line, "don't()")+7;
        part2 += solvePart1(line[0..end]);
        line = line[end..$];
    }

    writeln("part 1: ", part1);
    writeln("part 2: ", part2);
}
