from operator import add, mul
import math
import sys

megatest = []

def parsemonkey(s):
    global megatest
    items, op, test, true, false = map(lambda x: x.split(":")[1], s.split("\n")[1:])
    items = list(map(int, items.split(",")))
    op, value = op.split()[-2:]
    if value != "old":
        op = lambda x,op=op,value=value: (add if op == "+" else mul)(x, int(value))
    else:
        op = lambda x,op=op: (add if op == "+" else mul)(x, x)
    test = int(test.split()[-1])
    megatest.append(test)
    true = int(true.split()[-1])
    false = int(false.split()[-1])
    return {"items": items, "op": op, "test": lambda x: x % test == 0, True: true, False: false}


monkeys = list(map(parsemonkey, sys.stdin.read()[:-1].split("\n\n")))
inspections = [0]*len(monkeys)
megatest = math.lcm(*megatest)

for rnd in range(10000):
    print(rnd)
    for i, monkey in enumerate(monkeys):
        for item in monkey["items"]:
            item = monkey["op"](item) % megatest
            monkeys[monkey[monkey["test"](item)]]["items"].append(item)
            inspections[i] += 1
        monkey["items"] = []

print(inspections)
inspections = sorted(inspections)
print(inspections[-2]*inspections[-1])
