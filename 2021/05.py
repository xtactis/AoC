with open("05.in", "r") as inp:
    lines = inp.readlines()

lines = [line.split(" -> ") for line in lines]
lines = [[list(map(int, coord.split(","))) for coord in line] for line in lines]

N = 1000
p1grid = [[0 for _ in range(N)] for _ in range(N)]
p2grid = [[0 for _ in range(N)] for _ in range(N)]

for line in lines:
    s = line[0]
    e = line[1]
    dx = e[0]-s[0]
    dy = e[1]-s[1]
    dx = 0 if dx == 0 else dx//abs(dx)
    dy = 0 if dy == 0 else dy//abs(dy)
    while s != e:
        if 0 in [dx, dy]:
            p1grid[s[0]][s[1]] += 1
        p2grid[s[0]][s[1]] += 1
        s[0] += dx
        s[1] += dy
    if 0 in [dx, dy]:
        p1grid[s[0]][s[1]] += 1
    p2grid[s[0]][s[1]] += 1

p1, p2 = 0, 0
for l1, l2 in zip(p1grid, p2grid):
    for e1, e2 in zip(l1, l2):
        if e1 > 1:
            p1 += 1
        if e2 > 1:
            p2 += 1

print(p1, p2, sep="\n")