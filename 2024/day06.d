import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;

auto readLines(string file) {
    return readText(file).split("\n").filter!(l => l.length != 0);
}

int[] dx = [0, 1, 0, -1];
int[] dy = [-1, 0, 1, 0];

bool checkLoop(const ref string[] m, int y, int x, int dir) {
    int wx = x+dx[dir];
    int wy = y+dy[dir];
    bool[int[3]] exact;
    while (true) {
        int ny = y+dy[dir];
        int nx = x+dx[dir];
        if (ny < 0 || nx < 0 || ny >= m.length || nx >= m[0].length) break;
        if ((ny == wy && nx == wx) || m[ny][nx] == '#') {
            if ([y, x, dir] in exact) return true;
            exact[[y, x, dir]] = true;
            dir = (dir+1)%4;
            continue; // try again while facing other direction
        }
        y = ny;
        x = nx;
    }
    return false;
}

void main() {
    int part1 = 0;
    int part2 = 0;
    string[] m = readLines("input/06.in").array;

    int x = -1, y = -1;
    for (int i = 0; i < m.length; ++i) {
        for (int j = 0; j < m[0].length; ++j) {
            if (m[i][j] == '^') {
                x = j;
                y = i;
                goto MiranovTeritorij;
            }
        }
    }
MiranovTeritorij:
    int dir = 0; // up
    bool[int[2]] found;
    while (true) {
        if ([y, x] !in found) part1 += 1;
        found[[y, x]] = true;
        int ny = y+dy[dir];
        int nx = x+dx[dir];
        if (ny < 0 || nx < 0 || ny >= m.length || nx >= m[0].length) break;
        if (m[ny][nx] == '#') {
            dir = (dir+1)%4;
            continue; // try again while facing other direction
        }
        if (m[ny][nx] != '^' && [ny, nx] !in found && checkLoop(m, y, x, dir)) {
            part2 += 1;
        }
        y = ny;
        x = nx;
    }
    writeln("part 1: ", part1);
    writeln("part 2: ", part2);
}
