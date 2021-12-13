from collections import defaultdict

with open("12.in", "r") as inp:
    lines = inp.read().split()

g = defaultdict(list)

for l in lines:
    e = l.split("-")
    g[e[0]].append(e[1])
    g[e[1]].append(e[0])

bio = defaultdict(int)

def dfs(node, twice=None):
    global bio
    if node == "end":
        return 1
    ret = 0
    bio[node] += 1
    for e in g[node]:
        if e.islower() and bio[e] > 0:
            if twice is None and e != "start":
                ret += dfs(e, e)
            continue
        ret += dfs(e, twice)
    bio[node] -= 1
    return ret

print(dfs("start", 1))
print(dfs("start"))