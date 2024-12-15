import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;
import std.regex;
import core.memory, core.thread.osthread, std.datetime;
import std.typecons;

void doMove(ref char[][] m, int x, int y, const ref Tuple!(int, int) move) {
    int nx = x + move[1];
    int ny = y + move[0];
    char cur = m[ny][nx];
    if (cur != '.') doMove(m, nx, ny, move);
         if (cur == '[' && move[1] == 0) doMove(m, nx+1, ny, move);
    else if (cur == ']' && move[1] == 0) doMove(m, nx-1, ny, move);
    swap(m[ny][nx], m[y][x]);
}

bool canMove(const ref char[][] m, int x, int y, const ref Tuple!(int, int) move) {
    int nx = x + move[1];
    int ny = y + move[0];

    switch (m[ny][nx]) {
    case '.': return true;
    case 'O': return canMove(m, nx, ny, move);
    case '[': return canMove(m, nx, ny, move) && (move[1] != 0 || canMove(m, nx+1, ny, move));
    case ']': return canMove(m, nx, ny, move) && (move[1] != 0 || canMove(m, nx-1, ny, move));
    case '#': return false;
    default: assert(false);
    }
}

long gpsSum(const ref char[][] m) {
    long ret = 0;
    for (int i = 0; i < m.length; ++i) {
        for (int j = 0; j < m[0].length; ++j) {
            if (m[i][j] != 'O' && m[i][j] != '[') continue;
            ret += i*100+j;
        }
    }
    return ret;
}

long solve(ref char[][] m, const ref string insts) {
    int x, y;
    for (int i = 0; i < m.length; ++i) {
        x = m[i].countUntil!"a == '@'".to!int;
        if (x == -1) continue;
        y = i;
        break;
    }
    immutable auto moveMap = [
        '>': tuple(0, 1),
        'v': tuple(1, 0),
        '<': tuple(0, -1),
        '^': tuple(-1, 0),
    ];
    foreach (inst; insts) {
        if (!canMove(m, x, y, moveMap[inst])) continue;
        doMove(m, x, y, moveMap[inst]);
        x += moveMap[inst][1];
        y += moveMap[inst][0];
    }
    return gpsSum(m);
}

void main() {
    GC.disable;

    long part1 = 0;
    long part2 = 0;

    string[] chunks = import("input/15.in").split("\n\n");

    char[][] m = chunks[0].split("\n").map!(s => s.dup()).array;
    string insts = chunks[1].split("\n").join();

    immutable string[dchar] p2mapping = [
        '#': "##",
        '.': "..",
        'O': "[]",
        '@': "@."
    ];
    char[][] m2 = m.map!(r => r.map!(c => p2mapping[c]).join.dup).array;

    part1 = solve(m, insts);
    part2 = solve(m2, insts);

    writeln("part1: ", part1);
    writeln("part2: ", part2);
}
