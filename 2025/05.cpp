#include <bits/stdc++.h>

int main() {
    std::ifstream infile("input/05.in");
    std::string line;
    uint64_t p1 = 0, p2 = 0;
    std::vector<std::pair<int64_t, int64_t>> v;
    while (std::getline(infile, line)) {
        if (line == "") break;
        int64_t a, b;
        sscanf(line.c_str(), "%lu-%lu", &a, &b);
        v.emplace_back(a, b);
    }
    std::ranges::sort(v);
    decltype(v)::value_type p{-1, -1};
    decltype(v) w;
    for (const auto& [a, b]: v) {
        if (a > p.second) {
            if (p.first != -1) {
                w.emplace_back(p);
                p2 += p.second-p.first+1;
            }
            p = {a, b};
        } else if (a <= p.second) {
            p.second = std::max(b, p.second);
        }
    }
    w.emplace_back(p);
                p2 += p.second-p.first+1;
    while (std::getline(infile, line)) {
        int64_t x = std::stoull(line);
        for (const auto& [a, b]: w) {
            if (a <= x && x <= b) {
                p1 += 1;
                break;
            }
        }
    }
    printf("%lu %lu\n", p1, p2);
    return 0;
}
