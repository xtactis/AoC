import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;
import std.regex;
import core.memory, core.thread.osthread, std.datetime;
import std.typecons;

auto readLines(string file)() {
    return import(file).strip('\n').split("\n");
}

union Input {
    int[4] arr;
    struct {
        int px, py;
        int vx, vy;
    };
};

const int costA = 3;
const int costB = 1;

Input parse(const ref string line) {
    return Input(matchAll(line, ctRegex!(`(-?\d+)`)).map!"a.hit.to!int".staticArray!4);
}

Input move(int w, int h, int seconds)(Input input) {
    input.px = (input.px+seconds*(input.vx+w))%w;
    input.py = (input.py+seconds*(input.vy+h))%h;
    return input;
}

void main() {
    GC.disable;

    long part1 = 0;
    long part2 = 0;

    const int w = 101;
    const int h = 103;

    int[4] q = 0;

    foreach (input; readLines!"input/14.in".map!(l => l.parse.move!(w, h, 100))) {
        if (input.px == w/2 || input.py == h/2) continue;
        q[(input.px < w/2)*2 + (input.py < h/2)] += 1;
    }

    writeln("part 1: ", q.fold!"a*b"(1));

    Input[] inputs = readLines!"input/14.in".map!parse.array;

    for (int k = 1;; ++k) {
        inputs.each!((ref a) => a = a.move!(w, h, 1));
        inputs.sort!((a, b) => a.px == b.px ? a.py < b.py : a.px < b.px);
        if (inputs.uniq!((a, b) => a.px == b.px && a.py == b.py).fold!((a, e) => a+1)(0) == inputs.length) {
            writeln("part 2: ", k);
            break;
        }
    }
    return;
}
