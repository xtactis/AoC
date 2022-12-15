import sys

inp = [[int(e.split("=")[1][:-1]) for i, e in enumerate(l.split(" ")) if i in [2, 3, 8, 9]] for l in sys.stdin.readlines()]
inp = [[x1, y1, abs(y2-y1)+abs(x2-x1)] for x1, y1, x2, y2 in inp]

def solve(y):
    ranges = []
    for x1, y1, dist in inp:
        w = dist-abs(y1-y)
        if w < 0:
            continue
        ranges.append([x1-w, x1+w])
    ranges.sort()
    left, right = ranges[0]
    for r in ranges[1:]:
        if right >= r[0]:
            right = max(r[1], right)
        else:
            return (right+1)*4000000+y, True
    return right-left, False

print(solve(2000000)[0])
for y in range(4000000, -1, -1):
    ans, part2 = solve(y)
    if part2:
        print(ans)
        break
