import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;
import std.regex;
import core.memory, core.thread.osthread, std.datetime;
import std.typecons, std.container;

auto readLines(string file)() {
    return import(file).strip('\n').split("\n");
}

bool[Tuple!(int, int)] bio;
void count(ref Tuple!(int, int, int)[][Tuple!(int, int)] p, Tuple!(int, int, int) s, const Tuple!(int, int) e) {
    bio[tuple(s[0], s[1])] = true;
    if (tuple(s[0], s[1]) == e) return;
    if (tuple(s[0], s[1]) !in p) return;
    writeln(s);
    foreach (n; p[tuple(s[0], s[1])]) {
        if (n[2] > s[2]) continue;
        count(p, n, e);
    }
}

void main() {
    GC.disable;

    long part1 = 0;
    long part2 = 0;

    const string[] m = readLines!"input/16.in";

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

    auto h = heapify!"a[0] > b[0]"([tuple(0, sx, sy, 0)]);
    int[4][m.length][m[0].length] d = 2e9.to!int;
    d[sy][sx][0] = 0;
    Tuple!(int, int, int)[][Tuple!(int, int)] p;
    while (!h.empty) {
        auto c = h.front;
        int d_v = c[0];
        int x = c[1];
        int y = c[2];
        int orientation = c[3];
        h.popFront;

        if (d_v != d[y][x][orientation]) continue;
        if (x == ex && y == ey) part1 = d_v;

        if (m[y+dy[orientation]][x+dx[orientation]] != '#') {
            int nx = x+dx[orientation];
            int ny = y+dy[orientation];
            if (d_v + 1 < d[ny][nx][orientation]) {
                d[ny][nx][orientation] = d_v + 1;
                p[tuple(ny, nx)] = [tuple(y, x, d_v)];
                h.insert(tuple(d_v+1, nx, ny, orientation));
            } else if (d_v + 1 == d[ny][nx][orientation]) {
                p[tuple(ny, nx)] ~= tuple(y, x, d_v);
                h.insert(tuple(d_v+1, nx, ny, orientation));
            }
        }

        if (d_v + 1000 < d[y][x][(orientation+1)%4]) {
            d[y][x][(orientation+1)%4] = d_v + 1000;
            h.insert(tuple(d_v+1000, x, y, (orientation+1)%4));
        }
        if (d_v + 1000 < d[y][x][(orientation-1+4)%4]) {
            d[y][x][(orientation-1+4)%4] = d_v + 1000;
            h.insert(tuple(d_v+1000, x, y, (orientation-1+4)%4));
        }
    }

    count(p, tuple(ey, ex, part1.to!int), tuple(sy, sx));

    for (int i = 0; i < m.length; ++i) {
        for (int j = 0; j < m[0].length; ++j) {
            if (tuple(i, j) in bio) {
                write('O');
            } else {
                write(m[i][j]);
            }
        }
        writeln;
    }
    writeln(p[tuple(7, 5)], d[7][5], d[7][3], d[7][4], p[tuple(7, 4)], p[tuple(7, 3)]);

    part2 = bio.length;

    writeln("part1: ", part1);
    writeln("part2: ", part2);
}
