import sys
from functools import cache

lines = [[int(e) if i != 1 else int(e[:-1]) for i, e in enumerate(l.split(" ")) if i in [1, 6, 12, 18, 21, 27, 30]] for l in sys.stdin.readlines()]
blueprints = {l[0]: [[l[1]], [l[2]], l[3:5], l[5:]] for l in lines}

def solve(bp, m=24):
    @cache
    def dp(mins, obots, cbots, obsbots, ore, clay, obs):
        if mins == 0:
            return 0
        if ore >= 10:
            return 0
        ret = 0
        for i in [0,1,2,4,8]:
            core = ore
            cclay = clay
            cobs = obs
            cobots = obots
            ccbots = cbots
            cobsbots = obsbots
            add = 0
            if (i & 1) > 0 and core >= bp[0][0]:
                cobots += 1
                core -= bp[0][0]
            if (i & 2) > 0 and core >= bp[1][0]:
                ccbots += 1
                core -= bp[1][0]
            if (i & 4) > 0 and core >= bp[2][0] and cclay >= bp[2][1]:
                cobsbots += 1
                core -= bp[2][0]
                cclay -= bp[2][1]
            if (i & 8) > 0 and core >= bp[3][0] and cobs >= bp[3][1]:
                add += (mins-1)
                core -= bp[3][0]
                cobs -= bp[3][1]
            ret = max(ret, add+dp(mins-1, cobots, ccbots, cobsbots, core+obots, cclay+cbots, cobs+obsbots))
        return ret
    dp.cache_clear()
    return dp(m, 1, 0, 0, 0, 0, 0 )
    
part1 = 0
for k,v in blueprints.items():
    q = solve(v)
    part1 += k*q
print(part1)

part2 = 1
for k,v in blueprints.items():
    if k not in [1,2,3]: continue
    q = solve(v, 32)
    part2 *= q
print(part2)
