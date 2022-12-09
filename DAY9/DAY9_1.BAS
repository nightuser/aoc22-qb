DEFINT A-Z

DECLARE SUB MoveHead (dir$)
DECLARE SUB MoveTail ()
DECLARE SUB SetVisited (x, y)

DIM SHARED visited(32766) AS INTEGER

DIM SHARED hx, hy
DIM SHARED tx, ty
hx = 0: hy = 0
tx = 0: ty = 0
DIM SHARED totalVisited AS LONG

SetVisited 0, 0
totalVisited = 1

OPEN "in.txt" FOR INPUT AS #1
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    dir$ = LEFT$(ln$, 1)
    shift = VAL(RIGHT$(ln$, LEN(ln$) - 2))
    ' PRINT dir$; shift
    FOR i = 0 TO shift - 1
        MoveHead dir$
        MoveTail
    NEXT
LOOP
CLOSE #1

PRINT "Ans1 = "; totalVisited

END

SUB MoveHead (dir$)
    SELECT CASE dir$
        CASE "L"
            hx = hx - 1
        CASE "R"
            hx = hx + 1
        CASE "U"
            hy = hy + 1
        CASE "D"
            hy = hy - 1
    END SELECT
END SUB

SUB MoveTail
    dx = hx - tx
    dy = hy - ty
    IF ABS(dx) >= 2 OR ABS(dy) >= 2 THEN
        sx = SGN(dx)
        sy = SGN(dy)
    END IF
    tx = tx + sx
    ty = ty + sy
    IF sx <> 0 OR sy <> 0 THEN
        SetVisited tx, ty
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

