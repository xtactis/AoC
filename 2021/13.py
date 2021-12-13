with open("13.in", "r") as inp:
    lines = inp.read()

lines = lines.split("\n\n")
coords, folds = lines[0], lines[1]
coords = [tuple(map(int, c.split(','))) for c in coords.split()]
folds = [f.split('=') for f in folds.split("\n")]

for i, f in enumerate(folds):
    amt = int(f[1])
    if f[0][-1] == 'x':
        coords = set((x, y) if x <= amt else (2*amt-x, y) for x, y in coords)
    else:
        coords = set((x, y) if y <= amt else (x, 2*amt-y) for x, y in coords)
    if i == 0:
        print("part 1:", len(coords))

print("part 2:")
minx, maxx, miny, maxy = min(c[0] for c in coords), max(c[0] for c in coords), min(c[1] for c in coords), max(c[1] for c in coords)
for i in range(miny, maxy+1):
    for j in range(minx, maxx+1):
        if (j, i) in coords:
            print("#", end="")
        else:
            print(" ", end="")
    print("") 