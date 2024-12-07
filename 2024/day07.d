
import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;

auto readLines(string file) {
    return readText(file).split("\n").filter!(l => l.length != 0);
}

long cat(long a, long b) {
    if (a == 0) return b;

    long d = 1;
    while (d <= b) {
        d *= 10;
    }
    return a*d + b;
}

bool possible(bool canCat = false)(long target, long[] l, long sum, int i) {
    if (sum > target) return false;
    if (i == l.length) return sum == target;
    return possible!canCat(target, l, sum + l[i], i + 1)
        || possible!canCat(target, l, sum * l[i], i + 1)
        || (canCat && possible!canCat(target, l, cat(sum, l[i]), i+1));
}

void main() {
    long part1 = 0;
    long part2 = 0;

    foreach(line; readLines("input/07.in")) {
        auto ss = line.split(": ");
        long target = to!long(ss[0]);
        long[] l = ss[1].split(" ").map!(to!long).array;

        if (possible(target, l, l[0], 1)) {
            part1 += target;
        } else if (possible!true(target, l, l[0], 1)) {
            part2 += target;
        }
    }

    writeln("part 1: ", part1);
    writeln("part 2: ", part1+part2);
}
