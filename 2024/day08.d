import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;
import core.memory;

auto readLines(string file)() {
    return import(file).split("\n").filter!(l => l.length != 0);
}

struct pos {
    int x, y;

    pos opBinary(string op: "+")(const pos rhs) {
        return pos(x+rhs.x, y+rhs.y);
    }

    pos opBinary(string op: "-")(const pos rhs) {
        return pos(x-rhs.x, y-rhs.y);
    }

    pos opBinary(string op: "*")(ulong k) {
        return pos(x*to!int(k), y*to!int(k));
    }
};

void main() {
    GC.disable;

    string[] m = readLines!"input/08.in".array;
 
    pos[][char] nodes;
    for (int i = 0; i < m.length; ++i) {
        for (int j = 0; j < m[0].length; ++j) {
            if (m[i][j] == '.') continue;
            nodes[m[i][j]] ~= pos(j, i);
        }
    }
    
    bool[pos] part1;
    bool[pos] part2;
    foreach (ref pos[] sameNodes; nodes) {
        foreach (ref a, ref b; cartesianProduct(sameNodes, sameNodes)) {
            if (a == b) continue;
            foreach (ulong k, ref pos an; sequence!"a[0]+(a[1]-a[0])*n"(a, b).enumerate) {
                if (an.x < 0 || an.x >= m[0].length || an.y < 0 || an.y >= m.length) break;
                part2[an] = true;
                if (k == 2) part1[an] = true;
            }
        }
    }

    writeln("part 1: ", part1.length);
    writeln("part 2: ", part2.length);
}
