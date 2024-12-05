import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;

auto readLines(string file) {
    return readText(file).split("\n").filter!(l => l.length != 0);
}

auto readSectionLines(string file) {
    return readText(file).split("\n\n").map!(section => section.split("\n").filter!(l => !l.empty));
}

int[2] checkOrdering(const ref int[] update, const ref bool[int][int] g) {
    for (int i = 0; i < update.length-1; ++i) {
        for (int j = i+1; j < update.length; ++j) {
            if (g[update[j]].get(update[i], false)) {
                return [i, j];
            }
        }
    }
    return [-1, -1];
}

void main() {
    int part1 = 0;
    int part2 = 0;
    auto sections = readSectionLines("input/05.in").array;
    auto rules = sections[0].map!(rule => rule.split("|").map!(to!int)).array;
    bool[int][int] g;
    foreach (rule; rules) {
        g[rule[0]][rule[1]] = true;
    }
    foreach (mUpdate; sections[1].map!(sUpdate => sUpdate.split(",").map!(to!int))) {
        auto update = mUpdate.array; // I hate this
        if (checkOrdering(update, g)[0] == -1) {
            part1 += update[update.length/2];
            continue;
        }
        while (true) {
            auto err = checkOrdering(update, g);
            if (err[0] == -1) break;
            swap(update[err[0]], update[err[1]]);
        }
        part2 += update[update.length/2];
    }
    writeln("part 1: ", part1);
    writeln("part 2: ", part2);
}
