' $DYNAMIC
DEFINT A-Z

CONST N = 7
CONST M = 15
REDIM a(-N TO N, -N TO M, -N TO M)
REDIM a2(-N TO N, -N TO M, -N TO M)
REDIM b(-N TO N, -N TO N, -N TO M, -N TO M)
REDIM b2(-N TO N, -N TO N, -N TO M, -N TO M)


OPEN "input.txt" FOR INPUT AS #1
y% = 0
DO WHILE NOT EOF(1)
    LINE INPUT #1, l$
    FOR x = 1 TO LEN(l$)
        IF MID$(l$, x, 1) = CHR$(35) THEN
            a(0, y, x - 1) = 1
            b(0, 0, y, x - 1) = 1
        ELSE
            a(0, y, x - 1) = 0
            b(0, 0, y, x - 1) = 0
        END IF
    NEXT
    y = y + 1
LOOP
CLOSE 1

FOR GEN = 0 TO 5
    FOR z = -(N - 1) TO (N - 1)
        FOR y = -(N - 1) TO (M - 1)
            FOR x = -(N - 1) TO (M - 1)
                cnt% = 0
                FOR dz = -1 TO 1
                    FOR dy = -1 TO 1
                        FOR dx = -1 TO 1
                            IF NOT (dx = 0 AND dy = 0 AND dz = 0) THEN
                                cnt = cnt + a(z + dz, y + dy, x + dx)
                            END IF
                        NEXT
                    NEXT
                NEXT
                IF a(z, y, x) = 1 AND NOT (cnt = 2 OR cnt = 3) THEN
                    a2(z, y, x) = 0
                ELSEIF a(z, y, x) = 0 AND cnt = 3 THEN
                    a2(z, y, x) = 1
                ELSE
                    a2(z, y, x) = a(z, y, x)
                END IF
            NEXT
        NEXT
    NEXT
    FOR z = -(N - 1) TO (N - 1)
        FOR y = -(N - 1) TO (M - 1)
            FOR x = -(N - 1) TO (M - 1)
                SWAP a(z, y, x), a2(z, y, x)
            NEXT
        NEXT
    NEXT
NEXT

FOR GEN = 0 TO 5
    FOR w = -(N - 1) TO (N - 1)
        FOR z = -(N - 1) TO (N - 1)
            FOR y = -(N - 1) TO (M - 1)
                FOR x = -(N - 1) TO (M - 1)
                    cnt% = 0
                    FOR dw = -1 TO 1
                        FOR dz = -1 TO 1
                            FOR dy = -1 TO 1
                                FOR dx = -1 TO 1
                                    IF NOT (dx = 0 AND dy = 0 AND dz = 0 AND dw = 0) THEN
                                        cnt = cnt + b(w + dw, z + dz, y + dy, x + dx)
                                    END IF
                                NEXT
                            NEXT
                        NEXT
                    NEXT
                    IF b(w, z, y, x) = 1 AND NOT (cnt = 2 OR cnt = 3) THEN
                        b2(w, z, y, x) = 0
                    ELSEIF b(w, z, y, x) = 0 AND cnt = 3 THEN
                        b2(w, z, y, x) = 1
                    ELSE
                        b2(w, z, y, x) = b(w, z, y, x)
                    END IF
                NEXT
            NEXT
        NEXT
    NEXT
    FOR w = -(N - 1) TO (N - 1)
        FOR z = -(N - 1) TO (N - 1)
            FOR y = -(N - 1) TO (M - 1)
                FOR x = -(N - 1) TO (M - 1)
                    SWAP b(w, z, y, x), b2(w, z, y, x)
                NEXT
            NEXT
        NEXT
    NEXT
NEXT

part1% = 0
FOR z = -(N - 1) TO (N - 1)
    FOR y = -(N - 1) TO (M - 1)
        FOR x = -(N - 1) TO (M - 1)
            part1 = part1 + a(z, y, x)
        NEXT
    NEXT
NEXT

part2% = 0
FOR w = -(N - 1) TO (N - 1)
    FOR z = -(N - 1) TO (N - 1)
        FOR y = -(N - 1) TO (M - 1)
            FOR x = -(N - 1) TO (M - 1)
                part2 = part2 + b(w, z, y, x)
            NEXT
        NEXT
    NEXT
NEXT

PRINT "part 1:", part1
PRINT "part 2:", part2
