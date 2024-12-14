import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;
import std.regex;
import core.memory, core.thread.osthread, std.datetime;
import std.typecons;

auto readLines(string file)() {
    return import(file).split("\n").filter!(l => l.length != 0);
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

void main() {
    GC.disable;

    long part1 = 0;
    long part2 = 0;

    const int w = 101;
    const int h = 103;

    int[4] q = 0;

    foreach (input; readLines!"input/14.in".map!parse) {
        input.px = (input.px+input.vx*100+100*w)%w;
        input.py = (input.py+input.vy*100+100*h)%h;
        if (input.px == w/2 || input.py == h/2) continue;

        q[(input.px < w/2)*2 + (input.py < h/2)] += 1;
    }

    writeln("part 1: ", q.fold!"a*b"(1));
    
    Input[] inputs = readLines!"input/14.in".map!parse.array;
    foreach (ref input; inputs) {
        input.px = (input.px+68*(input.vx+w))%w;
        input.py = (input.py+68*(input.vy+h))%h;
    }
    // just draw until you find it lol
    for (int k = 68; true; k += 101) {
        foreach (ref input; inputs) {
            input.px = (input.px+101*(input.vx+w))%w;
            input.py = (input.py+101*(input.vy+h))%h;
        }
        for (int i = 0; i < h; ++i) {
            for (int j = 0; j < w; ++j) {
                foreach (const ref input; inputs) {
                    if (input.px == j && input.py == i) {
                        write("x");
                        goto miran;
                    }
                }
                write(".");
miran:
            }
            writeln();
        }
        writeln(k+101, "\n");
        Thread.sleep(dur!"msecs"(200));
    }

    writeln("part 2: ", part2);
}
