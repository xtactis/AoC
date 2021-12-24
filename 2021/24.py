with open(__file__[-5:-3]+".in", "r") as inp:
    lines = [l.split() for l in inp.read().split('\n')]

def run(lines):
    mem = {x: 0 for x in "xyzw"}
    actinp = []
    for j, l in enumerate(lines):
        cmd, args = l[0], l[1:]
        match cmd:
            case "inp": pass
            case "add": mem[args[0]] += mem[args[1]] if args[1] in "xyzw" else int(args[1])
            case "mul": mem[args[0]] *= mem[args[1]] if args[1] in "xyzw" else int(args[1])
            case "div": mem[args[0]] //= mem[args[1]] if args[1] in "xyzw" else int(args[1])
            case "mod": mem[args[0]] %= mem[args[1]] if args[1] in "xyzw" else int(args[1])
            case "eql": mem[args[0]] = mem[args[0]] == (mem[args[1]] if args[1] in "xyzw" else int(args[1]))
        if j % 18 == 5:
            mem['w'] = mem[args[0]] if int(lines[j][2]) < 0 else 1
            actinp.append(mem['w'])
    return actinp

mask = [lines[i][2] == '1' for i in range(4, len(lines), 18)]
wrong = run(lines)
stack = []
part1 = mask.copy()
part2 = mask.copy()
for i, e in enumerate(wrong):
    if mask[i]:
        stack.append(i)
    else:
        trigger = stack.pop()
        if e <= 0:
            part1[i] = e+8
            part1[trigger] = 9
            part2[i] = 1
            part2[trigger] = 2-e
        else:
            part1[i] = 9
            part1[trigger] = 10-e
            part2[i] = e
            part2[trigger] = 1

print("part 1: ", *part1, sep="")
print("part 2: ", *part2, sep="")
