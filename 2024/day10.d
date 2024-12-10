import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;
import core.memory;

auto readLines(string file)() {
    return import(file).split("\n").filter!(l => l.length != 0);
}

int[] dx = [-1, 0, 1, 0];
int[] dy = [0, -1, 0, 1];

bool[int[2]] bio;
int dfs(bool part2=false)(const ref string[] m, int y, int x) {
    if (m[y][x] == '9') {
        if (!part2) {
            if ([x, y] in bio) return 0;
            bio[[x, y]] = true;
        }
        return 1;
    }
    int ret = 0;
    for (int i = 0; i < 4; ++i) {
        int nx = x+dx[i];
        int ny = y+dy[i];
        if (nx < 0 || ny < 0 || nx >= m[0].length || ny >= m.length) continue;
        if (m[ny][nx]-m[y][x] != 1) continue;
        ret += dfs!part2(m, ny, nx);
    }
    return ret;
}

void main() {
    GC.disable;

    long part1 = 0;
    long part2 = 0;

    string[] m = readLines!"input/10.in".array;
    for (int i = 0; i < m.length; ++i) {
        for (int j = 0; j < m[0].length; ++j) {
            if (m[i][j] != '0') continue;
            bio.clear();
            part1 += dfs(m, i, j);
            part2 += dfs!true(m, i, j);
        }
    }

    writeln("part 1: ", part1);
    writeln("part 2: ", part2);
}

