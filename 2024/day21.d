import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math, std.container, std.getopt;
import std.regex;
import core.memory, core.thread.osthread, std.datetime;
import std.typecons;
import std.datetime.stopwatch: StopWatch, AutoStart, benchmark;

import helper;

int[4] dx = [1, 0, -1, 0];
int[4] dy = [0, 1, 0, -1];
char[4] dToC = ['>', 'v', '<', '^'];

Tuple!(int, int) findPos(const ref string[] g, char c) {
    for (int i = 0; i < g.length; ++i) {
        for (int j = 0; j < g[i].length; ++j) {
            if (g[i][j] == c) {
                return tuple(i, j);
            }
        }
    }
    assert(false);
}
immutable auto g1 = ["789", "456", "123", " 0A"];
immutable auto g2 = [" ^A", "<v>"];
long[Tuple!(char, char, int)] memo;
long keypad(int maxLevel)(char target, char start, int level=maxLevel) {
    if (level == -1) return 1;
    auto cur = tuple(target, start, level);
    if (cur in memo) return memo[cur];
    immutable auto g = level == maxLevel ? g1 : g2;
    auto pos = findPos(g, start);
    auto q = GrowableCircularQueue!(Tuple!(int, int, long, char, int))();
    q.push(tuple(pos[0], pos[1], 0L, 'A', 0));
    auto npos = findPos(g, target);
    int maxSteps = abs(pos[0]-npos[0])+abs(pos[1]-npos[1]);
    long ret = long.max;
    while (!q.empty) {
        auto c = q.pop;
        if (g[c[0]][c[1]] == target) {
            ret = min(ret, c[2]+keypad!maxLevel('A', c[3], level-1));
            continue;
        }
        if (c[4] == maxSteps) continue;
        for (int k = 0; k < 4; ++k) {
            int ny = c[0]+dy[k];
            int nx = c[1]+dx[k];
            char nstart = c[3];
            if (nx < 0 || ny < 0 || ny >= g.length || nx >= g[ny].length) continue;
            if (g[ny][nx] == ' ') continue;
            long steps = keypad!maxLevel(dToC[k], nstart, level-1);
            q.push(tuple(ny, nx, c[2]+steps, dToC[k], c[4]+1));
        }
    }
    return memo[cur] = ret;
}

void main(string[] args) {
    GC.disable;

    bool doBenchmark = false;
    getopt(args, "bench", &doBenchmark);

    long part1 = 0;
    long part2 = 0;
    immutable string[] lines = readLines!"input/21.in";

    void solve() {
        part1 = 0;
        part2 = 0;
        memo.clear;
        foreach (line; lines) {
            char prev = 'A';
            foreach (c; line) {
                part1 += keypad!2(c, prev) * line[0..$-1].to!long;
                part2 += keypad!25(c, prev) * line[0..$-1].to!long;
                prev = c;
            }
        }
    }
    solve();
    writeln("part 1: ", part1); 
    writeln("part 2: ", part2);

    if (doBenchmark) {
        immutable int runs = 500;
        auto result = benchmark!(solve)(runs);
        writeln("\nexecuted in: ", result[0]/runs, " (avg of ", runs, " runs)");
    }

}
