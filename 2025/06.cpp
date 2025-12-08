#include <bits/stdc++.h>

int main() {
    std::ifstream infile("input/06.in");
    std::string line;
    uint64_t p1 = 0, p2 = 0;
    std::vector<std::vector<uint64_t>> m;
    std::vector<char> ops;
    std::vector<std::string> vs;
    while (std::getline(infile, line)) {
        vs.emplace_back(line);
    }
    for (const auto& line: vs) {
        m.emplace_back();
        for (const auto n: line | std::views::split(std::string(" "))) {
            if (n.size() == 0) continue;
            std::string_view ns {n};
            if (ns == "*" || ns == "+") {
                ops.emplace_back(ns[0]);
            } else {
                m.back().emplace_back(0);
                std::ignore = std::from_chars(ns.begin(), ns.end(), m.back().back());
            }
        }
    }
    m.pop_back();
    for (int i = 0; i < ops.size(); ++i) {
        uint64_t acc = m[0][i];
        for (int j = 1; j < m.size(); ++j) {
            if (ops[i] == '*') {
                acc *= m[j][i];
            } else {
                acc += m[j][i];
            }
        }
        p1 += acc;
    }

    uint64_t prod = 1, acc = 0;
    for (int j = vs[0].size()-1; j >= 0; --j) {
        uint64_t x = 0;
        bool allSpace = true;
        for (int i = 0; i < vs.size()-1; ++i) {
            if (vs[i][j] == ' ') continue;
            x *= 10;
            x += vs[i][j]-48;
            allSpace = false;
        }
        if (allSpace) continue;
        char op = vs.back()[j];
        prod *= x;
        acc += x;
        if (op != ' ') {
            if (op == '*') {
                p2 += prod;
            } else {
                p2 += acc;
            }
            prod = 1;
            acc = 0;
        }
    }

    printf("%lu %lu\n", p1, p2);

    return 0;
}
