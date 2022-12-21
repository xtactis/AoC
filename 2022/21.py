import sys

lines = {l[0][:-1]: [int(l[1])] if len(l) == 2 else l[1:] for l in list(map(str.split, sys.stdin.readlines()))}

opposite = {'+': '-', '-': '+', '*': '/', '/': '*'}

def dfs(cur):
    l = lines[cur]
    if len(l) == 1:
        return l[0]

    a, b = dfs(l[0]), dfs(l[2])

    match l[1]:
        case '+': return a+b
        case '-': return a-b
        case '/': return a//b
        case '*': return a*b

def p2(cur):
    l = lines[cur]
    if cur == "root":
        a, b = p2(l[0]), p2(l[2])
        return a, b
    if cur == "humn":
        return []
    if len(l) == 1:
        return l[0]

    a, b = p2(l[0]), p2(l[2])
    if type(a) == list:
        return [(opposite[l[1]], b)]+a
    if type(b) == list:
        if l[1] == '/':
            return [(a, l[1])]+b
        elif l[1] == '-':
            return [(a, opposite[l[1]])]+b
        else:
            return [(opposite[l[1]], a)]+b

    match l[1]:
        case '+': return a+b
        case '-': return a-b
        case '/': return a//b
        case '*': return a*b

print(dfs("root"))

a, b = p2("root")
if type(b) == list:
    a, b = b, a

for op, val in a:
    if type(val) == str:
        op, val = val, op
        if op == '+':
            val, b = -b, val
    match op:
        case '+': b += val
        case '-': b -= val
        case '/': b //= val
        case '*': b *= val

print(b)

