import itertools

ranges = {}
myticket = []
nearby = []

def checkval(v):
  return any(map(lambda r: v >= r[0] and v <= r[1], itertools.chain(*ranges.values())))

def getpossible(ind, nearby):
  possible = set(ranges.keys())
  for t in nearby:
    for k, rs in ranges.items():
      if not any(map(lambda r: t[ind] >= r[0] and t[ind] <= r[1], rs)):
        possible.discard(k)
        if len(possible) == 1:
          return (possible, ind)
  return (possible, ind)

def part1():
  return sum(map(lambda v: 0 if checkval(v) else v, itertools.chain(*nearby)))

def part2():
  nearbyGood = list(filter(lambda t: all(map(checkval, t)), nearby))
  possibles = sorted([getpossible(i, nearbyGood) for i in range(len(myticket))], key=lambda s: len(s[0]))
  useless = set()
  result = 1
  for i, possible in enumerate(possibles):
    cur = (possible[0] - useless).pop()
    useless.add(cur)
    if cur.startswith("departure"):
      result *= myticket[possible[1]]
  return result

with open("input.txt", "r") as f:
  state = 0
  for line in f.readlines():
    line = line.strip()
    if not line:
      state += 1
      continue
    if state == 0:
      key, values = line.split(':')
      ranges[key] = [tuple(int(x) for x in v.split('-')) for v in values.split('or')]
    elif state == 1:
      if line == "your ticket:":
        continue
      myticket = [int(x) for x in line.split(',')]
    elif state == 2:
      if line == "nearby tickets:":
        continue
      nearby.append([int(x) for x in line.split(',')])

print("part 1:", part1())
print("part 2:", part2())