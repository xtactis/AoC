import std.stdio, std.string, std.conv, std.regex, std.format, std.algorithm: canFind;

void main(string[] args) {
    string[] mandatory = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"];
    const auto checkers = [
        function bool(const ref string s) {const int x = to!int(s); return x > 1919 && x < 2003;},
        function bool(const ref string s) {const int x = to!int(s); return x > 2009 && x < 2021;},
        function bool(const ref string s) {const int x = to!int(s); return x > 2019 && x < 2031;},
        function bool(ref string s) {
            int h; string x;
            s.formattedRead!"%d%s"(h, x);
            if (x == "cm") return h < 194 && h > 149;
            if (x == "in") return h < 77 && h > 58;
            return false;
        },
        function bool(const ref string s) {
            return !matchAll(s, regex("^#[0-9a-z][0-9a-z][0-9a-z][0-9a-z][0-9a-z][0-9a-z]$")).empty;
        },
        function bool(const ref string s) {
            return ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].canFind(s);
        },
        function bool(const ref string s) {
            return !matchAll(s, regex("^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$")).empty;
        }
    ];
    string[string] mapa;
    int part1 = 0, part2 = 0;
    foreach (line; stdin.byLine) {
        if (line.length == 0) {
            bool f = true;
            for (int i = 0; i < mandatory.length; ++i) {
                if ((mandatory[i] in mapa) is null) {
                    f = false;
                    break;
                }
            }
            if (f) {
                ++part1;
                f = true;
                for (int i = 0; i < mandatory.length; ++i) {
                    if (!checkers[i](mapa[mandatory[i]])) {
                        f = false;
                        break;
                    }
                }
                if (f) ++part2;
            }
            mapa.clear();
        }
        foreach (word; line.split(" ")) {
            auto kv = word.split(":");
            mapa[to!string(kv[0])] = to!string(kv[1]);
        }
    }
    bool f = true;
    for (int i = 0; i < mandatory.length; ++i) {
        if ((mandatory[i] in mapa) is null) {
            f = false;
            break;
        }
    }
    if (f) {
        ++part1;
        f = true;
        for (int i = 0; i < mandatory.length; ++i) {
            if (!checkers[i](mapa[mandatory[i]])) {
                f = false;
                break;
            }
        }
        if (f) ++part2;
    }
    writef("%d %d\n", part1, part2);
}