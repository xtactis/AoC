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
            std::string ns {std::string_view(n)};
            if (ns.size() == 0) continue;
            if (ns == "*" || ns == "+") {
                ops.emplace_back(ns[0]);
            } else {
                m.back().emplace_back(std::stoull(ns));
            }
        }
    }
    m.pop_back();
    std::vector<uint64_t> accs = m[0];
    for (int i = 0; i < ops.size(); ++i) {
        for (int j = 1; j < m.size(); ++j) {
            if (ops[i] == '*') {
                accs[i] *= m[j][i];
            } else {
                accs[i] += m[j][i];
            }
        }
    }
    for (uint64_t x: accs) p1 += x;

    std::vector<uint64_t> ta;
    char op = ' ';
    for (int j = vs[0].size()-1; j >= 0; --j) {
        std::string s;
        for (int i = 0; i < vs.size(); ++i) {
            s += vs[i][j];
        }
        std::cout << std::quoted(s) << '\n';
        if (std::ranges::all_of(s, [](char c) {return c == ' ';})) continue;
        char op = s.back();
        s.pop_back();
        ta.emplace_back(std::stoull(s));
        if (op != ' ') {
            if (op == '*') {
                p2 += std::ranges::fold_left(ta, 1, std::multiplies<uint64_t>());
                std::cout << std::ranges::fold_left(ta, 1, std::multiplies<uint64_t>()) << '\n';
            } else {
                p2 += std::ranges::fold_left(ta, 0, std::plus<uint64_t>());
                std::cout << std::ranges::fold_left(ta, 0, std::plus<uint64_t>()) << '\n';
            }
            ta.clear();
        }
    }

    printf("%lu %lu\n", p1, p2);

    return 0;
}
