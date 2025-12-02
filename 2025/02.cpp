#include <bits/stdc++.h>

long long shift(long long i) {
    for (long long pow=10;; pow *= 10) {
        if (i < pow) return pow;
    }
}

int main() {
    std::ifstream infile("input/02.in");
    std::string line;
    long long p1 = 0, p2 = 0;
    std::set<long long> invalidIDs;
    std::set<long long> invalidIDsP2;
    for (long long i = 1; i < 1000000; ++i) {
        invalidIDs.emplace(i + shift(i)*i);
        long long acc = i;
        for (int k = 0; k < 6; ++k) {
            acc = shift(i)*acc + i;
            if (acc < 0) break;
            invalidIDsP2.emplace(acc);
        }
    }
    while (std::getline(infile, line, ',')) {
        long long a = std::atol(line.substr(0, line.find('-')).c_str());
        long long b = std::atol(line.substr(line.find('-')+1).c_str());
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
    std::cout << p1 << ' ' << p2 << '\n';
    return 0;
}
