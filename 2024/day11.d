import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;
import core.memory;

auto readLines(string file)() {
    return import(file).split("\n").filter!(l => l.length != 0);
}

int countDigits(long x) {
    long d = 1;
    int c = 0;
    while (d <= x) {
        d *= 10;
        c += 1;
    }
    return c;
}

long[long][100] dp;
long rec(long x, long i) {
    if (i == 0) return 1;
    if (x in dp[i]) return dp[i][x];
    int dig = countDigits(x);
    long d = 10 ^^ (dig / 2);
    return dp[i][x] = x == 0       ? rec(1, i-1)
                    : dig % 2 == 0 ? rec(x / d, i-1) + rec(x % d, i-1)
                    :                rec(x * 2024, i-1);
}

void main() {
    GC.disable;

    long part1 = 0;
    long part2 = 0;

    auto a = import("input/11.in").split.map!(to!long);

    foreach (long x; a) {
        part1 += rec(x, 25);
        part2 += rec(x, 75);
    }

    writeln("part 1: ", part1);
    writeln("part 2: ", part2);
}
