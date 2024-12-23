import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math, std.getopt;
import std.regex;
import core.memory, core.thread.osthread, std.datetime;
import std.typecons;
import std.datetime.stopwatch: StopWatch, AutoStart, benchmark;

import helper;

bool[Tuple!(string, string)] seen;
bool[Tuple!(string, string, string)] trips;
void dfs(const ref string[][string] g, const ref string u, string p = "") {
    seen[tuple(p, u)] = true;
    foreach (v; g[u]) {
        if (p != "" && (u[0] == 't' || v[0] == 't' || p[0] == 't') && g[p].canFind(v)) {
            string[] n = [p, u, v];
            n.sort;
            trips[tuple(n[0], n[1], n[2])] = true;
        }
        if (tuple(u, v) !in seen) {
            dfs(g, v, u);
        }
    }
}

void main(string[] args) {
//    GC.disable;

    bool doBenchmark = false;
    getopt(args, "bench", &doBenchmark);

    long part1 = 0;
    long part2 = 0;

    string[][string] g;
    
    foreach (line; readLines!"input/23.in".map!(s => s.split("-"))) {
        g[line[0]] ~= line[1];
        g[line[1]] ~= line[0];
    }

    void solve() {
        part1 = 0;
        part2 = 0;
        trips.clear;

        foreach (u; g.byKey) {
            seen.clear;
            dfs(g, u);
        }
        part1 = trips.length;
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
