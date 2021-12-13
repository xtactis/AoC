with open("09.in", "r") as inp:
    lines = inp.read().split()

nines = [9 for _ in range(len(lines[0])+2)]

lines = [[int(e) for e in line] for line in lines]
lines = [nines] + lines + [nines]

p1 = 0

dx = [-1, 0, 1, 0]
dy = [0, 1, 0, -1]

start = []

for i, line in enumerate(lines[1:-1], start=1):
    lines[i]  = [9] + line + [9]
for i, line in enumerate(lines[1:-1], start=1):
    for j, e in enumerate(line[1:-1], start=1):
        if all(e < lines[x+i][y+j] for x, y in zip(dx, dy)):
           p1 += 1+e
           start.append((i, j))
            
print(p1)

p2 = 1

from collections import deque
q = deque()

q.append((0, 0, True))
for s in start:
    q.append((s[0], s[1], True))

bio = [[False for e in line] for line in lines]
bio[0][0] = True
cs = []
counter = 0
while len(q) != 0:
    i, j, ksks = q.pop()
    if bio[i][j]:
        continue
    bio[i][j] = True
    if ksks:
        cs.append(counter)
        counter = 0
    counter += 1
    for x, y in zip(dx, dy):
        if bio[i+x][j+y]:
            continue
        if lines[x+i][y+j] == 9:
            continue
        elif lines[x+i][y+j] > lines[i][j]:
            q.append((i+x, j+y, False)) 
cs.sort(reverse=True)
print(cs[0]*cs[1]*cs[2])