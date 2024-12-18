import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;
import std.regex;
import core.memory, core.thread.osthread, std.datetime;
import std.typecons;

auto readLines(string file)() {
    return import(file).strip('\n').split("\n");
}

long[] parse(const ref string line) {
    return matchAll(line, ctRegex!(`(-?\d+)`)).map!"a.hit.to!long".array;
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

bool isInMap(int x, int y) {
    return !(x < 0 || y < 0 || x >= 71 || y >= 71);
}

void main() {
    GC.disable;

    long part1 = 0;
    long[] part2;

    //string[] chunks = import("input/18.in").split("\n\n");
    long[][] lines = readLines!"input/18.in".map!parse.array;

    bool[71][71] m;

    for (int i = 0; i < 1024; ++i) {
        long x = lines[i][0];
        long y = lines[i][1];

        m[y][x] = true;
    }

    int[4] dx = [1, 0, -1, 0];
    int[4] dy = [0, 1, 0, -1];

    int k = 1024;
    do {
        auto q = GrowableCircularQueue!(Tuple!(int, int, int))(tuple(0, 0, 0));
        bool[71][71] bio = 0;
        bool foundExit = false;
        while (!q.empty) {
            auto cur = q.pop;
            int x = cur[0];
            int y = cur[1];
            int steps = cur[2];

            if (x == 70 && y == 70) {
                if (part1 == 0) {
                    part1 = steps;
                }
                foundExit = true;
                break;
            }

            for (int i = 0; i < 4; ++i) {
                int nx = x + dx[i];
                int ny = y + dy[i];

                if (!isInMap(nx, ny)) continue;
                if (m[ny][nx]) continue;
                if (bio[ny][nx]) continue;

                bio[ny][nx] = true;

                q.push(tuple(nx, ny, steps+1));
            }
        }
        if (!foundExit) {
            writeln(k);
            part2 = lines[k-1];
            break;
        }
        long x = lines[k][0];
        long y = lines[k][1];
        m[y][x] = true;
        k += 1;
    } while (k < lines.length);

    writeln("part 1: ", part1); 
    writeln("part 2: ", part2);
}
