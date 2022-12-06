DEFINT A-Z
DECLARE SUB FillCount (ln$, count() AS INTEGER)
DECLARE FUNCTION Priority (c$)

DIM count(1 TO 52) AS INTEGER

DIM total AS LONG
OPEN "in.txt" FOR INPUT AS #1
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    length = LEN(ln$) \ 2
    leftComp$ = LEFT$(ln$, length)
    rightComp$ = RIGHT$(ln$, length)
    
    FillCount leftComp$, count()

    duplicate = -1
    FOR i = 1 TO length
        p = Priority(MID$(rightComp$, i, 1))
        IF count(p) > 0 THEN
            duplicate = p
            EXIT FOR
        END IF
    NEXT
    total = total + duplicate

    ERASE count
LOOP

PRINT "Ans1 = "; total

END

SUB FillCount (ln$, count() AS INTEGER)
    length = LEN(ln$)
    FOR i = 1 TO length
        p = Priority(MID$(ln$, i, 1))
        count(p) = count(p) + 1
    NEXT
END SUB

FUNCTION Priority (c$)
    a = ASC(c$)
    IF a >= ASC("a") THEN
        Priority = a - ASC("a") + 1
    ELSE
        Priority = a - ASC("A") + 27
    END IF
END FUNCTION

