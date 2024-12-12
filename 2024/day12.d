import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;
import core.memory;
import std.typecons;

auto readLines(string file)() {
    return import(file).split("\n").filter!(l => l.length != 0);
}

import std.traits: hasIndirections;

struct GrowableCircularQueue(T) {
    public size_t length;
    private size_t first, last;
    private T[] A = [T.init];

    this(T[] items...) pure nothrow @safe {
        foreach (x; items)
            push(x);
    }

    @property bool empty() const pure nothrow @safe @nogc {
        return length == 0;
    }

    @property T front() pure nothrow @safe @nogc {
        assert(length != 0);
        return A[first];
    }

    T opIndex(in size_t i) pure nothrow @safe @nogc {
        assert(i < length);
        return A[(first + i) & (A.length - 1)];
    }

    void push(T item) pure nothrow @safe {
        if (length >= A.length) { // Double the queue.
            immutable oldALen = A.length;
            A.length *= 2;
            if (last < first) {
                A[oldALen .. oldALen + last + 1] = A[0 .. last + 1];
                static if (hasIndirections!T)
                    A[0 .. last + 1] = T.init; // Help for the GC.
                last += oldALen;
            }
        }
        last = (last + 1) & (A.length - 1);
        A[last] = item;
        length++;
    }

    @property T pop() pure nothrow @safe @nogc {
        assert(length != 0);
        auto saved = A[first];
        static if (hasIndirections!T)
            A[first] = T.init; // Help for the GC.
        first = (first + 1) & (A.length - 1);
        length--;
        return saved;
    }
}

bool isInMap(int x, int y, const ref string[] m) {
    return !(x < 0 || y < 0 || x >= m[0].length || y >= m.length);
}

void main() {
    GC.disable;

    long part1 = 0;
    long part2 = 0;

    string[] m = readLines!"input/12.in".array;

    int[200][200] bio = 0;
    int[9] dx = [-1, -1, 0, 1, 1, 1, 0, -1, -1];
    int[9] dy = [0, -1, -1, -1, 0, 1, 1, 1, 0];
    for (int i = 0; i < m.length; ++i) {
        for (int j = 0; j < m[0].length; ++j) {
            if (bio[i][j]) continue;
            auto q = GrowableCircularQueue!(Tuple!(int, int))();
            q.push(tuple(i, j));
            bio[i][j] = 1;
            int area = 0;
            int perimiter = 0;
            long sides = 0;
            while (!q.empty) {
                auto cur = q.pop();
                int x = cur[1];
                int y = cur[0];

                area += 1;
                for (int k = 0; k < 8; k+=2) {
                    int nx = x+dx[k];
                    int ny = y+dy[k];
                    if (!isInMap(nx, ny, m) || m[ny][nx] != m[y][x]) {
                        perimiter += 1;
                        continue;
                    }
                    if (bio[ny][nx]) continue;

                    bio[ny][nx] = 1;
                    q.push(tuple(ny, nx));
                }
                for (int k = 1; k < 8; k+=2) {
                    char get(int y, int x) {
                        if (!isInMap(x, y, m)) return 255;
                        return m[y][x];
                    }
                    char me = m[y][x];
                    bool left = me == get(y+dy[k-1], x+dx[k-1]);
                    bool topLeft = me == get(y+dy[k], x+dx[k]);
                    bool top = me == get(y+dy[k+1], x+dx[k+1]);
                    sides += !topLeft && top && left || !top && !left;
                }
            }
            part1 += area*perimiter;
            part2 += area*sides;
        }
    }

    writeln("part 1: ", part1);
    writeln("part 2: ", part2);
}
