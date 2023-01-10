import sys
import itertools

inp = sys.stdin.read().strip()

rocks = "-+LIO"

dxs = {
    '-': [0, 1, 2, 3],
    '+': [1, 0, 1, 2, 1],
    'L': [2, 2, 0, 1, 2],
    'I': [0, 0, 0, 0],
    'O': [0, 1, 0, 1]
}
dys = {
    '-': [0, 0, 0, 0],
    '+': [2, 1, 1, 1, 0],
    'L': [2, 1, 0, 0, 0],
    'I': [3, 2, 1, 0],
    'O': [1, 1, 0, 0]
}

def can_cover(rocktype, x, y):
    return all(x+dx >= 0 and x+dx < 7 and m[y+dy][x+dx] == ' ' for dx, dy in zip(dxs[rocktype], dys[rocktype]))

def cement(rocktype, x, y):
    tallest = -1
    for dx, dy in zip(dxs[rocktype], dys[rocktype]):
        m[y+dy][x+dx] = '#'
        tallest = max(tallest, y+dy)
    return tallest

def signature(m, tallest, n=10):
    # returns a stringified version of the top n lines
    # idea stolen from @jonathanpaulson
    return ''.join(map(''.join, m[tallest-n:tallest]))

def solve(iterations):
    windex = 0
    tallest = 0
    iteration = 0
    extra = 0
    seen = {}
    while iteration < iterations:
        rocktype = rocks[iteration%5]
        x, y = 2, tallest+4
        while True: 
            if inp[windex] == "<":
                if can_cover(rocktype, x-1, y):
                    x -= 1
            else:
                if can_cover(rocktype, x+1, y):
                    x += 1
            windex = (windex+1)%len(inp)
            if can_cover(rocktype, x, y-1):
                y -= 1
            else:
                tallest = max(tallest, cement(rocktype, x, y))

                sig = (windex, rocktype, signature(m, tallest, n=30))
                if sig in seen and iteration >= 2022:
                    old_it, old_tallest = seen[sig]
                    d_y = tallest-old_tallest
                    d_it = iteration-old_it
                    amount = (iterations-iteration)//d_it
                    extra += amount*d_y
                    iteration += amount*d_it
                seen[sig] = (iteration, tallest)
                break
        iteration += 1
    return tallest + extra

m = [['#']*7] + [[' ']*7 for _ in range(10000)]
print(solve(2022))
m = [['#']*7] + [[' ']*7 for _ in range(10000)]
print(solve(1_000_000_000_000))
