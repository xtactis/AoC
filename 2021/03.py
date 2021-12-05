with open("03.in", "r") as inp:
    lines = inp.readlines()

N = len(lines[0][:-1])

def count(lines):
    ret = [[0, 0] for e in range(N)]
    for line in lines:
        for i, e in enumerate(line[:-1]):
            ret[i][int(e)] += 1
    return ret

p1 = count(lines)
gamma = 0
epsilon = 0

for i, e in enumerate(reversed(p1)):
    if e[0] > e[1]:
        epsilon += 2**i
    else:
        gamma += 2**i

oxy = lines.copy()
co2 = lines.copy()
for i in range(N):
    e = count(oxy)[i]
    f = count(co2)[i]
    print(oxy)
    print(e)
    if len(oxy) > 1: 
        oxy = list(filter(lambda x: int(x[i]) == 1 if e[0] == e[1] else e[int(x[i])] > e[1-int(x[i])], oxy))
    if len(co2) > 1: 
        co2 = list(filter(lambda x: int(x[i]) == 0 if f[0] == f[1] else f[int(x[i])] < f[1-int(x[i])], co2))

print(epsilon * gamma)
print(int(oxy[0], base=2) * int(co2[0], base=2))