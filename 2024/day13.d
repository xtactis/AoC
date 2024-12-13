import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;
import std.regex;
import core.memory;
import std.typecons;

auto readLines(string file)() {
    return import(file).split("\n").filter!(l => l.length != 0);
}

union Input {
    long[6] arr;
    struct {
        long ax, ay;
        long bx, by;
        long px, py;
    };
};

const int costA = 3;
const int costB = 1;

Input parse(const ref string chunk) {
    return Input(matchAll(chunk, ctRegex!(`(\d+)`)).map!"a.hit.to!long".staticArray!6);
}

Tuple!(long, long) solve(const ref Input input) {
    long Kd = input.px*input.by-input.bx*input.py;
    long KD = input.ax*input.by-input.ay*input.bx;
    if (Kd % KD != 0) return tuple(0L, 0L);
    long K = Kd / KD;
    long Ld = input.py-input.ay*K;
    long LD = input.by;
    if (Ld % LD != 0) return tuple(0L, 0L);
    long L = Ld / LD;
    return tuple(K, L);
}

void main() {
    GC.disable;

    long part1 = 0;
    long part2 = 0;

    foreach (input; import("input/13.in").split("\n\n").map!parse) {
        auto c = solve(input);
        if (c[0] <= 100 && c[1] <= 100) {
            part1 += costA*c[0]+costB*c[1];
        }
        
        input.px += 10000000000000;
        input.py += 10000000000000;
        c = solve(input);
        part2 += costA*c[0]+costB*c[1];
    }

    writeln("part 1: ", part1);
    writeln("part 2: ", part2);
}
