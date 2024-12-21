import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math, std.getopt;
import std.regex;
import core.memory, core.thread.osthread, std.datetime;
import std.typecons;
import std.datetime.stopwatch: StopWatch, AutoStart, benchmark;

import helper;

long[string] memo;
long possible(string desired, const ref string[] available) {
    if (desired.length == 0) return 1;
    if (desired in memo) return memo[desired];
    long ret = 0;
    foreach (const ref ava; available) {
        if (ava.length > desired.length) continue;
        if (equal(ava, desired[0..ava.length])) {
            ret += possible(desired[ava.length..$], available);
        }
    }
    return memo[desired] = ret;
}

void main(string[] args) {
    GC.disable;

    bool doBenchmark = false;
    getopt(args, "bench", &doBenchmark);

    long part1 = 0;
    long part2 = 0;
    
    string[] chunks = import("input/19.in").split("\n\n");
    string[] available = chunks[0].strip('\n').split(", ");
    string[] desired = chunks[1].strip('\n').split("\n");

    void solve() {
        memo.clear;
        part1 = 0;
        part2 = 0;
        for (int i = 0; i < desired.length; ++i) {
            part1 += !!possible(desired[i], available);
            part2 += possible(desired[i], available);
        }
    }
    solve();
    writeln("part 1: ", part1); 
    writeln("part 2: ", part2);

    if (doBenchmark) {
        immutable int runs = 10;
        auto result = benchmark!(solve)(runs);
        writeln("\nexecuted in: ", result[0]/runs, " (avg of ", runs, " runs)");
    }
}
