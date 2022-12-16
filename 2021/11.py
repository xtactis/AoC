with open("11.in", "r") as inp:
    lines = inp.read().split()

oct = [list(map(int, l)) for l in lines]

dx = [-1, 0, 1, -1, 1, -1, 0, 1]
dy = [-1, -1, -1, 0, 0, 1, 1, 1]

height = len(oct)
width = len(oct[0])

from collections import deque

p1 = 0

for step in range(1000):
    oct_new = [[e+1 for e in row] for row in oct]
    flashed = [[False for _ in row] for row in oct]
    q = deque()
    for i, row in enumerate(oct_new):
        for j, e in enumerate(row):
            if e > 9:
                flashed[i][j] = True
                q.append((i, j))
    while len(q) != 0:
        i, j = q.popleft()
        oct_new[i][j] = 0
        p1 += 1
        for x, y in zip(dx, dy):
            if i+y < height and i+y >= 0 and j+x < width and j+x >= 0 and not flashed[i+y][j+x]:
                oct_new[i+y][j+x] += 1
                if oct_new[i+y][j+x] > 9:
                    flashed[i+y][j+x] = True
                    q.append((i+y, j+x))
    oct = oct_new
    if all(all(row) for row in flashed):
        print("part 2: ", step)
        break
                
print("part 1:", p1)