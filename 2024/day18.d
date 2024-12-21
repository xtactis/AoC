import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math, std.getopt;
import std.regex;
import core.memory, core.thread.osthread, std.datetime;
import std.typecons;
import std.datetime.stopwatch: StopWatch, AutoStart, benchmark;

import helper;

long[] parse(const ref string line) {
    return matchAll(line, ctRegex!(`(-?\d+)`)).map!"a.hit.to!long".array;
}

bool isInMap(int x, int y) {
    return !(x < 0 || y < 0 || x >= 71 || y >= 71);
}

void main(string[] args) {
    GC.disable;

    bool doBenchmark = false;
    getopt(args, "bench", &doBenchmark);

    long part1 = 0;
    long[] part2;

    long[][] lines = readLines!"input/18.in".map!parse.array;

    void solve() {
        part1 = 0;
        part2 = [];
        bool[71][71] m;

        for (int i = 0; i < 1024; ++i) {
            long x = lines[i][0];
            long y = lines[i][1];

            m[y][x] = true;
        }

        int[4] dx = [1, 0, -1, 0];
        int[4] dy = [0, 1, 0, -1];

        int k = 1024;
        do {
            auto q = GrowableCircularQueue!(Tuple!(int, int, int))(tuple(0, 0, 0));
            bool[71][71] bio = 0;
            bool foundExit = false;
            while (!q.empty) {
                auto cur = q.pop;
                int x = cur[0];
                int y = cur[1];
                int steps = cur[2];

                if (x == 70 && y == 70) {
                    if (part1 == 0) {
                        part1 = steps;
                    }
                    foundExit = true;
                    break;
                }

                for (int i = 0; i < 4; ++i) {
                    int nx = x + dx[i];
                    int ny = y + dy[i];

                    if (!isInMap(nx, ny)) continue;
                    if (m[ny][nx]) continue;
                    if (bio[ny][nx]) continue;

                    bio[ny][nx] = true;

                    q.push(tuple(nx, ny, steps+1));
                }
            }
            if (!foundExit) {
                part2 = lines[k-1];
                break;
            }
            long x = lines[k][0];
            long y = lines[k][1];
            m[y][x] = true;
            k += 1;
        } while (k < lines.length);
    }
    solve();
    writeln("part 1: ", part1); 
    writeln("part 2: ", part2);

    if (doBenchmark) {
        immutable int runs = 50;
        auto result = benchmark!(solve)(runs);
        writeln("\nexecuted in: ", result[0]/runs, " (avg of ", runs, " runs)");
    }
}
