import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;

auto readLines(string file) {
    return readText(file).split("\n").filter!(l => l.length != 0);
}

void main() {
    int part1 = 0;
    int part2 = 0;
    bool enabled = true;
    foreach (line; readLines("input/03.in")) {
        while (!line.empty) {
            int a = 0, b = 0;
            long firstDo = countUntil(line, "do()");
            long firstDont = countUntil(line, "don't()");
            long firstMul = countUntil(line, "mul(");
            if (firstMul == -1) break;
            if (enabled) {
                if (firstDont != -1 && firstDont < firstMul) {
                    line = line[firstDont+7..$];
                    enabled = false;
                    continue;
                }
            } else {
                if (firstDo == -1) break;
                line = line[firstDo+4..$];
                enabled = true;
                continue;
            }
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

            part1 += a*b;
        }
    }
    writeln("part 1: ", part1);
    writeln("part 2: ", part2);
}
