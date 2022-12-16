import sys
import math
from functools import cache

# see no evil
primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 541]

# hear no evil
inp = [[n for i, n in enumerate(l.split(" ")) if i not in [0, 2, 3, 5, 6, 7, 8]] for l in sys.stdin.readlines()]
inp = map(lambda l: [l[0], int(l[1].split("=")[1][:-1])] + [e[:-1] for e in l[2:]], inp)
inp = {l[0]: (l[1], l[2:]) for l in inp}

# speak no evil
pmap = {k: p for p, k in zip(primes, inp.keys())}

# floyd warshall
INF = 9999
d = {k: {j: 1 if j in inp[k][1] else INF for j in inp.keys()} for k in inp.keys()}
for k in inp.keys():
    d[k][k] = 0
    for i in inp.keys():
        for j in inp.keys():
            if d[i][k] < INF and d[k][j] < INF:
                d[i][j] = min(d[i][j], d[i][k] + d[k][j])

# remove nodes that have flow=0
for k in list(d.keys()):
    del d[k][k]
    if k == "AA": continue
    if inp[k][0] == 0:
        del d[k]
        for j in d.keys():
            del d[j][k]
    else:
        for j in d[k].keys():
            d[k][j] += 1

# the secret sauce
@cache
def solve(part, cur, minleft, opened):
    m = 0 if part == 1 else solve(1, "AA", 26, opened)
    if minleft <= 0:
        return m
    if opened % pmap[cur] != 0:
        val = inp[cur][0]*(minleft-1)
        if cur != "AA": 
            opened *= pmap[cur]
        for e, ec in d[cur].items():
            m = max(m, val+solve(part, e, minleft-ec, opened))
    return m

print(solve(1, "AA", 30, 1))
print(solve(2, "AA", 26, 1))
