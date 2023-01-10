import sys

sys.setrecursionlimit(30000)
inp = sys.stdin.read().strip()
lines = [list(map(lambda x: int(x)+1, l.split(","))) for l in inp.split("\n")]

N = 30
m = [[[0 for _ in range(N)] for _ in range(N)] for _ in range(N)]

for x,y,z in lines:
    m[z][y][x] = 1

dxs = [0, 0, -1, 1, 0, 0]
dys = [-1, 1, 0, 0, 0, 0]
dzs = [0, 0, 0, 0, -1, 1]

been = [[[False]*N for _ in range(N)] for _ in range(N)]
def count(x,y,z,c):
    global been
    ret = 0
    been[z][y][x] = True
    for dx,dy,dz in zip(dxs,dys,dzs):
        if x+dx < 0 or x+dx >= N: continue
        if y+dy < 0 or y+dy >= N: continue
        if z+dz < 0 or z+dz >= N: continue
        if m[z+dz][y+dy][x+dx] != c:
            ret += 1
            continue
        if been[z+dz][y+dy][x+dx]: continue
        ret += count(x+dx,y+dy,z+dz,c)
    return ret

part1 = 0
for z in range(N):
    for y in range(N):
        for x in range(N):
            if m[z][y][x] == 0: continue
            if been[z][y][x]: continue
            part1 += count(x,y,z,1)

print(part1)

def color_air(x,y,z):
    global m
    m[z][y][x] = 2
    for dx,dy,dz in zip(dxs,dys,dzs):
        if x+dx < 0 or x+dx >= N: continue
        if y+dy < 0 or y+dy >= N: continue
        if z+dz < 0 or z+dz >= N: continue
        if m[z+dz][y+dy][x+dx] != 0: continue
        color_air(x+dx,y+dy,z+dz)

color_air(N-1,N-1,N-1)
#been = [[[False]*N for _ in range(N)] for _ in range(N)]
print(count(N-1,N-1,N-1, 2))
