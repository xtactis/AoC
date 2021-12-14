from collections import defaultdict
from functools import lru_cache
from itertools import pairwise

with open("14.in", "r") as inp:
    lines = inp.read()

lines = lines.split("\n\n")
template, lines = lines[0], [l.split(" -> ") for l in lines[1].split("\n")]
p = {(l[0][0], l[0][1]): l[1] for l in lines}
keys = set([l[1] for l in lines] + list(template))

@lru_cache(maxsize=None)
def rec(a, b, steps, letter):
    e = p[(a, b)]
    r = 1 if e == letter else 0
    if steps == 1:
        return r
    return r + rec(a, e, steps-1, letter) + rec(e, b, steps-1, letter)

for steps in (10, 40):
    res = defaultdict(int)
    for c in template:
        res[c] += 1
    for k in keys:
        for a, b in pairwise(template):
            res[k] += rec(a, b, steps, k)
    print(res[max(res, key=res.get)]-res[min(res, key=res.get)])