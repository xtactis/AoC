import sys
from functools import cache
from collections import defaultdict, deque
import math

sys.setrecursionlimit(5000)

raw = [l.strip() for l in sys.stdin.readlines()]
w = len(raw[0])-1
h = len(raw)-1
conv = {">": 1, "v": 2, "<": 4, "^": 8}
m = set((j, i, conv[c]) for i, row in enumerate(raw) for j, c in enumerate(row) if c not in "#.")

dxs, dys = [1, 0, -1, 0], [0, 1, 0, -1]

@cache
def mapgen(minute):
    if minute == 0:
        return frozenset(m)
    cm = mapgen(minute-1)
    nd = defaultdict(int)
    for x, y, c in cm:
        for v, dx, dy in zip([1,2,4,8],dxs,dys):
            if c & v == 0:
                continue
            nx, ny = x+dx, y+dy
            if nx >= w: nx = 1
            if nx < 1: nx = w-1
            if ny >= h: ny = 1
            if ny < 1: ny = h-1
            nd[(nx,ny)] += v

    return frozenset((x, y, v) for (x, y), v in nd.items())

q = deque()
s = set()
q.append((0, 1, 0, 0))
while q:
    minute, x, y, phase = q.popleft()
    m = mapgen(minute)
    if (minute+1, x, y, phase) not in s and all((x, y) != (a, b) for a, b, _ in m):
        q.append((minute+1, x, y, phase))
        s.add((minute+1, x, y, phase))
    for dx, dy in zip(dxs, dys):
        nx, ny = x+dx, y+dy
        newphase = phase
        if phase == 0 and nx == w-1 and ny == h: 
            print("part 1:", minute)
            q.clear()
            newphase = 1
        elif phase == 1 and nx == 1 and ny == 0:
            q.clear()
            newphase = 2
        elif phase == 2 and nx == w-1 and ny == h:
            print("part 2:", minute)
            exit(0)
        else:
            if nx < 1 or nx >= w: continue
            if ny < 1 or ny >= h: continue
        if any((nx, ny) == (a, b) for a, b, _ in m): continue
        if (minute+1, nx, ny, newphase) in s: continue
        s.add((minute+1, nx, ny, newphase))
        q.append((minute+1, nx, ny, newphase))
