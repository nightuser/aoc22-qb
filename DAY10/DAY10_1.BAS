DEFINT A-Z

DIM ans1 AS LONG
DIM v AS LONG
v = 1

cycle = 0
nextCycle = 20
OPEN "in.txt" FOR INPUT AS #1
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    vPrev% = v
    IF ln$ = "noop" THEN
        cycle = cycle + 1
    ELSE
        dv% = VAL(RIGHT$(ln$, LEN(ln$) - 5))
        v = v + dv%
        cycle = cycle + 2
    END IF
    DO WHILE nextCycle <= cycle
        strength% = nextCycle * vPrev%
        ans1 = ans1 + strength%
        ' PRINT nextCycle; strength%
        nextCycle = nextCycle + 40
    LOOP
    IF nextCycle = cycle + 1 THEN
        strength% = nextCycle * v
        ans1 = ans1 + strength%
        ' PRINT nextCycle; strength%; cycle
        nextCycle = nextCycle + 40
    END IF
LOOP
CLOSE #1

PRINT "Ans1 = "; ans1

END

