import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math, std.getopt;
import std.regex;
import core.memory, core.thread.osthread, std.datetime;
import std.typecons;
import std.datetime.stopwatch: StopWatch, AutoStart, benchmark;

import helper;

void main(string[] args) {
//    GC.disable;

    bool doBenchmark = false;
    getopt(args, "bench", &doBenchmark);

    long part1 = 0;
    long part2 = 0;
    
    immutable long[] lines = readLines!"input/22.in".map!(to!long).array;

    void solve() {
        part1 = 0;
        part2 = 0;
        int[20][20][20][20] m;

        auto secrets = lines.dup;
        foreach (ref secret; secrets) {
            bool[20][20][20][20] seen;
            byte[2000] prev;
            for (int i = 0; i < 2000; ++i) {
                long older = secret;
                long old = secret;

                secret *= 64;
                secret ^= old; // mix
                secret %= 16777216; // prune
                old = secret;
                secret /= 32;
                secret ^= old; // mix
                secret %= 16777216; // prune
                old = secret;
                secret *= 2048;
                secret ^= old; // mix
                secret %= 16777216; // prune

                prev[i] = (secret % 10 - older % 10 + 9).to!byte;
                if (i >= 3) {
                    if (!seen[prev[i]][prev[i-1]][prev[i-2]][prev[i-3]]) {
                        seen[prev[i]][prev[i-1]][prev[i-2]][prev[i-3]] = true;
                        part2 = max(part2, m[prev[i]][prev[i-1]][prev[i-2]][prev[i-3]] += secret % 10);
                    }
                }
            }
        }
        part1 = secrets.sum;
    }
    solve();
    writeln("part 1: ", part1); 
    writeln("part 2: ", part2);

    if (doBenchmark) {
        immutable int runs = 100;
        auto result = benchmark!(solve)(runs);
        writeln("\nexecuted in: ", result[0]/runs, " (avg of ", runs, " runs)");
    }
}
