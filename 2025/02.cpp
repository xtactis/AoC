#include <bits/stdc++.h>

uint64_t shift(long long i) {
    for (uint64_t pow=10;; pow *= 10) {
        if (i < pow) return pow;
    }
}

int main() {
    std::ifstream infile("input/02.in");
    std::string line;
    uint64_t p1 = 0, p2 = 0;
    std::set<uint64_t> invalidIDs;
    std::set<uint64_t> invalidIDsP2;
    for (uint64_t i = 1; i < 1000000; ++i) {
        invalidIDs.emplace(i + shift(i)*i);
        uint64_t acc = i;
        for (int k = 0; k < 6; ++k) {
            acc = shift(i)*acc + i;
            if (acc < 0) break;
            invalidIDsP2.emplace(acc);
        }
    }
    while (std::getline(infile, line, ',')) {
        uint64_t a, b;
        sscanf(line.c_str(), "%lu-%lu", &a, &b);
        {
            for (auto start = invalidIDs.lower_bound(a), end = invalidIDs.upper_bound(b);
                    start != end; start++) {
                p1 += *start;
            }
        }
        {
            for (auto start = invalidIDsP2.lower_bound(a), end = invalidIDsP2.upper_bound(b);
                    start != end; start++) {
                p2 += *start;
            }
        }
    }
    printf("%lu %lu\n", p1, p2);
    return 0;
}
