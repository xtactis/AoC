#include <bits/stdc++.h>

long long solve(std::string_view line, int k) {
    long long res = 0;
    int pos = 0;
    do {
        int max_index = pos;
        for (int i = pos; i < line.size()-k+1; ++i) {
            if (line[i] > line[max_index]) {
                max_index = i;
            }
        }
        res = res*10 + (line[max_index]-48);
        pos = max_index+1;
    } while (--k);
    return res;
}

int main() {
    std::ifstream infile("input/03.in");
    std::string line;
    uint64_t p1 = 0, p2 = 0;
    std::vector<int> v;
    while (std::getline(infile, line)) {
        p1 += solve(line, 2);
        p2 += solve(line, 12);
    }
    printf("%lu %lu\n", p1, p2);
    return 0;
}
