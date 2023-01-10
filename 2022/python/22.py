import sys
from functools import cache
from scipy.spatial.transform import Rotation
from collections import deque
import numpy as np

m, moves_ = sys.stdin.read().split("\n\n")
m = m.split("\n")
moves_ = moves_.strip()
n = min(len(l.strip()) for l in m)

maxlen = max(len(l) for l in m)
m = [l if len(l) == maxlen else (l+" "*(maxlen-len(l))) for l in m]

moves = []
cur = 0
for c in moves_:
    if c in "LR":
        moves.extend(["F"]*cur)
        moves.append(c)
        cur = 0
    else:
        cur *= 10
        cur += ord(c) - ord("0")
moves.extend(["F"]*cur)

dxs, dys = [1, 0, -1, 0], [0, 1, 0, -1]

def part1(x, y, direction):
    x += dxs[direction]
    y += dys[direction]
    x = x % len(m[0])
    y = y % len(m)

    if m[y][x] == "#": return False, x, y, direction
    if m[y][x] == ".": return True, x, y, direction
    return part1(x, y, direction)

def calc_dir(s1, s2, d):
    v = tuple([
        s1[1],
        [-e for e in s1[0]],
        [-e for e in s1[1]],
        s1[0]
    ][d])
    if v == s2[0]: return 3
    if v == s2[1]: return 0
    if v == tuple(-e for e in s2[0]): return 1
    return 2

@cache
def fold():
    u, v = next(i for i, c in enumerate(m[0]) if c != " "), 0
    rots = {}
    q = deque()
    been = set()
    been.add((u, v))
    q.append([(0, 1, 0), (1, 0, 0), (u, v)])
    while q:
        up, right, (u, v) = q.popleft()
        rots[(up, right)] = (u, v)
        for du, dv in zip([n, 0, -n, 0], [0, n, 0, -n]):
            nu, nv = u + du, v + dv
            if nu < 0 or nu >= maxlen or nv < 0 or nv >= len(m): continue
            if m[nv][nu] == " ": continue
            if (nu, nv) in been: continue
            if dv != 0:
                rotvec = [e * (90 if dv < 0 else -90) for e in right]
                rot = Rotation.from_rotvec(rotvec, degrees=True)
                nup = tuple(int(e) for e in rot.apply(up))
                q.append([nup, right, (nu, nv)])
            else:
                rotvec = [e * (90 if du < 0 else -90) for e in up]
                rot = Rotation.from_rotvec(rotvec, degrees=True)
                nright = tuple(int(e) for e in rot.apply(right))
                q.append([up, nright, (nu, nv)])
            been.add((nu, nv))
    opp = {v: k for k, v in rots.items()}
    norms = {tuple(np.cross(*k)): v for k, v in rots.items()}
    ret = {}
    for k, v in opp.items():
            # right
            rotvec = [e*-90 for e in v[0]]
            rot = Rotation.from_rotvec(rotvec, degrees=True)
            nright = tuple(int(e) for e in rot.apply(v[1]))
            au, av = norms[tuple(np.cross(v[0], nright))]
            angle = calc_dir([v[0], nright], opp[au, av], 0)
            ret[(k[0]//n, k[1]//n, 0)] = (au, av, angle)

            # down
            rotvec = [e*-90 for e in v[1]]
            rot = Rotation.from_rotvec(rotvec, degrees=True)
            nup = tuple(int(e) for e in rot.apply(v[0]))
            au, av = norms[tuple(np.cross(nup, v[1]))]
            angle = calc_dir([nup, v[1]], opp[au, av], 1)
            ret[(k[0]//n, k[1]//n, 1)] = (au, av, angle)

            # left
            rotvec = [e*90 for e in v[0]]
            rot = Rotation.from_rotvec(rotvec, degrees=True)
            nright = tuple(int(e) for e in rot.apply(v[1]))
            au, av = norms[tuple(np.cross(v[0], nright))]
            angle = calc_dir([v[0], nright], opp[au, av], 2)
            ret[(k[0]//n, k[1]//n, 2)] = (au, av, angle)
            
            # up
            rotvec = [e*90 for e in v[1]]
            rot = Rotation.from_rotvec(rotvec, degrees=True)
            nup = tuple(int(e) for e in rot.apply(v[0]))
            au, av = norms[tuple(np.cross(nup, v[1]))]
            angle = calc_dir([nup, v[1]], opp[au, av], 3)
            ret[(k[0]//n, k[1]//n, 3)] = (au, av, angle)
            
    return ret

def part2(x, y, direction):
    if x // n != (x+dxs[direction])//n or y // n != (y+dys[direction])//n:
        nx, ny, ndir = fold()[(x//n, y//n, direction)]
        offset = x%n if direction%2==1 else y%n
        oppset = n-offset-1
        if direction^ndir in [1,2]:
            offset, oppset = oppset, offset
        if ndir == 0:
            ny += offset
        elif ndir == 1:
            nx += offset
        elif ndir == 2:
            nx += n-1
            ny += offset
        else:
            nx += offset
            ny += n-1
        x, y, direction = nx, ny, ndir
    else:
        x += dxs[direction]
        y += dys[direction]
    return m[y][x] == ".", x, y, direction

def solve(find_next):
    x, y = next(i for i, c in enumerate(m[0]) if c == "."), 0
    direction = 0
    for move in moves:
        if move == "L":
            direction -= 1
        elif move == "R":
            direction += 1
        else:
            possible, nx, ny, ndir = find_next(x, y, direction)
            if possible:
                x, y, direction = nx, ny, ndir
        direction %= 4
    return 1000*(y+1)+4*(x+1)+direction

print(solve(part1))
print(solve(part2))
