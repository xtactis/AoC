with open("01.in", "r") as inp:
    lines = inp.readlines()
    lines = [int(line) for line in lines]

def count(lines, skip):
    res = 0
    for i, e in enumerate(lines[skip:], start=skip):
        if e > lines[i-skip]:
            res += 1
    return res

print("part 1: ", count(lines, 1))
print("part 2: ", count(lines, 3))
