with open(__file__[-5:-3]+".in", "r") as inp:
    lines = inp.read().split('\n')

def parserange(s):
    return [[int(e)+i for i, e in enumerate(x.split("=")[1].split('..'))] for x in s.split(",")]

lines = [l.split(" ") for l in lines]
lines = [(True if a == "on" else False, parserange(b)) for a, b in lines]

""" def makelist(*args, value=None):
    return [value if len(args) == 1 else makelist(*args[1:], value=value) for _ in range(args[0])]

mapa = makelist(105, 105, 105, value=False)

for nv, ranges in lines:
    if any(map(lambda r: r[0] < -50 or r[1] > 50, ranges)):
        continue
    x, y, z = ranges
    for i in range(x[0], x[1]):
        for j in range(y[0], y[1]):
            for k in range(z[0], z[1]):
                mapa[i+50][j+50][k+50] = nv

ans = 0
for td in mapa:
    for row in td:
        for e in row:
            ans += e

print(ans)
 """
from itertools import pairwise
xs, ys, zs = [sorted([e for _, r in lines for e in r[i]]) for i in range(3)]
pt2 = 0
for z, nz in pairwise(zs):
    for y, ny in pairwise(ys):
        line = {}
        for nv, [[xa, xb], [ya, yb], [za, zb]] in lines:
            if not (ya <= y < yb and za <= z < zb): continue
            for x in xs:
                if xa <= x < xb:
                    line[x] = nv
        pt2 += sum(nk-k for k, nk in pairwise(xs) if line.get(k, False))*(ny-y)*(nz-z)
print(pt2)
