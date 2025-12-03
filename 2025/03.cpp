#include <bits/stdc++.h>

long long pow10(int x) {
    long long res = 1;
    while (--x) res *= 10;
    return res;
}

long long memo2[123][15];
long long s2(std::string_view line, int start = 0, int remaining = 12) {
    long long& res = memo2[start][remaining];
    if (res != -1) return res;
    if (remaining == 0) return 0;
    char m = std::ranges::max(line.substr(start, line.size()-remaining-start+1));
    res = 0;
    for (int i = start; i <= line.size()-remaining; ++i) {
        if (line[i] != m) {
            continue;
        }
        res = std::max(res, (m-48)*pow10(remaining)+s2(line, i+1, remaining-1));
    }
    return res;
}

int main() {
    std::ifstream infile("input/03.in");
    std::string line;
    uint64_t p1 = 0, p2 = 0;
    std::vector<int> v;
    while (std::getline(infile, line)) {
        int m = 0;
        for (int i = 0; i < line.size(); ++i) {
            for (int j = i+1; j < line.size(); ++j) {
                m = std::max((line[i]-48)*10+line[j]-48, m);
            }
        }
        p1 += m;
        for (int i = 0; i < 123; ++i) for (int j = 0; j < 15; ++j) memo2[i][j] = -1;
        p2 += s2(line);
    }
    printf("%lu %lu\n", p1, p2);
    return 0;
}
