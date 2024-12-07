
import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;

auto readLines(string file) {
    return readText(file).split("\n").filter!(l => l.length != 0);
}

struct state {
    long sum;
    int i;
};

bool[state] dp;
bool possible(long target, long[] l, long sum = 0, int i = 0) {
    if (i == l.length) return sum == target;
    state cur = state(sum, i);
    if (cur in dp) return dp[cur];
    return dp[cur] = possible(target, l, sum + l[i], i + 1)
                  || possible(target, l, sum == 0 ? l[i] : sum * l[i], i + 1);
}

long cat(long a, long b) {
    if (a == 0) return b;

    int[] d;
    while (b) {
        d ~= (b % 10);
        b /= 10;
    }
    foreach_reverse (digit; d) {
        a *= 10;
        a += digit;
    }
    return a;
}

bool p2possible(long target, long[] l, long sum = 0, int i = 0) {
    if (i == l.length) return sum == target;
    state cur = state(sum, i);
    if (cur in dp) return dp[cur];
    return dp[cur] = p2possible(target, l, sum + l[i], i + 1)
                  || p2possible(target, l, sum == 0 ? l[i] : sum * l[i], i + 1)
                  || p2possible(target, l, cat(sum, l[i]), i+1);
}

void main() {
    long part1 = 0;
    long part2 = 0;

    foreach(line; readLines("input/07.in")) {
        auto ss = line.split(": ");
        long target = to!long(ss[0]);
        long[] l = ss[1].split(" ").map!(to!long).array;

        dp.clear();
        if (possible(target, l)) {
            part1 += target;
        }
        dp.clear();
        if (p2possible(target, l)) {
            part2 += target;
        }
    }

    writeln("part 1: ", part1);
    writeln("part 2: ", part2);
}
