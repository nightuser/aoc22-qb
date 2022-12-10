DEFINT A-Z

DECLARE SUB DrawPixels (cnt)

DIM ans2 AS LONG
DIM SHARED v
v = 1

SCREEN 7
COLOR 8, 15

DIM SHARED row, col
row = 1
col = 1
OPEN "in.txt" FOR INPUT AS #1
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    IF ln$ = "noop" THEN
        DrawPixels 1
    ELSE
        DrawPixels 2
        dv% = VAL(RIGHT$(ln$, LEN(ln$) - 5))
        v = v + dv%
    END IF
LOOP
CLOSE #1

LOCATE 23, 1
PRINT "Ans2 = "; ans2

END

SUB DrawPixels (cnt)
    FOR i = 1 TO cnt
        IF ABS(row - v - 1) <= 1 THEN
            ' PRINT "#";
            LINE (8 * (row - 1), 16 * (col - 1))-STEP(8, 16), 8, BF
        ELSE
            ' PRINT ".";
        END IF
        IF row = 40 THEN
            row = 1
            col = col + 1
            PRINT
        ELSE
            row = row + 1
        END IF
    NEXT
END SUB

