DECLARE FUNCTION NewNode% (x%, y%, nxt%)
DEFINT A-Z

CONST MaxSize = 32677

DECLARE SUB MoveHead (dir$)
DECLARE SUB MoveTail ()
DECLARE SUB SetVisited (x, y)
DECLARE SUB HTAdd (x, y)
DECLARE SUB HTResize ()
DECLARE FUNCTION Hash (x, y)

DIM SHARED htCapacity, htSize
htCapacity = 11
DIM SHARED nodePoolLen
REDIM SHARED nodeX(1 TO htCapacity)
REDIM SHARED nodeY(1 TO htCapacity)
REDIM SHARED nodeNxt(1 TO htCapacity)
REDIM SHARED ht(htCapacity - 1)

DIM SHARED hx, hy
DIM SHARED tx, ty

SetVisited 0, 0

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

PRINT "Ans1 = "; htSize

END

FUNCTION Hash (x, y)
    Hash = 53 * (x + 350) + (y + 350)
END FUNCTION

SUB HTAdd (x, y)
    h = Hash(x, y)
    bucket = h MOD htCapacity
    id = ht(bucket)
    DO WHILE id <> 0
        IF nodeX(id) = x AND nodeY(id) = y THEN
            EXIT SUB
        END IF
        id = nodeNxt(id)
    LOOP
    ht(bucket) = NewNode(x, y, ht(bucket))
END SUB

SUB HTResize
    IF htSize <= .75# * htCapacity THEN
        EXIT SUB
    END IF
    REDIM oldNodeX(1 TO htCapacity)
    REDIM oldNodeY(1 TO htCapacity)
    FOR i = 1 TO htSize
        oldNodeX(i) = nodeX(i)
        oldNodeY(i) = nodeY(i)
    NEXT
    oldSize = htSize
    htSize = 0
    htCapacity = 2 * htCapacity
    REDIM nodeX(1 TO htCapacity)
    REDIM nodeY(1 TO htCapacity)
    REDIM nodeNxt(1 TO htCapacity)
    REDIM ht(htCapacity - 1)
    FOR i = 1 TO oldSize
        HTAdd oldNodeX(i), oldNodeY(i)
    NEXT
    ERASE oldNodeY
    ERASE oldNodeX
END SUB

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

FUNCTION NewNode (x, y, nxt)
    id = htSize + 1
    htSize = htSize + 1
    nodeX(id) = x
    nodeY(id) = y
    nodeNxt(id) = nxt
    NewNode = id
END FUNCTION

SUB SetVisited (x, y)
    IF ABS(x) > 350 OR ABS(y) > 350 THEN
        ERROR 80
    END IF
    'index& = (x + 350) * 700& + (y + 350)
    ' PRINT x; y
    HTAdd x, y
    HTResize
END SUB

