import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;
import std.regex;
import core.memory, core.thread.osthread, std.datetime;
import std.typecons, std.container;
import std.datetime.stopwatch: StopWatch, AutoStart, benchmark;

import helper;

void main() {
    GC.disable;

    long part1 = 2e9.to!long;
    long part2 = 0;

    const ulong n = readLines!"input/16.in".length;
    char[][] m = readLines!"input/16.in".map!dup.array;

    int sx, sy, ex, ey;

    for (int i = 0; i < m.length; ++i) {
        for (int j = 0; j < m[0].length; ++j) {
            if (m[i][j] == 'S') {
                sx = j;
                sy = i;
            } else if (m[i][j] == 'E') {
                ex = j;
                ey = i;
            }
        }
    }

    int[4] dx = [1, 0, -1, 0];
    int[4] dy = [0, 1, 0, -1];

    auto h = heapify!"a[0] > b[0]"([tuple(0, sx, sy, 0, [tuple(sy, sx)])]);
    int[4][n][n] d = 2e9.to!int;
    d[sy][sx][0] = 0;
    while (!h.empty) {
        auto c = h.front;
        int d_v = c[0];
        int x = c[1];
        int y = c[2];
        int orientation = c[3];
        Tuple!(int, int)[] l = c[4];

        h.popFront;

        if (d_v != d[y][x][orientation]) continue;
        if (x == ex && y == ey) {
            if (d_v > part1) break;
            foreach (e; l) {
                if (m[e[0]][e[1]] != 'O') {
                    part2 += 1;
                }
                m[e[0]][e[1]] = 'O';
            }
            part1 = d_v;
        }

        if (m[y+dy[orientation]][x+dx[orientation]] != '#') {
            int nx = x+dx[orientation];
            int ny = y+dy[orientation];
            if (d_v + 1 <= d[ny][nx][orientation]) {
                d[ny][nx][orientation] = d_v + 1;
                h.insert(tuple(d_v+1, nx, ny, orientation, l~tuple(ny, nx)));
            }
        }

        foreach (k; [-1, 1]) {
            if (d_v + 1000 <= d[y][x][(orientation+k+4)%4]) {
                d[y][x][(orientation+k+4)%4] = d_v + 1000;
                h.insert(tuple(d_v+1000, x, y, (orientation+k+4)%4, l));
            }
        }
    }

    writeln("part1: ", part1);
    writeln("part2: ", part2);
}
