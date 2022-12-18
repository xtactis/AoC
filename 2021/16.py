from functools import reduce

with open(__file__[-5:-3]+".in", "r") as inp:
    lines = inp.read()

binary = "".join("{0:04b}".format(int(c, base=16)) for c in lines)

p1 = 0

def parse_literal(i):
    value = 0
    while binary[i] == "1":
        value *= 16
        value += int(binary[i+1:i+5], base=2)
        i += 5
    value *= 16
    value += int(binary[i+1:i+5], base=2)
    i += 5
    return i, value

def parse_operator(i):
    values = []
    i += 1
    if binary[i-1] == "1":
        n_packets = int(binary[i:i+11], base=2) # number of packets that come after
        i += 11
        for _ in range(n_packets):
            i, x = parse(i)
            values.append(x)
    else:
        n_bits = int(binary[i:i+15], base=2) # number of bits that come after
        i += 15
        limit = i + n_bits
        while i < limit:
            i, x = parse(i)
            values.append(x)
    return i, values

def parse(i=0):
    global p1
    version = int(binary[i:i+3], base=2)
    p1 += version
    type = int(binary[i+3:i+6], base=2)
    i = i+6
    if type == 4: return parse_literal(i)
    i, values = parse_operator(i)
    if type == 0: value = sum(values)
    elif type == 1: value = reduce(lambda x, acc: acc*x, values, 1)
    elif type == 2: value = min(values)
    elif type == 3: value = max(values)
    elif type == 5: value = 1 if values[0] > values[1] else 0
    elif type == 6: value = 1 if values[0] < values[1] else 0
    elif type == 7: value = 1 if values[0] == values[1] else 0
    return i, value
    
_, value = parse()

print(p1)
print(value)