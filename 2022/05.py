import sys
import copy

cratelines, moves = sys.stdin.read().split("\n\n")
moves = moves.split("\n")
cratelines = cratelines.split("\n")[:-1]
cratelines.reverse()

crates = [[line[i] for line in cratelines if line[i] != " "] for i in range(1, len(cratelines[0]), 4)]

def move(crates, n, from_, to, rev=True):
    from_ -= 1
    to -= 1
    if rev:
        crates[to].extend(reversed(crates[from_][-n:]))
    else:
        crates[to].extend(crates[from_][-n:])
    crates[from_] = crates[from_][:-n]

def solve(crates, moves, part1=False):
    for m in moves:
        ms = m.split()
        ms = map(int, [ms[1], ms[3], ms[5]])
        move(crates, *ms, part1)
    return ''.join(c[-1] for c in crates)

print(solve(copy.deepcopy(crates), moves, part1=True))
print(solve(crates, moves, part1=False))

