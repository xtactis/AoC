with open("10.in", "r") as inp:
    lines = inp.read().split()

matches = {'{': '}', '[': ']', '(': ')', '<': '>'}
scores = {'}': 1197, ']': 57, ')': 3, '>': 25137}
scores2 = {'{': 3, '[': 2, '(': 1, '<': 4}
p1 = 0
p2 = []
goodlines = []
for l in lines:
    stack = []
    good = True
    for c in l:
        if c in ('(', '[', '{', '<'):
            stack.append(c)
        else:
            if matches[stack[-1]] == c:
                stack.pop()
            else:
                good = False
                p1 += scores[c]
                break
    if good:
        c = 0
        for s in reversed(stack):
            c *= 5
            c += scores2[s]
        p2.append(c)

print(p1)
print(sorted(p2)[len(p2)//2])
