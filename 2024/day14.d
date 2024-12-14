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
    
    Input[] inputs = readLines!"input/14.in".map!(l => l.parse.move!(w, h, 68)).array;
    // just draw until you find it lol
    for (int k = 68; true; k += 101) {
        inputs.each!((ref a) => a.move!(w, h, 101));
        for (int i = 0; i < h; ++i) {
            for (int j = 0; j < w; ++j) {
                write(inputs.any!(a => a.px == j && a.py == i) ? "x" : ".");
            }
            writeln();
        }
        writeln(k+101, "\n");
        Thread.sleep(dur!"msecs"(200));
    }

    writeln("part 2: ", part2);
}
