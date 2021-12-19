from itertools import pairwise

with open(__file__[-5:-3]+".in", "r") as inp:
    lines = inp.read().split('\n')

cur = []
def flatten(l, level=0):
    if isinstance(l, list):
        return flatten(l[0], level+1) + flatten(l[1], level+1)
    return [(l, level)]

def unflatten(l):
    # ty ivceh 
    while len(l) > 1:
        nl = []
        found = False
        skip = 0
        for a, b in pairwise(l):
            if skip > 0:
                skip -= 1
                continue
            if not found and a[1] == b[1]:
                nl.append(([a[0], b[0]], a[1]-1))
                skip = 1
                found = True
            else:
                nl.append(a)
        if found:
            nl.append(l[-1])
        l = nl
    return l[0][0]

def explode(l):
    nl = []
    exploded = False
    skip = 0
    for i, e in enumerate(l):
        if skip > 0: 
            skip -= 1
            continue
        if e[1] != 5 or exploded:
            nl.append(e)
            continue
        if nl != []: nl[-1] = (nl[-1][0]+e[0], nl[-1][1]) 
        nl.append((0, 4))
        if len(l) > i+2: nl.append((l[i+2][0]+l[i+1][0], l[i+2][1]))
        skip = 2
        exploded = True
    return nl, exploded

def split(l):
    nl = []
    splitted = False
    for e in l:
        if e[0] > 9 and not splitted:
            nl.append((e[0]//2, e[1]+1))
            nl.append(((e[0]+1)//2, e[1]+1))
            splitted = True
        else:
            nl.append(e)
    return nl, splitted

def reduce(e):
    while True:
        e, cont = explode(e)
        if cont: continue
        e, cont = split(e)
        if cont: continue
        return e

def add(a, b):
    return [(f[0], f[1]+1) for f in a] + [(f[0], f[1]+1) for f in b]

def magnitude(l):
    return l if not isinstance(l, list) else 3*magnitude(l[0])+2*magnitude(l[1])

lines = list(map(eval, lines))

print(flatten(lines[0]))

lines = [flatten(e) for e in lines]
p1 = lines[0]

for e in lines[1:]:
    p1 = reduce(add(p1, e))

print(magnitude(unflatten(p1)))
print(max(magnitude(unflatten(reduce(add(e, f)))) for i, e in enumerate(lines) for j, f in enumerate(lines) if i != j))