import sys
from functools import cache

primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 541]

inp = [[n for i, n in enumerate(l.split(" ")) if i not in [0, 2, 3, 5, 6, 7, 8]] for l in sys.stdin.readlines()]
inp = list(map(lambda l: [l[0], int(l[1].split("=")[1][:-1])] + [e[:-1] for e in l[2:]], inp))
inp = {l[0]: (l[1], l[2:]) for l in inp}

pmap = {k: i for i, k in enumerate(inp.keys())}

terml = len(tuple(k for k, v in inp.items() if v[0] > 0))

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

print(inp)

@cache
def dfs(cur="AA", minleft=26, opened=""):
    if minleft <= 0:
        return 0
    ret = 0
    ret2 = 0
    minlo = minleft
    minl2 = minleft
    op2 = opened
    if inp[cur][0] > 0 and cur not in opened:
        opened += cur + "$"
        minleft -= 1
        ret = inp[cur][0]*minleft
    m = 0
    for n in inp[cur][1]:
        m = max(m, # hmmm
                ret+dfs(n, minleft-1, opened)+dfs(cur, minlo, opened), 
                dfs(n, minl2-1, op2)+dfs(cur, minlo, op2))
    return m

@cache
def doubletrouble(cur1="AA", cur2="AA", min1=26, min2=26, opened=tuple()):
    if min1 <= 0 and min2 <= 0:
        return 0
    if len(opened) == terml:
        return 0
    if len(opened) > terml:
        print("wtf", opened, terml)
        exit(-1)
    opened1 = opened
    opened2 = opened
    openedb = opened
    min1b = min1
    min2b = min2
    min1o = min1
    min2o = min2
    r1 = 0
    r2 = 0
    rb = 0
    if min1 > 0 and min2 > 0 and inp[cur1][0] > 0 and cur1 not in openedb and inp[cur2][0] > 0 and cur2 not in openedb and cur1 != cur2:
        openedb = tuple(sorted(openedb + (cur1, cur2)))
        min1b -= 1
        min2b -= 1
        rb = inp[cur1][0] * min1b + inp[cur2][0] * min2b
    if min1 > 0 and inp[cur1][0] > 0 and cur1 not in opened1:
        opened1 = tuple(sorted(opened1 + (cur1,)))
        min1 -= 1
        r1 = inp[cur1][0] * min1
    if min2 > 0 and inp[cur2][0] > 0 and cur2 not in opened2:
        opened2 = tuple(sorted(opened2 + (cur2,)))
        min2 -= 1
        r2 = inp[cur2][0] * min2

    m = 0
    for e in inp[cur1][1]:
        for f in inp[cur2][1]:
            m = max(m, 
                    rb+doubletrouble(e, f, min1b-1, min2b-1, openedb),
                    r1+doubletrouble(e, f, min1-1, min2o-1, opened1),
                    r2+doubletrouble(e, f, min1o-1, min2-1, opened2),
                       doubletrouble(e, f, min1o-1, min2o-1, opened ))
    return m

print(dfs())
#print(doubletrouble())
