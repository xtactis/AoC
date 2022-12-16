import sys
import math
from functools import cache

primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 541]

inp = [[n for i, n in enumerate(l.split(" ")) if i not in [0, 2, 3, 5, 6, 7, 8]] for l in sys.stdin.readlines()]
inp = map(lambda l: [l[0], int(l[1].split("=")[1][:-1])] + [e[:-1] for e in l[2:]], inp)
inp = {l[0]: (l[1], l[2:]) for l in inp}

pmap = {k: primes[i] for i, k in enumerate(inp.keys())}

terml = math.prod(pmap[k] for k, v in inp.items() if v[0] > 0)

#INF = 9999
#d = {k: {j: 1 if j in inp[k][1] else INF for j in inp.keys()} for k in inp.keys()}
#for k in inp.keys():
#    d[k][k] = 0
#    for i in inp.keys():
#        for j in inp.keys():
#            if d[i][k] < INF and d[k][j] < INF:
#                d[i][j] = min(d[i][j], d[i][k] + d[k][j])
#print(d)

def condense(n):
    def dfs(c, bio=set()):
        if c != n and inp[c][0] > 0:
            return [[c, 0]]
        ret = []
        for e in inp[c][1]:
            if e in bio:
                continue
            l = dfs(e, bio|set({e}))
            ret.extend([[a, b+1] for a, b in l])
        return ret
    r = dfs(n)
    ns = set(a for a, b in r)
    ret = []
    for e in ns:
        sm = 99999
        for f in r:
            if f[0] != e:
                continue
            sm = min(sm, f[1])
        ret.append([e, sm])
    return ret

ninp = {"AA": [inp["AA"][0], condense("AA")]}
for k in inp.keys():
    if inp[k][0] > 0:
        ninp[k] = [inp[k][0], condense(k)]

@cache
def solve(part, cur, minleft, opened):
    if minleft <= 0:
        return 0
    if opened == terml:
        return 0
    valve = opened % pmap[cur] != 0
    opened2 = opened * pmap[cur]
    m = 0 if part == 1 else solve(1, "AA", 26, opened)
    for e, ec in ninp[cur][1]:
        m = max(m, solve(part, e, minleft-ec, opened))
        if valve:
            m = max(m, inp[cur][0]*(minleft-1)+solve(part, e, minleft-ec-1, opened2))
    return m

print(solve(1, "AA", 30, 1))
print(solve(2, "AA", 26, 1))
