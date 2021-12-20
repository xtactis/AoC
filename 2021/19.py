with open(__file__[-5:-3]+".in", "r") as inp:
    lines = inp.read().split('\n\n')

scanners = [e.split('\n')[1:] for e in lines]
scanners = [[eval(line) for line in e] for e in scanners]

rotations = [
    lambda x, y, z: (y, -x, z), # along z clockwise
    lambda x, y, z: (-z, y, x), # along y clockwise
    lambda x, y, z: (x, -z, y), # along x clockwise
]

def rotate(points, xt, yt, zt):
    np = []
    for p in points:
        for _ in range(xt):
            p = rotations[0](*p)
        for _ in range(yt):
            p = rotations[1](*p)
        for _ in range(zt):
            p = rotations[2](*p)
        np.append(p)
    return np

allrot = [(x, y, z) for x in range(4) for y in range(4) for z in range(4)]
t = set()
rot = []
for r in allrot:
    x = rotate([(1, 2, 3)], *r)[0]
    if x in t: continue
    rot.append(r)
    t.add(x)

def check(reference, new, dontcheck):
    for np in (rotate(new, *r) for r in rot):
        for rp in reference:
            if rp in dontcheck: continue
            for p in np[:-12]:
                nnp = set(tuple(ex-px+rpx for ex, px, rpx in zip(e, p, rp)) for e in np)
                int = reference.intersection(nnp)
                if len(int) >= 12:
                    return nnp, tuple(px-rpx for px, rpx in zip(p, rp))
    return None, None

map = set(scanners[0])
translations = [[0, 0, 0]]
dontchecks = [set() for _ in scanners]
done = [False for _ in scanners]
done[0] = True

cnt = 0
while not all(done):
    print(done)
    for i, s in enumerate(scanners):
        if done[i]: continue
        ret, translation = check(map, s, dontchecks[i])
        if ret is None:
            dontchecks[i] = map
            continue
        map = map | ret
        translations.append(translation)
        done[i] = True
    cnt += 1
    
m = 0
for t in translations:
    for u in translations:
        m = max(m, sum(abs(tx-ux) for tx, ux in zip(t, u)))

print("part 1:", len(map))
print("part 2:", m)