import std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;

void main() {
    string line;
    int[] a;
    int[] b;
    int[int] count;
    while ((line = readln()) !is null) {
        int[] ns = line.split.map!(a => parse!int(a)).array();
        a ~= ns[0];
        b ~= ns[1];
        count[ns[1]] += 1;
    }
    int part1 = zip(a.sort(), b.sort()).map!(d => abs(d[0]-d[1])).sum();
    writeln("part 1: ", part1);
    int part2 = a.map!(el => el * count.get(el, 0)).sum();
    writeln("part 2: ", part2);
}
