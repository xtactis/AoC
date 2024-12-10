import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;
import core.memory;

auto readLines(string file)() {
    return import(file).split("\n").filter!(l => l.length != 0);
}

void main() {
    GC.disable;

    long part1 = 0;
    long part2 = 0;

    string[] m = readLines!"input/11.in".array;

    writeln("part 1: ", part1);
    writeln("part 2: ", part2);
}

