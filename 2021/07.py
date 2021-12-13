from functools import reduce


with open("07.in", "r") as inp:
    lines = inp.read()

crabs = list(map(int, lines.split(",")))

for f in (lambda x:x, lambda x: x*(x+1)//2):
    mintot = 10e45
    best = -1
    for i in range(min(crabs), max(crabs)):
        tot = reduce(lambda acc, c: acc+f(abs(c-i)), crabs, 0)
        if tot < mintot:
            mintot = tot
            best = i
    print(mintot)