with open(__file__[-5:-3]+".in", "r") as inp:
    map = [list(l) for l in inp.read().split('\n')]

m, n = len(map), len(map[0])
map2 = [l.copy() for l in map]
steps = 0
moved = True
while moved:
    moved = False
    steps += 1
    for j, l in enumerate(map):
        for i, e in enumerate(l):
            if e != '>': continue
            if map[j][(i+1)%n] != '.': continue
            moved = True
            map2[j][i] = '.'
            map2[j][(i+1)%n] = '>'
    map = [l.copy() for l in map2]
    for j, l in enumerate(map):
        for i, e in enumerate(l):
            if e != 'v': continue
            if map[(j+1)%m][i] != '.': continue
            moved = True
            map2[j][i] = '.'
            map2[(j+1)%m][i] = 'v'
    map = [l.copy() for l in map2]

print("part 1:", steps)
    