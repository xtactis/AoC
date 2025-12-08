#include <bits/stdc++.h>

struct Dist {double dist; size_t i, j;};
struct Coord {int32_t x, y, z;};

double distance(const Coord& a, const Coord& b) {
    auto sqr = [](double x){return x*x;};
    return sqrt(sqr(a.x-b.x)+sqr(a.y-b.y)+sqr(a.z-b.z));
}


size_t parent[1234];
size_t size[1234];
void make_set(int v) {
    parent[v] = v;
    size[v] = 1;
}

int find_set(int v) {
    if (v == parent[v])
        return v;
    return parent[v] = find_set(parent[v]);
}

void union_sets(int a, int b) {
    a = find_set(a);
    b = find_set(b);
    if (a != b) {
        if (size[a] < size[b])
            std::swap(a, b);
        parent[b] = a;
        size[a] += size[b];
    }
}

int main() {
    std::ifstream infile("input/08.in");
    std::string line;
    uint64_t p1 = 0, p2 = 0;
    std::vector<Coord> v;
    int32_t color = 0;
    while (std::getline(infile, line)) {
        int32_t x, y, z;
        sscanf(line.c_str(), "%d,%d,%d", &x, &y, &z);
        v.emplace_back(x, y, z);
        make_set(color++);
    }

    std::vector<Dist> dists;
    dists.reserve(v.size()*(v.size()+1)/2);
    for (int i = 0; i < v.size()-1; ++i) {
        for (int j = i+1; j < v.size(); ++j) {
            dists.emplace_back(distance(v[i], v[j]), i, j);
        }
    }

    std::ranges::sort(dists, [](const Dist& a, const Dist& b) {
        return a.dist < b.dist;
    });

    for (const Dist& d: dists | std::views::take(1000)) {
        union_sets(d.i, d.j);
    }

    std::vector<size_t> sorted_sizes;
    sorted_sizes.resize(3);
    std::ranges::partial_sort_copy(size, sorted_sizes, std::greater{});
    p1 = sorted_sizes[0]*sorted_sizes[1]*sorted_sizes[2];

    for (const Dist& d: dists | std::views::drop(1000)) {
        union_sets(d.i, d.j);
        if (size[find_set(d.i)] == v.size()) {
            p2 = v[d.i].x*v[d.j].x;
            break;
        }
    }

    printf("%lu %lu\n", p1, p2);

    return 0;
}
