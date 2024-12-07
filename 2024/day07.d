import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;
import core.memory;

auto readLines(string file)() {
    return import(file).split("\n").filter!(l => l.length != 0);
}

bool possible2(bool canCat = false)(long target, const long[] l, ulong i) {
    if (i == 0) return target == l[0];
    if (target < l[i]) return false;
    bool dog(long a, long b) {
        long d = 1;
        while (d <= b) {
            d *= 10;
        }
        return a % d == b && possible2!canCat(a/d, l, i-1);
    }
    return possible2!canCat(target-l[i], l, i-1)
        || (target%l[i] == 0 && possible2!canCat(target/l[i], l, i-1))
        || (canCat && dog(target, l[i]));
}

void main() {
    GC.disable;
    long part1 = 0;
    long part2 = 0;

    foreach (line; readLines!"input/07.in") {
        auto ss = line.split(": ");
        long target = to!long(ss[0]);
        long[] l = ss[1].split(" ").map!(to!long).array;

        if (possible2(target, l, l.length-1)) {
            part1 += target;
        } else if (possible2!true(target, l, l.length-1)) {
            part2 += target;
        }
    }

    writeln("part 1: ", part1);
    writeln("part 2: ", part1+part2);
}
