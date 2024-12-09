import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;
import core.memory;

auto readLines(string file)() {
    return import(file).split("\n").filter!(l => l.length != 0);
}

void main() {
    GC.disable;

    long part1 = 0;
    long part2 = 0;

    int[] h = readLines!"input/09.in".front.map!(c => to!int(c-'0')).array;
    int[] a;
    bool empty = false;
    foreach (i, x; h) {
        for (int j = 0; j < x; ++j) {
            a ~= empty ? -1 : to!int(i/2);
        }
        empty = !empty;
    }
    int[] b = a.dup;

    for (ulong front = 0, i = a.length-1; i > front; --i) {
        if (a[i] == -1) continue;
        while (a[front] != -1) ++front;
        if (i <= front) break;
        swap(a[front], a[i]);
    }
    foreach (i, x; a) {
        if (x == -1) break;
        part1 += i*x;
    }

    ulong lastId = -1;
    for (ulong i = b.length-1; i > 0; --i) {
        ulong front = 0;
        ulong frontLength = 0;
        ulong curLength = 0;
        if (b[i] == -1 || b[i] >= lastId) continue;
        if (b[i] == 0) break;
        lastId = b[i];
        while (b[i-curLength] == b[i]) ++curLength;
        while (frontLength < curLength) {
            front += frontLength;
            frontLength = 0;
            while (b[front] != -1 && ++front <= i-curLength) {}
            if (front > i-curLength) break;
            while (front+frontLength < b.length && b[front+frontLength] == -1) {
                ++frontLength;
            }
        }
        if (front < i-curLength) {
            int value = b[i];
            for (ulong j = 0; j < curLength; ++j) {
                b[front+j] = value;
                b[i-curLength+1+j] = -1;
            }
        }
        i -= curLength-1;
    }
    foreach (i, x; b) {
        if (x == -1) continue;
        part2 += i*x;
    }

    writeln("part 1: ", part1);
    writeln("part 2: ", part2);
}

