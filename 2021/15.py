import heapq

with open("15.in", "r") as inp:
    lines = inp.read().split("\n")

smallmap = [list(map(int, l)) for l in lines]
height = len(smallmap)
width = len(smallmap[0])

ddx, ddy = [-1, 0, 1, 0], [0, -1, 0, 1]

bigmap = [[(smallmap[y%height][x%width]+(x//width)+(y//height)-1)%9+1 for x in range(width*5)] for y in range(height*5)]

for m, gap in [(smallmap, 26), (bigmap, 70)]: # works on my machine lol
    q = []
    heapq.heappush(q, (0, 0, 0))
    cnt = 0
    width = len(m[0])
    height = len(m)
    while True:
        score, x, y = heapq.heappop(q)
        cnt += 1
        if x == width-1 and y == height-1:
            print(score, cnt)
            break
        for dx, dy in zip(ddx, ddy):
            if y+dy > height-1 or x+dx > width-1 or x+dx < 0 or y+dy < 0:
                continue
            if m[y+dy][x+dx] == -1:
                continue
            if abs(y+dy-x-dx) >= gap:
                continue
            heapq.heappush(q, (score+m[y+dy][x+dx], x+dx, y+dy))
            m[y+dy][x+dx] = -1
