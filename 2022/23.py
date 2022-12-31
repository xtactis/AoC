import sys
from collections import defaultdict

m = set((j, i) for i, row in enumerate(sys.stdin.readlines()) for j, c in enumerate(row) if c == '#')

dxs, dys = [-1, 0, 1, -1, 1, -1, 0, 1], [-1, -1, -1, 0, 0, 1, 1, 1]

#        north      south      west       east
check = [[0, 1, 2], [5, 6, 7], [0, 3, 5], [2, 4, 7], [0, 3, 5]]
move  = [1,         6,         3,         4]

direction = [0, 1, 2, 3]

def no_other_elves(x, y):
    return not any((x+dx, y+dy) in m for dx, dy in zip(dxs, dys))

for rnd in range(1000000):
    new = defaultdict(list)
    for e in m:
        if no_other_elves(*e):
            new[e].append(e)
            continue
        moved = False
        for d in direction:
            if all((e[0]+dxs[i], e[1]+dys[i]) not in m for i in check[d]):
                new[(e[0]+dxs[move[d]], e[1]+dys[move[d]])].append(e)
                moved = True
                break
        if not moved:
            new[e].append(e)
    m2 = set()
    anymoved = False
    for k, v in new.items():
        if len(v) == 1:
            m2.add(k)
            if k != v[0]:
                anymoved = True
        else:
            m2.update(v)
    if not anymoved:
        print(rnd+1)
        break;
    m = m2
    if rnd == 10:
        w = 1+max(x for x, _ in m)-min(x for x, _ in m)
        h = 1+max(y for _, y in m)-min(y for _, y in m)
        print(h*w-len(m))

    direction.append(direction[0])
    direction = direction[1:]

