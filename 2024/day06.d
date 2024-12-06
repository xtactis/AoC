import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;

auto readLines(string file) {
    return readText(file).split("\n").filter!(l => l.length != 0);
}

int[] dx = [0, 1, 0, -1];
int[] dy = [-1, 0, 1, 0];
int dir = 0; // up

bool checkLoop(string[] m, bool[int[3]] exact, int y, int x, int dir) {
    m[y+dy[dir]] = m[y+dy[dir]][0..x+dx[dir]]~'#'~m[y+dy[dir]][x+dx[dir]+1..$];
    while (true) {
        exact[[y, x, dir]] = true;
        int ny = y+dy[dir];
        int nx = x+dx[dir];
        if (ny < 0 || nx < 0 || ny >= m.length || nx >= m[0].length) break;
        if (m[ny][nx] == '#') {
            dir = (dir+1)%4;
            continue; // try again while facing other direction
        }
        y = ny;
        x = nx;
        if (exact.get([y, x, dir], false)) return true;
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
    bool[int[2]] found;
    bool[int[3]] exact;
    bool[int[2]] possible;
    possible[[y, x]] = false;
    while (true) {
        if (!found.get([y, x], false)) part1 += 1;
        found[[y, x]] = true;
        exact[[y, x, dir]] = true;
        int ny = y+dy[dir];
        int nx = x+dx[dir];
        if (ny < 0 || nx < 0 || ny >= m.length || nx >= m[0].length) break;
        if (m[ny][nx] == '#') {
            dir = (dir+1)%4;
            continue; // try again while facing other direction
        }
        if (!found.get([ny, nx], false) && checkLoop(m.dup, exact.dup, y, x, dir)) {
            possible[[ny, nx]] &= true;
        }
        y = ny;
        x = nx;
    }
    writeln("part 1: ", part1);
    writeln("part 2: ", possible.length-1);
}
