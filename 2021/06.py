with open("06.in", "r") as inp:
    lines = inp.readlines()

fish = list(map(int, lines[0].split(",")))

dp = dict()
def rec(days, offset):
    if dp.get((days, offset)) is not None:
        return dp[(days, offset)]
    if days <= 0:
        return 1
    dp[(days, offset)] = rec(days-offset, 7) + rec(days-offset, 9)
    return dp[(days, offset)]

for days in [80, 256]:
    count = 0
    for f in fish:
        count += rec(days, f)
    print(count//2) 
