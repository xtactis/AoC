import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math, std.container;
import std.regex;
import core.memory, core.thread.osthread, std.datetime;
import std.typecons;
import std.traits: hasIndirections;
import std.datetime.stopwatch: StopWatch, AutoStart, benchmark;

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

auto readLines(string file)() {
    return import(file).strip('\n').split("\n");
}

int[4] dx = [1, 0, -1, 0];
int[4] dy = [0, 1, 0, -1];
char[4] dToC = ['>', 'v', '<', '^'];

Tuple!(int, int) findPos(const ref string[] g, char c) {
    for (int i = 0; i < g.length; ++i) {
        for (int j = 0; j < g[i].length; ++j) {
            if (g[i][j] == c) {
                return tuple(i, j);
            }
        }
    }
    assert(false);
}
immutable auto g1 = ["789", "456", "123", " 0A"];
immutable auto g2 = [" ^A", "<v>"];
long[Tuple!(char, char, int)] memo;
long keypad(int maxLevel)(char target, char start, int level=maxLevel) {
    if (level == -1) return 1;
    auto cur = tuple(target, start, level);
    if (cur in memo) return memo[cur];
    immutable auto g = level == maxLevel ? g1 : g2;
    auto pos = findPos(g, start);
    auto q = GrowableCircularQueue!(Tuple!(int, int, long, char, int))();
    q.push(tuple(pos[0], pos[1], 0L, 'A', 0));
    auto npos = findPos(g, target);
    int maxSteps = abs(pos[0]-npos[0])+abs(pos[1]-npos[1]);
    long ret = long.max;
    while (!q.empty) {
        auto c = q.pop;
        if (g[c[0]][c[1]] == target) {
            ret = min(ret, c[2]+keypad!maxLevel('A', c[3], level-1));
            continue;
        }
        if (c[4] == maxSteps) continue;
        for (int k = 0; k < 4; ++k) {
            int ny = c[0]+dy[k];
            int nx = c[1]+dx[k];
            char nstart = c[3];
            if (nx < 0 || ny < 0 || ny >= g.length || nx >= g[ny].length) continue;
            if (g[ny][nx] == ' ') continue;
            long steps = keypad!maxLevel(dToC[k], nstart, level-1);
            q.push(tuple(ny, nx, c[2]+steps, dToC[k], c[4]+1));
        }
    }
    return memo[cur] = ret;
}

void main() {
    GC.disable;

    long part1 = 0;
    long part2 = 0;

    immutable string[] lines = readLines!"input/21.in";

    immutable int runs = 100;
    void solve() {
        part1 = 0;
        part2 = 0;
        memo.clear;
        foreach (line; lines) {
            char prev = 'A';
            foreach (c; line) {
                part1 += keypad!2(c, prev) * line[0..$-1].to!long;
                part2 += keypad!25(c, prev) * line[0..$-1].to!long;
                prev = c;
            }
        }
    }
    auto result = benchmark!(solve)(runs);

    writeln("part 1: ", part1); 
    writeln("part 2: ", part2);
    writeln("\nexecuted in: ", result[0]/runs, " (avg of ", runs, " runs)");
}
