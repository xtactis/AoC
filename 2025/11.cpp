#include <bits/stdc++.h>

std::unordered_map<int, std::vector<int>> g;
constexpr uint8_t dac = 0x1;
constexpr uint8_t fft = 0x2;

constexpr auto strToInt(std::string_view s) {
    return std::ranges::fold_left(s, 0, [](int acc, char c) {
        return acc*26 + c-'a';
    });
};

uint64_t dp[20000][4];
uint64_t dfs2(int cur, uint8_t flags) {
    if (cur == strToInt("out")) return flags == (dac | fft);
    auto& ret = dp[cur][flags];
    if (ret != -1) return ret;
    return ret = std::ranges::fold_left(g[cur], 0, [flags](uint64_t acc, int cur) {
        return acc + dfs2(cur, flags | (cur == strToInt("fft") ? fft : cur == strToInt("dac") ? dac : 0));
    });
}

int main() {
    std::ifstream infile("input/11.in");
    std::string line;
    uint64_t p1 = 0, p2 = 0;
    while (std::getline(infile, line)) {
        auto& e = g[strToInt(line.substr(0, 3))] = {};
        for (auto v: std::views::split(std::string_view(line).substr(5), ' ')) {
            e.push_back(strToInt(std::string_view(v)));
        }
    }
    for (int i = 0; i < 20000; ++i) for (int j = 0; j < 4; ++j) dp[i][j] = -1;
    p1 = dfs2(strToInt("you"), dac | fft);
    p2 = dfs2(strToInt("svr"), 0);
    printf("%lu %lu\n", p1, p2);

    return 0;
}
