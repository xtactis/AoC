import heapq
from math import log10
from collections import defaultdict

with open(__file__[-5:-3]+".in", "r") as inp:
    lines = inp.read().split('\n')

def drawhistory(history):
    for s in history:
        state = [{0: '.', 1: 'A', 10: 'B', 100: 'C', 1000: 'D'}[e] for e in s[:-1]]
        print("############# cost =", s[-1])
        print("#", state[0], state[1], ".", state[2], ".", state[3], ".", state[4], ".", state[5], state[6], "#", sep="")
        for i in range(7, len(state), 4):
            print("###" if i == 7 else "  #", state[i], "#", state[i+1], "#", state[i+2], "#", state[i+3], "###" if i == 7 else "#  ", sep="")
        print("  #########  \n")

def parse(lines):
    stops = []
    houses = []
    for i, l in enumerate(lines[1:-1], start=1):
        for j, e in enumerate(l[1:-1], start=1):
            if e == '#': continue
            if lines[i+1][j] == lines[i-1][j] and lines[i+1][j] == '#':
                stops.append([i, j])
            if lines[i][j+1] == lines[i][j-1] and lines[i][j+1] == '#':
                houses.append([i, j])
    value = {'.': 0, 'A': 1, 'B': 10, 'C': 100, 'D': 1000}
    state = [value[lines[y][x]] for y, x in stops+houses]
    return stops, houses, state

def help(stops, houses):
    moves = defaultdict(list)
    for i, s in enumerate(stops):
        for j, h in enumerate(houses, start=7):
            stopabovehouse = (j-7)%4+1
            clear = [x+7 for x in range(stopabovehouse-1, j-7+1, 4) if x+7 != j] # from house to stopabovehouse
            if i < stopabovehouse: 
                clear.extend(range(i+1, stopabovehouse+1))
            elif i > stopabovehouse:
                stopabovehouse+=1
                clear.extend(range(stopabovehouse, i))
            cost = sum(abs(a-b) for a, b in zip(s, h))
            if cost == 0: print(s, h)
            moves[i].append((j, cost, clear+[j]))
            moves[j].append((i, cost, clear+[i]))
    correct = [[7+j*4+i for j in range(0, len(houses)//4)] for i in range(4)]    
    return moves, correct

for part in ("part 1:", "part 2:"):
    stops, houses, state = parse(lines)
    moves, correct = help(stops, houses)
    endstate = [0]*7+[10**(i%4) for i in range(len(houses))]

    pq = []
    been = {}
    heapq.heappush(pq, (0, state, [state+[0]]))
    while pq:
        cost, state, history = heapq.heappop(pq)
        if state == endstate:
            print(part, cost)
            break
        for i, e in enumerate(state):
            if e == 0: continue
            if i in correct[int(log10(e))] and all(state[x] == e for x in correct[int(log10(e))] if x > i): continue
            for move, c, clear in moves[i]:
                if any(state[x] != 0 for x in clear): continue
                if i < 7 and move not in correct[int(log10(e))]: continue
                if i < 7 and any(state[x] not in (0, e) for x in correct[int(log10(e))]): continue
                if i < 7 and any(state[x] == 0 for x in correct[int(log10(e))] if x > move): continue
                state[i], state[move] = state[move], state[i]
                if been.get(tuple(state), c*e+cost+1) > c*e+cost:
                    been[tuple(state.copy())] = c*e+cost
                    heapq.heappush(pq, (c*e+cost, state.copy(), history+[state.copy()+[c*e+cost]]))
                state[i], state[move] = state[move], state[i]
    drawhistory(history)
    lines = lines[:3]+"  #D#C#B#A#\n  #D#B#A#C#".split("\n")+lines[3:]