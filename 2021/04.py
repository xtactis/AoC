with open("04.in", "r") as inp:
    lines = inp.read()

lines = lines.split("\n\n")

numbers = list(map(int, lines[0].split(',')))
boards = [[list(map(int, e.split())) for e in bline.split("\n")] for bline in lines[1:]]

def checkdone(board, number):
    for i in range(5):
        if all(e in [-1, number] for e in board[i]):
            return True
        vert = True
        for j in range(5):
            vert = vert and board[j][i] in [-1, number]
        if vert:
            return True
    return False 

def solve(numbers, boards, first=True):
    done = set()
    for n in numbers:
        for bi, b in enumerate(boards):
            if bi in done:
                continue
            for i in range(5):
                for j in range(5):
                    if b[i][j] == n:
                        if checkdone(b, n):
                            done.add(bi)
                            if first:
                                return (b, n)
                            elif len(done) == len(boards):
                                return (b, n)
                        b[i][j] = -1

part = [0, 0]
board1, last1 = solve(numbers, boards, True)
board2, last2 = solve(numbers, boards, False)
for i in range(5):
    for j in range(5):
        for k, b, l in zip(range(2), [board1, board2], [last1, last2]):
            if b[i][j] != l and b[i][j] != -1:
                part[k] += b[i][j]
        

print(part[0]*last1)
print(part[1]*last2)