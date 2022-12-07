import fileinput

fs = {}

def add_to_fs(fs, line, current_dir):
    global part1
    cfs = fs
    for d in current_dir:
        cfs = cfs.get(d, {})
    l = line.split()
    if l[0] == "dir":
        cfs[l[1]] = {}
    else:
        cfs[l[1]] = int(l[0])
        

def walkthisway(lines, current_dir):
    global fs
    for line in lines:
        iscmd = line.startswith("$")
        cmd = line.split()[1:]
        if iscmd:
            if cmd[0] == "cd":
                if cmd[1] == "/":
                    current_dir = []
                elif cmd[1] == "..":
                    current_dir.pop()
                else:
                    current_dir.append(cmd[1])
        else:
            add_to_fs(fs, line, current_dir)
        
part1sum = 0
def part1(fs):
    global part1sum
    total = 0
    for key, value in fs.items():
        if isinstance(value, int):
            total += value
        else:
            total += part1(value)
    if total < 100000:
        part1sum += total
    return total

part2smallest = 70000000
def part2(fs, needed):
    global part2smallest
    total = 0
    for key, value in fs.items():
        if isinstance(value, int):
            total += value
        else:
            total += part2(value, needed)
    print(needed)
    if total >= needed and total < part2smallest:
        part2smallest = total
    return total

lines = [line for line in fileinput.input()]
walkthisway(lines, [])
fssize = part1(fs)
print(part1sum)
print(70000000-fssize)
part2(fs, 30000000-(70000000-fssize))
print(part2smallest)
