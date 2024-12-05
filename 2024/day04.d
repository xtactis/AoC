import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;

auto readLines(string file) {
    return readText(file).split("\n").filter!(l => l.length != 0);
}

void main() {
    int part1 = 0;
    int part2 = 0;
    string[] m = readLines("input/04.in").array;

    int[] dx = [1, 1, 0, -1, -1, -1, 0, 1];
    int[] dy = [0, -1, -1, -1, 0, 1, 1, 1];
    string target = "XMAS";
    char[3][3][4] p2target = [
        ["S.S", ".A.", "M.M"],
        ["S.M", ".A.", "S.M"],
        ["M.S", ".A.", "M.S"],
        ["M.M", ".A.", "S.S"],
    ];

    for (int i = 0; i < m.length; ++i) {
        for (int j = 0; j < m[0].length; ++j) {
            for (int k = 0; k < 8; ++k) {
                bool found = true;
                for (int d = 0; d < 4; ++d) {
                    int x = j+dx[k]*d;
                    int y = i+dy[k]*d;
                    if (x < 0 || y < 0 || x >= m[0].length || y >= m.length || m[y][x] != target[d]) {
                        found = false;
                        break;
                    }
                }
                part1 += found;
            }
            if (m.length - i < 3 || m[0].length - j < 3) continue;
            foreach (t; p2target) {
                for (int k = 0; k < 3; ++k) {
                    for (int l = 0; l < 3; ++l) {
                        if (t[k][l] == '.') continue;
                        if (t[k][l] != m[i+k][j+l]) {
                            goto afterSearch;
                        }
                    }
                }
                part2 += 1;
                break;
afterSearch:
            }
        }
    }

    writeln("part 1: ", part1);
    writeln("part 2: ", part2);
}
