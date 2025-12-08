#include <bits/stdc++.h>

std::vector<std::string> vs;
bool seen[1234][1234] = {};
int dfs(int y, int x) {
    if (y >= vs.size() || x >= vs[0].size() || x < 0) return 0;
    if (seen[y][x]) return 0;
    seen[y][x] = 1;
    if (vs[y][x] == '^') {
        return 1+dfs(y, x-1)+dfs(y, x+1);
    } else {
        return dfs(y+1, x);
    }
}

long long dp[1234][1234] = {};
long long dfs2(int y, int x) {
    if (y >= vs.size() || x >= vs[0].size() || x < 0) return 1;
    if (dp[y][x]) return dp[y][x];
    if (vs[y][x] == '^') {
        return dp[y][x] = dfs2(y, x-1)+dfs2(y, x+1);
    } else {
        return dp[y][x] = dfs2(y+1, x);
    }
}

int main() {
    std::ifstream infile("input/07.in");
    std::string line;
    uint64_t p1 = 0, p2 = 0;
    while (std::getline(infile, line)) {
        vs.emplace_back(line);
    }

    auto S = vs[0].find_first_of('S');

    p1 = dfs(0, S);
    p2 = dfs2(0, S);

    printf("%lu %lu\n", p1, p2);

    return 0;
}
