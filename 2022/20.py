import sys
import copy

inp = list(map(int, sys.stdin.readlines()))
inp = [(i, e) for i, e in enumerate(inp)]

key = 811589153

def solve(l, key=1, iterations=1):
    l = [(id, e*key) for id, e in l]
    n = len(l)
    for k in range(iterations):
        idx = 0
        while idx < n:
            i, (id, e) = next((i, v) for i, v in enumerate(l) if v[0] == idx)
            l.insert((i + e) % (n-1), l.pop(i))
            idx += 1
    l = [e for i, e in l]
    i = l.index(0)
    n = len(l)
    l = l[i:] + l[:i]
    return l[1000%n] + l[2000%n] + l[3000%n]

print(solve(inp))
print(solve(inp, key, 10))

