import std.file, std.stdio, std.array, std.algorithm, std.conv, std.range, std.math, std.getopt;
import std.regex;
import core.memory, core.thread.osthread, std.datetime;
import std.typecons;
import std.datetime.stopwatch: StopWatch, AutoStart, benchmark;

import helper;

bool[Tuple!(ushort, ushort)] seen;
bool[Tuple!(ushort, ushort, ushort)] trips;
void dfs(const ref ushort[][256*256] g, ushort u, ushort p = 0) {
    seen[tuple(p, u)] = true;
    foreach (v; g[u]) {
        if (p != 0 && (u / 256 == 't' || v / 256 == 't' || p / 256 == 't') && g[p].canFind(v)) {
            ushort[] n = [p, u, v];
            n.sort;
            trips[tuple(n[0], n[1], n[2])] = true;
        }
        if (tuple(u, v.to!ushort) !in seen) {
            dfs(g, v, u);
        }
    }
}

bool[ushort] seen2;
ushort[] ans;
void dfs2(const ref ushort[][256*256] g, ushort u, ushort[] group = []) {
    seen2[u] = true;
    if (group.length+1 > ans.length) {
        ans = group~u;
    }
    foreach (v; g[u]) {
        if (v in seen2) continue;
        if (group.canFind(v)) continue;
        if (!group.map!(w => g[w].canFind(v)).all) continue;
        dfs2(g, v, group~u);
    }
}

void main(string[] args) {
//    GC.disable;

    bool doBenchmark = false;
    getopt(args, "bench", &doBenchmark);

    long part1 = 0;
    string part2 = "";

    ushort[][256*256] g;
    
    foreach (line; readLines!"input/23.in".map!(s => s.split("-"))) {
        ushort u = (line[0][0].to!int*256+line[0][1]).to!ushort;
        ushort v = (line[1][0].to!int*256+line[1][1]).to!ushort;
        g[u] ~= v;
        g[v] ~= u;
    }

    void solve() {
        part1 = 0;
        part2 = "";
        trips.clear;
        ans = [];
        seen.clear;

        foreach (i; 'a'..'z') {
            foreach (j; 'a'..'z') {
                ushort u = (i.to!int*256+j).to!ushort;
                if (g[u].length == 0) continue;
                seen2.clear;
                dfs(g, u);
                dfs2(g, u);
            }
        }
        part1 = trips.length;
        part2 = ans.sort.map!(e => [(e / 256).to!char, (e % 256).to!char]).join(",");
    }
    solve();
    writeln("part 1: ", part1); 
    writeln("part 2: ", part2);

    if (doBenchmark) {
        immutable int runs = 1000;
        auto result = benchmark!(solve)(runs);
        writeln("\nexecuted in: ", result[0]/runs, " (avg of ", runs, " runs)");
    }
}

