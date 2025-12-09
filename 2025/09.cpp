#include <bits/stdc++.h>

using Coord = std::pair<int64_t, int64_t>;

std::vector<Coord> v;
std::set<int64_t> xs;
std::set<int64_t> ys;

bool checkOnLine(const Coord &x) {
    for (int i = 0; i < v.size(); ++i) {
        const Coord &c = v[i];
        if (x.first == c.first) {
            if (const Coord& d = v[(i+1)%v.size()]; x.first == d.first) {
                return std::min(c.second, d.second) <= x.second && x.second <= std::max(c.second, d.second);
            }
            if (const Coord& d = v[(i-1+v.size())%v.size()]; x.first == d.first) {
                return std::min(c.second, d.second) <= x.second && x.second <= std::max(c.second, d.second);
            }
        } else if (x.second == c.second) {
            if (const Coord& d = v[(i+1)%v.size()]; x.second == d.second) {
                return std::min(c.first, d.first) <= x.first && x.first <= std::max(c.first, d.first);
            }
            if (const Coord& d = v[(i-1+v.size())%v.size()]; x.second == d.second) {
                return std::min(c.first, d.first) <= x.first && x.first <= std::max(c.first, d.first);
            }
        }
    }
    return false;
}

bool checkLineInside(Coord a, Coord b) {
    if (a.first == b.first) { // xs match
        printf("xs match\n");
        if (a.second > b.second) std::swap(a, b);
        bool inside = false;
        for (int64_t y: ys) {
            printf("ch y %ld\n", y);
            if (y > a.second) {
                break;
            }
            if (checkOnLine({a.first, y})) {
                if (a.second == y) {
                    inside = true;
                    break;
                } else {
                    inside = !inside;
                }
            }
        }
        if (!inside) return false;
        int64_t prevY = -1;
        bool checkPrev = false;
        for (int64_t y: ys) {
            if (y <= a.second) {
                continue;
            }
            printf("ch y %ld\n", y);
            if (y > b.second) {
                checkPrev = false;
                break;
            }
            if (checkPrev) {
                if (y-prevY != 1 || !checkOnLine({a.first, y})) {
                    return false;
                }
                checkPrev = false;
            } else {
                if (y != b.second && checkOnLine({a.first, y})) {
                    checkPrev = true;
                    prevY = y;
                }
            }
        }
        return !checkPrev;
    } else { // ys match
        printf("ys match\n");
        if (a.first > b.first) std::swap(a, b);
        bool inside = false;
        for (int64_t x: xs) {
            printf("ch x %ld\n", x);
            if (x > a.first) {
                break;
            }
            if (checkOnLine({x, a.second})) {
                if (x == a.first) {
                    inside = true;
                    break;
                } else {
                    inside = !inside;
                }
            }
        }
        if (!inside) return false;
        puts("inside");
        int64_t prevX = -1;
        bool checkPrev = false;
        for (int64_t x: xs) {
            if (x <= a.first) {
                continue;
            }
            printf("ch x %ld\n", x);
            if (x > b.first) {
                checkPrev = false;
                break;
            }
            if (checkPrev) {
                if (x-prevX != 1 || !checkOnLine({x, a.second})) {
                    return false;
                }
                checkPrev = false;
            } else {
                if (x != a.first && checkOnLine({x, a.second})) {
                    checkPrev = true;
                    prevX = x;
                }
            }
        }
        return !checkPrev;
    }
}

bool checkRectangle(const Coord& a, const Coord& b) {
    for (int64_t y: ys) {
        if (y < std::min(a.second, b.second)) continue;
        printf("checking y %ld\n", y);
        if (!checkLineInside({a.first, y}, {b.first, y})) return false;
        if (y == std::max(a.second, b.second)) break;
    }
    for (int64_t x: xs) {
        if (x < std::min(a.first, b.first)) continue;
        printf("checking x %ld\n", x);
        if (!checkLineInside({x, a.second}, {x, b.second})) return false;
        if (x == std::max(a.first, b.first)) break;
    }
    return true;
}

int main() {
    std::ifstream infile("input/09.in");
    std::string line;
    uint64_t p1 = 0, p2 = 0;
    while (std::getline(infile, line)) {
        int64_t x, y;
        sscanf(line.c_str(), "%ld,%ld", &x, &y);
        v.emplace_back(x, y);
        xs.emplace(x);
        ys.emplace(y);
    }

    printf("%d", checkRectangle(v[4], v[6]));
    return 0;

    for (int i = 0; i < v.size()-1; ++i) {
        for (int j = i+1; j < v.size(); ++j) {
            uint64_t size {uint64_t(std::abs(v[i].first-v[j].first+1)*std::abs(v[i].second-v[j].second+1))};
            p1 = std::max(p1, size);
            if (checkRectangle(v[i], v[j])) {
                printf("%d %d %lu\n", i, j, size);
                p2 = std::max(p2, size);
            }
        }
    }

    printf("%lu %lu\n", p1, p2);

    return 0;
}
