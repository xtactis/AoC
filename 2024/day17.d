import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math;
import std.regex;
import core.memory, core.thread.osthread, std.datetime;
import std.typecons;

auto readLines(string file)() {
    return import(file).strip('\n').split("\n");
}

long[] parse(const ref string lines) {
    return matchAll(lines, ctRegex!(`(-?\d+)`)).map!"a.hit.to!long".array;
}

long[] execute(long A, long B, long C, const ref long[] instructions) {
    long[] res;
    for (long i = 0; i < instructions.length;) {
        long ins = instructions[i];
        long arg = instructions[i+1];
            
        long parseArg(long arg) {
            if (arg < 4) return arg;
            if (arg == 4) return A;
            else if (arg == 5) return B;
            else if (arg == 6) return C;
            else assert(false);
        }

        if (ins == 0) {
            A >>= parseArg(arg);
        } else if (ins == 1) {
            B ^= arg;
        } else if (ins == 2) {
            B = parseArg(arg) & 7;
        } else if (ins == 3) {
            if (A != 0) {
                i = arg;
                continue;
            }
        } else if (ins == 4) {
            B ^= C;
        } else if (ins == 5) {
            res ~= parseArg(arg) & 7;
        } else if (ins == 6) {
            B = A >> parseArg(arg);
        } else if (ins == 7) {
            C = A >> parseArg(arg);
        } else assert(false);
        
        i += 2;
    }
    return res;
}

long dfs(long A, const ref long[] instructions, int i = 0) {
    if (i == instructions.length) {
        return A;
    }
    A *= 8;
    long ret = long.max;
    for (int k = 0; k < 8; ++k) {
        if (equal(instructions[$-i-1..$], execute(A+k, 0, 0, instructions))) {
            ret = min(dfs(A+k, instructions, i+1), ret);
        }
    }
    return ret;
}

void main() {
    GC.disable;

    long[] part1;
    long part2 = 0;

    string[] chunks = import("input/17.in").split("\n\n");
    long[] regs = parse(chunks[0]);
    long[] instructions = parse(chunks[1]);

    part1 = execute(regs[0], regs[1], regs[2], instructions);
    part2 = dfs(0, instructions);
    
    writeln("part 1: ", part1.map!(to!string).join(",")); 
    writeln("part 2: ", part2);
}
