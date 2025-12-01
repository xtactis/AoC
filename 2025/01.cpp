#include <bits/stdc++.h>

int main() {
    std::ifstream infile("input/01.in");
    std::string line;
    int pos = 50, p1 = 0, p2 = 0;
    while (std::getline(infile, line)) {
        int move = std::atoi(line.data() + 1);
        if (line[0] == 'L') {
            if (pos > 0 && move >= pos) p2 += 1;
            pos -= move;
            p2 += -pos / 100;
        } else if (line[0] == 'R') {
            pos += move;
            p2 += pos / 100;
        }
        pos %= 100;
        while (pos < 0) pos += 100;
        if (pos == 0) {
            p1 += 1;
        }
    }
    std::cout << p1 << ' ' << p2 << '\n';
    return 0;
}
