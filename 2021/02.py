with open("02.in", "r") as inp:
    lines = inp.readlines()

lines = [line.split() for line in lines]

posx = 0
aim = 0
depth = 0

for line in lines:
    dir = line[0]
    amt = int(line[1])
    if dir == "forward":
        posx += amt
        depth += amt*aim
    elif dir == "down":
        aim += amt
    else:
        aim -= amt

print("part 1:", posx*aim)
print("part 2:", posx*depth)