import sys
import builtins
from functools import cmp_to_key

pairs = list(map(lambda p: [eval(e) for e in p.split()], sys.stdin.read().split("\n\n")[:-1]))

def compare(l1, l2):
    match [l1, l2]:
        case [list(), list()]:
            for e, f in zip(l1, l2):
                if (c := compare(e, f)) != 0:
                    return c
            return compare(len(l1), len(l2))
        case [int(), int()]:
            return l2-l1
        case [int(), list()]:
            return compare([l1], l2)
        case [list(), int()]:
            return compare(l1, [l2])

part1 = sum(i for i, p in enumerate(pairs, 1) if compare(*p) > 0)
print(part1)

l = [e for e, _ in pairs] + [e for _, e in pairs] + [[[2]]] + [[[6]]] + [[]]
l.sort(key=cmp_to_key(compare), reverse=True)

print(l.index([[2]])*l.index([[6]]))

