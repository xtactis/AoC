with open(__file__[-5:-3]+".in", "r") as inp:
    code, image = inp.read().split('\n\n')

code = list(map(lambda x: 1 if x == "#" else 0, code))
image = [list(map(lambda x: 1 if x == "#" else 0, l)) for l in image.split("\n")]
height, width = len(image), len(image[0])

def kernel(image, i, j, step):
    ret = 0
    for e in range(i, i+3):
        for f in range(j, j+3):
            ret *= 2
            if e < 0 or f < 0 or e >= height-2 or f >= width-2:
                ret += step % 2
            else:
                ret += image[e][f]
    return ret

for step in range(50):
    height += 2
    width += 2
    image = [[code[kernel(image, i-2, j-2, step)] for j in range(width)] for i in range(height)]

print(sum(e for row in image for e in row))