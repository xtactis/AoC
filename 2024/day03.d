import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;

auto readLines(string file) {
    return readText(file).split("\n").filter!(l => l.length != 0);
}

int solvePart1(string line) {
    int ret = 0;
    while (!line.empty) {
        int a = 0, b = 0;
        long firstMul = countUntil(line, "mul(");
        if (firstMul == -1) break;
        line = line[firstMul+4..$];
        try {
            a = parse!(int)(line);
        } catch (ConvException) {
            continue;
        }
        if (a > 999) continue;
        if (line[0] != ',') continue;
        line = line[1..$];
        try {
            b = parse!(int)(line);
        } catch (ConvException) {
            continue;
        }
        if (b > 999) continue;
        if (line[0] != ')') continue;
        line = line[1..$];

        ret += a*b;
    }
    return ret;
}

void main() {
    int part1 = 0;
    int part2 = 0;
    string line = readText("input/03.in");
    part1 += solvePart1(line);

    auto getIntervalEnd = (ref string line) {
        long firstDont = countUntil(line, "don't()");
        return firstDont == -1 ? line.length : firstDont+7;
    };
    long end = getIntervalEnd(line);
    part2 += solvePart1(line[0..end]);
    writeln(line[0..end]);
    line = line[end..$];
    while (!line.empty) {
        long firstDo = countUntil(line, "do()");
        if (firstDo == -1) break;
        line = line[firstDo..$];
        end = getIntervalEnd(line);
        writeln(line[0..end]);
        part2 += solvePart1(line[0..end]);
        line = line[end..$];
    }

    writeln("part 1: ", part1);
    writeln("part 2: ", part2);
}
