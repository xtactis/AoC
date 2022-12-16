with open(__file__[-5:-3]+".in", "r") as inp:
    lines = inp.read()

xs, ys = (list(map(int, e[2:].split(".."))) for e in lines.split(": ")[1].split(", "))

def sim(xv, yv):
    px, py = 0, 0
    maxy = 0
    for _ in range(300):
        px += xv
        py += yv
        if xv > 0: xv -= 1
        yv -= 1

        # these two lines of code bring execution time from ~5 seconds to ~90ms
        if xv == 0 and not (xs[0] <= px <= xs[1]): return None
        if px > xs[1] or py < ys[0]: return None

        maxy = max(maxy, py)
        if xs[0] <= px <= xs[1] and ys[0] <= py <= ys[1]: return maxy
    return None

p1 = 0
p2 = 0
for i in range(0, xs[1]+1):
    for j in range(-abs(ys[0]), abs(ys[0])):
        val = sim(i, j)
        if val is None: continue
        p2 += 1
        p1 = max(p1, val)

print(p1, p2)