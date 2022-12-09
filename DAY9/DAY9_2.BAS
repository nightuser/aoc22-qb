DEFINT A-Z

CONST Knots = 10

DECLARE SUB MoveHead (dir$)
DECLARE SUB MoveTail (j)
DECLARE SUB SetVisited (x, y)

DIM SHARED visited(32766) AS INTEGER

DIM SHARED kx(Knots - 1)
DIM SHARED ky(Knots - 1)
DIM SHARED totalVisited AS LONG

SetVisited 0, 0
totalVisited = 1

CLS

OPEN "in.txt" FOR INPUT AS #1
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    dir$ = LEFT$(ln$, 1)
    shift = VAL(RIGHT$(ln$, LEN(ln$) - 2))
    FOR i = 0 TO shift - 1
        MoveHead dir$
        FOR j = 1 TO Knots - 1
            MoveTail j
        NEXT
    NEXT
LOOP
CLOSE #1

PRINT "Ans2 = "; totalVisited

END

SUB MoveHead (dir$)
    SELECT CASE dir$
        CASE "L"
            kx(0) = kx(0) - 1
        CASE "R"
            kx(0) = kx(0) + 1
        CASE "U"
            ky(0) = ky(0) + 1
        CASE "D"
            ky(0) = ky(0) - 1
    END SELECT
END SUB

SUB MoveTail (j)
    dx = kx(j - 1) - kx(j)
    dy = ky(j - 1) - ky(j)
    IF ABS(dx) >= 2 OR ABS(dy) >= 2 THEN
        sx = SGN(dx)
        sy = SGN(dy)
    END IF
    kx(j) = kx(j) + sx
    ky(j) = ky(j) + sy
    IF j = Knots - 1 THEN
        IF sx <> 0 OR sy <> 0 THEN
            SetVisited kx(j), ky(j)
        END IF
    END IF
END SUB

SUB SetVisited (x, y)
    IF ABS(x) > 350 OR ABS(y) > 350 THEN
        ERROR 80
    END IF
    index& = (x + 350) * 700& + (y + 350)
    i = index& \ 16
    j = index& MOD 16
    IF j = 15 THEN
        mask = -32768
    ELSE
        mask = 2 ^ j
    END IF
    IF (visited(i) AND mask) = 0 THEN
        visited(i) = visited(i) OR mask
        totalVisited = totalVisited + 1
    END IF
END SUB

