#include <bits/stdc++.h>

int main() {
    std::ifstream infile("input/04.in");
    std::string line;
    uint64_t p1 = 0, p2 = 0;
    std::vector<std::string> map;
    std::array<char*, 2048> arst;
    int arstind = 0;
    while (std::getline(infile, line)) {
        map.emplace_back(line);
    }
    do {
        arstind = 0;
        for (int row = 0; row < map.size(); ++row) {
            for (int col = 0; col < map[0].size(); ++col) {
                if (map[row][col] != '@') continue;
                int count = 0;
                for (int dy = -1; dy < 2; ++dy) {
                    if (row+dy < 0 || row+dy >= map.size()) continue;
                    for (int dx = -1; dx < 2; ++dx) {
                        if (col+dx < 0 || col+dx >= map[0].size()) continue;
                        count += map[row+dy][col+dx] != '.';
                    }
                }
                if (count < 5) {
                    arst[arstind++] = &map[row][col];
                    p2 += 1;
                }
            }
        }
        for (char* pos: arst | std::views::take(arstind)) {
            *pos = '.';
        }
        if (p1 == 0) p1 = p2;
    } while(arstind > 0);
    printf("%lu %lu\n", p1, p2);
    return 0;
}
