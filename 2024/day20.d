import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;
import std.regex;
import core.memory, core.thread.osthread, std.datetime;
import std.typecons;
import std.datetime.stopwatch: StopWatch, AutoStart, benchmark;
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

auto readLines(string file)() {
    return import(file).strip('\n').split("\n");
}

const int[4] dx = [1, 0, -1, 0];
const int[4] dy = [0, 1, 0, -1];
long[200][200] d;
long normalPicos(const ref string[] m, int x, int y, int px = -1, int py = -1) {
    if (m[y][x] == 'E') {
        return d[y][x] = 0;
    }
    for (int k = 0; k < 4; ++k) {
        int nx = x+dx[k];
        int ny = y+dy[k];
        if (ny < 0 || nx < 0 || ny >= m.length || nx >= m[0].length) continue;
        if (ny == py && nx == px) continue;
        if (m[ny][nx] == '#') continue;
        return d[y][x] = 1+normalPicos(m, nx, ny, x, y);
    }
    assert(false);
}
long picos(int coolCheat)(const ref string[] m, int x, int y, int cheats) {
    auto q = GrowableCircularQueue!(Tuple!(int, int, int))();
    q.push(tuple(y, x, 0));
    bool[200][200] bio = 0;
    long cnt = 0;
    while (!q.empty) {
        auto c = q.pop();
        int cy = c[0];
        int cx = c[1];
        int dist = c[2];
        if (dist > cheats) continue;
        if (m[cy][cx] != '#' && d[y][x]-d[cy][cx]-dist >= coolCheat) {
            cnt += 1;
        }
        for (int k = 0; k < 4; ++k) {
            int nx = cx+dx[k];
            int ny = cy+dy[k];
            if (ny < 0 || nx < 0 || ny >= m.length || nx >= m[0].length) continue;
            if (bio[ny][nx]) continue;
            bio[ny][nx] = true;
            q.push(tuple(ny, nx, dist+1));
        }
    }
    return cnt;
}

void main() {
    GC.disable;

    long part1 = 0;
    long part2 = 0;

    string[] m = readLines!"input/20.in";

    immutable int runs = 50;
    void solve() {
        part1 = 0;
        part2 = 0;
        int sx, sy;
        for (int i = 0; i < m.length; ++i) {
            for (int j = 0; j < m[0].length; ++j) {
                if (m[i][j] == 'S') {
                    sy = i;
                    sx = j;
                }
            }
        }
        normalPicos(m, sx, sy);
        for (int y = 0; y < m.length; ++y) {
            for (int x = 0; x < m[0].length; ++x) {
                part1 += picos!100(m, x, y, 2);
                part2 += picos!100(m, x, y, 20);
            }
        }
    }
    auto result = benchmark!(solve)(runs);

    writeln("part 1: ", part1); 
    writeln("part 2: ", part2);
    writeln("\nexecuted in: ", result[0]/runs, " (avg of ", runs, " runs)");
}
