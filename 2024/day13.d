import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;
import std.regex;
import core.memory;
import std.typecons;

auto readLines(string file)() {
    return import(file).split("\n").filter!(l => l.length != 0);
}

struct Input {
    int ax, ay;
    int bx, by;
    int px, py;
};

const int costA = 3;
const int costB = 1;

Input parse(string[] lines) {
    assert(lines.length == 3);

    Input ret;

    auto r = ctRegex!(`Button .: X\+(\d+), Y\+(\d+)`);
    {
        auto c = matchFirst(lines[0], r);
        assert(c);
        ret.ax = c[1].to!int;
        ret.ay = c[2].to!int;
    }
    {
        auto c = matchFirst(lines[1], r);
        assert(c);
        ret.bx = c[1].to!int;
        ret.by = c[2].to!int;
    }
    auto r2 = ctRegex!(`Prize: X=(\d+), Y=(\d+)`);
    auto c = matchFirst(lines[2], r2);
    assert(c);
    ret.px = c[1].to!int;
    ret.py = c[2].to!int;

    return ret;
}

long[Tuple!(long, long)] dp;
long rec(long cx, long cy, const ref Input input) {
    if (cx > input.px || cy > input.py) return 100000000000000;
    if (cx == input.px && cy == input.py) return 0; // hell yea
    auto cur = tuple(cx, cy);
    if (cur in dp) return dp[cur];
    return dp[cur] = min(costA+rec(cx+input.ax, cy+input.ay, input),
                         costB+rec(cx+input.bx, cy+input.by, input));
}

void main() {
    GC.disable;

    long part1 = 0;
    long part2 = 0;

    foreach (chunk; import("input/13.in").split("\n\n")) {
        Input input = chunk.split("\n").filter!(l => l.length != 0).array.parse;

        dp.clear();
        long cost = rec(0, 0, input);
        if (cost < 100000000000000) {
            part1 += cost;
        }
        input.px += 10000000000000; 
        input.py += 10000000000000; 
        dp.clear();
        cost = rec(0, 0, input);
        if (cost < 100000000000000) {
            part2 += cost;
        }
    }

    writeln("part 1: ", part1);
    writeln("part 2: ", part2);
}
