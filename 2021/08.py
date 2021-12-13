with open("08.in", "r") as inp:
    lines = inp.readlines()

lines = [line.split('|') for line in lines]
signals = [l[0].split() for l in lines]
outputs = [l[1].split() for l in lines]

p1 = 0
for o in outputs:
    for e in o:
        if len(e) in [2, 4, 3, 7]:
            p1 += 1

print(p1)

filterl = lambda x, y: list(filter(x, y))

def deduce(pattern):
    one = filterl(lambda x: len(x) == 2, pattern)[0]
    four = filterl(lambda x: len(x) == 4, pattern)[0]
    seven = filterl(lambda x: len(x) == 3, pattern)[0]
    eight = filterl(lambda x: len(x) == 7, pattern)[0]
    six = filterl(lambda x: len(x) == 6, pattern)
    six = filterl(lambda x: not all(e in x for e in one), six)[0] # no 9
    nine = filterl(lambda x: len(x) == 6, pattern)
    nine = filterl(lambda x: all(e in x for e in four), nine)[0] # no 6
    three = filterl(lambda x: len(x) == 5, pattern)
    three = filterl(lambda x: all(e in x for e in one), three)[0]
    two = filterl(lambda x: len(x) == 5, pattern)
    two = filterl(lambda x: not all(e in x for e in one), two)
    two = filterl(lambda x: not all(e in six for e in x), two)[0]
    five = filterl(lambda x: len(x) == 5, pattern)
    five = filterl(lambda x: all(e in six for e in x), five)[0]

    ret = [one, two, three, four, five, six, seven, eight, nine]
    ret = {''.join(sorted(e)): i for i, e in enumerate(ret, 1)}
    return ret

p2 = 0

for signal, output in zip(signals, outputs):
    cur = 0
    numbahs = deduce(signal)
    for o in output:
        cur *= 10
        cur += numbahs.get(''.join(sorted(o)), 0)
    p2 += cur
print(p2)