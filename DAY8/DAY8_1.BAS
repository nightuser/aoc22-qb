DEFINT A-Z

CONST MaxSize = 99

DECLARE SUB UpdateVisibility (j, i)

DIM SHARED map(MaxSize - 1, MaxSize - 1) AS INTEGER
DIM SHARED visible(MaxSize - 1, MaxSize - 1) AS INTEGER
DIM SHARED curMax AS INTEGER
DIM SHARED ans1 AS INTEGER

j = 0
OPEN "in.txt" FOR INPUT AS #1
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    w = LEN(ln$)
    FOR i = 0 TO w - 1
        x = VAL(MID$(ln$, i + 1, 1))
        map(j, i) = x
    NEXT
    j = j + 1
LOOP
CLOSE #1
h = j

ans1 = 2 * (w + h - 2)

FOR j = 1 TO h - 2
    curMax = map(j, 0)
    FOR i = 1 TO w - 2
        UpdateVisibility j, i
    NEXT
    curMax = map(j, w - 1)
    FOR i = w - 2 TO 1 STEP -1
        UpdateVisibility j, i
    NEXT
NEXT

FOR i = 1 TO w - 2
    curMax = map(0, i)
    FOR j = 1 TO h - 2
        UpdateVisibility j, i
    NEXT
    curMax = map(h - 1, i)
    FOR j = h - 2 TO 1 STEP -1
        UpdateVisibility j, i
    NEXT
NEXT

PRINT "Ans1 = "; ans1

END

SUB UpdateVisibility (j, i)
    x = map(j, i)
    IF x > curMax THEN
        curMax = x
        IF NOT visible(j, i) THEN
            visible(j, i) = -1
            ans1 = ans1 + 1
        END IF
    END IF
END SUB

