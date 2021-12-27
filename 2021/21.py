with open(__file__[-5:-3]+".in", "r") as inp:
    lines = inp.read().split('\n')

position = [int(l.split(": ")[1])-1 for l in lines]

def part1(position):
    scores, last, player = [0, 0], 0, False
    while True:
        position[player] = (position[player]+last*3+6)%10
        scores[player] += position[player]+1
        last = last+3
        if scores[player] >= 1000: break
        player = not player
    return scores[not player] * last

from functools import cache
@cache
def rec(pos0, pos1, score0, score1, player, rolls):
    pos, score = [pos0, pos1], [score0, score1]
    if rolls == 0:
        score[player] += pos[player]+1
        if score[0] >= 21 or score[1] >= 21: return [s >= 21 for s in score]
        return rec(*pos, *score, not player, 3)
    ret = [0, 0]
    for _ in range(3):
        pos[player] = (pos[player]+1)%10
        a = rec(*pos, *score, player, rolls-1)
        ret[0] += a[0]
        ret[1] += a[1]
    return ret

print(part1(position.copy()))
print(max(rec(*position, 0, 0, False, 3)))