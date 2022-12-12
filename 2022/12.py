import sys
from collections import deque

heights = sys.stdin.read().split()
H = len(heights)
W = len(heights[0])
start = []
for i, row in enumerate(heights):
    for j, c in enumerate(row):
        if c == 'S':
            start = [i, j, 0]
            heights[i] = heights[i].replace('S', 'a')
            break

def solve(start):
    Q = deque()
    Q.append(start)
    been = [[False]*len(heights[0]) for _ in heights]
    while Q:
        ci, cj, steps = Q.popleft()
        for dx, dy in [[0, 1], [0, -1], [1, 0], [-1, 0]]:
            Ci = ci+dy
            Cj = cj+dx
            if Cj >= W or Cj < 0 or Ci >= H or Ci < 0 or been[Ci][Cj]:
                continue
            if heights[Ci][Cj] == 'E':
                if heights[ci][cj] >= 'y':
                    return steps + 1
            elif ord(heights[ci][cj])+1 >= ord(heights[Ci][Cj]):
                been[Ci][Cj] = True
                Q.append([Ci, Cj, steps+1])
    return 99999999 

print(solve(start))
part2 = 9999999
for i, row in enumerate(heights):
    for j, c in enumerate(row):
        if c == 'a':
            part2 = min(part2, solve([i, j, 0]))

print(part2)
