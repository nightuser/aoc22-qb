DEFINT A-Z
DECLARE SUB fillCount (ln$, count() AS INTEGER)
DECLARE FUNCTION Priority (c$)

DIM count1(1 TO 52) AS INTEGER
DIM count2(1 TO 52) AS INTEGER
DIM count3(1 TO 52) AS INTEGER

DIM total AS LONG
OPEN "in.txt" FOR INPUT AS #1
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    fillCount ln$, count1()
    LINE INPUT #1, ln$
    fillCount ln$, count2()
    LINE INPUT #1, ln$
    fillCount ln$, count3()

    result = -1
    FOR i = 1 TO 52
        IF count1(i) > 0 AND count2(i) > 0 AND count3(i) > 0 THEN
            result = i
            EXIT FOR
        END IF
    NEXT
    total = total + result

    ERASE count1
    ERASE count2
    ERASE count3
LOOP

PRINT "Ans2 = "; total

END

SUB fillCount (ln$, count() AS INTEGER)
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

