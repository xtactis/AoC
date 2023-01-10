import sys
from functools import reduce

conv = {"=": -2, "-": -1, "0": 0, "1": 1, "2": 2}
iconv = {v: k for k, v in conv.items()}

def add(x, y):
    if len(x) < len(y):
        x, y = y, x
    res = ""
    carry = 0
    for i, e in enumerate(reversed(x)):
        f = y[-(i+1)] if i < len(y) else "0"
        c = conv[e]+conv[f]+carry
        if c < -2:
            carry = -1
            c += 5
        elif c > 2:
            carry = 1
            c -= 5
        else:
            carry = 0
        res += iconv[c]
    if carry != 0:
        res += iconv[carry]
    return res[::-1]

print(reduce(add, sys.stdin.read().split())) 
