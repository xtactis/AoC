import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math, std.getopt;
import std.regex;
import core.memory, core.thread.osthread, std.datetime;
import std.typecons;
import std.datetime.stopwatch: StopWatch, AutoStart, benchmark;
import std.traits: hasIndirections;

import helper;

const int[4] dx = [1, 0, -1, 0];
const int[4] dy = [0, 1, 0, -1];
long[200][200] d;
long normalPicos(const ref string[] m, int x, int y, int px = -1, int py = -1) {
    if (m[y][x] == 'E') {
        return d[y][x] = 0;
    }
    for (int k = 0; k < 4; ++k) {
        int nx = x+dx[k];
        int ny = y+dy[k];
        if (ny < 0 || nx < 0 || ny >= m.length || nx >= m[0].length) continue;
        if (ny == py && nx == px) continue;
        if (m[ny][nx] == '#') continue;
        return d[y][x] = 1+normalPicos(m, nx, ny, x, y);
    }
    assert(false);
}
long picos(int coolCheat)(const ref string[] m, int x, int y, int cheats) {
    auto q = GrowableCircularQueue!(Tuple!(int, int, int))();
    q.push(tuple(y, x, 0));
    bool[200][200] bio = 0;
    long cnt = 0;
    while (!q.empty) {
        auto c = q.pop();
        int cy = c[0];
        int cx = c[1];
        int dist = c[2];
        if (dist > cheats) continue;
        if (m[cy][cx] != '#' && d[y][x]-d[cy][cx]-dist >= coolCheat) {
            cnt += 1;
        }
        for (int k = 0; k < 4; ++k) {
            int nx = cx+dx[k];
            int ny = cy+dy[k];
            if (ny < 0 || nx < 0 || ny >= m.length || nx >= m[0].length) continue;
            if (bio[ny][nx]) continue;
            bio[ny][nx] = true;
            q.push(tuple(ny, nx, dist+1));
        }
    }
    return cnt;
}

void main(string[] args) {
    GC.disable;

    bool doBenchmark = false;
    getopt(args, "bench", &doBenchmark);

    long part1 = 0;
    long part2 = 0;
    immutable string[] m = readLines!"input/20.in";

    void solve() {
        part1 = 0;
        part2 = 0;
        int sx, sy;
        for (int i = 0; i < m.length; ++i) {
            for (int j = 0; j < m[0].length; ++j) {
                if (m[i][j] == 'S') {
                    sy = i;
                    sx = j;
                }
            }
        }
        normalPicos(m, sx, sy);
        for (int y = 0; y < m.length; ++y) {
            for (int x = 0; x < m[0].length; ++x) {
                part1 += picos!100(m, x, y, 2);
                part2 += picos!100(m, x, y, 20);
            }
        }
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
