import sys

rocks = [[list(map(int, p.split(','))) for p in l.split('->')] for l in sys.stdin.readlines()]
lim = max(p[1] for l in rocks for p in l)+2
rocks.append([[0, lim], [700, lim]])

sand_source = [500, 0]

m = [[0]*(lim+1) for _ in range(800)]

for line in rocks:
    for p1, p2 in zip(line, line[1:]):
        if p1[0] == p2[0]:
            s =  (p2[1]-p1[1])//abs(p2[1]-p1[1])
            for i in range(p1[1], p2[1]+s, s):
                m[p1[0]][i] = 1
        else:
            s = (p2[0]-p1[0])//abs(p2[0]-p1[0])
            for i in range(p1[0], p2[0]+s, s):
                m[i][p1[1]] = 1

for r in m[494:505]:
    print(*r[:11], sep="")
part1 = 0
done = False
while not done:
    # propagate sand particle
    particle = sand_source.copy()
    while True:
#        if particle[1]+1 == lim:
#            done = True
#            break
        if m[particle[0]][particle[1]+1] == 0:
            particle[1] += 1
        elif m[particle[0]-1][particle[1]+1] == 0:
            particle[0] -= 1
            particle[1] += 1
        elif m[particle[0]+1][particle[1]+1] == 0:
            particle[0] += 1
            particle[1] += 1
        elif particle == sand_source:
            done = True
            break
        else:
            m[particle[0]][particle[1]] = 2
            break
    part1 += 1

for r in m[494:505]:
    print(*r[:11], sep="")

print(part1)

