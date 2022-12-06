DEFINT A-Z

TYPE Range
    rFrom AS LONG
    rTo AS LONG
END TYPE

DECLARE SUB SplitBy (s$, sep$, l$, r$)
DECLARE FUNCTION IsContained (r1 AS Range, r2 AS Range)
DECLARE FUNCTION IsOverlap (r1 AS Range, r2 AS Range)

OPEN "in.txt" FOR INPUT AS #1
total1& = 0
total2& = 0
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    SplitBy ln$, ",", fst$, snd$

    SplitBy fst$, "-", f$, t$
    DIM r1 AS Range
    r1.rFrom = VAL(f$): r1.rTo = VAL(t$)

    SplitBy snd$, "-", f$, t$
    DIM r2 AS Range
    r2.rFrom = VAL(f$): r2.rTo = VAL(t$)

    IF IsContained(r1, r2) THEN
        total1& = total1& + 1
    END IF
    IF IsOverlap(r1, r2) THEN
        total2& = total2& + 1
    END IF
LOOP
CLOSE #1

PRINT "Ans1 = "; total1&
PRINT "Ans2 = "; total2&

END

FUNCTION IsContained (r1 AS Range, r2 AS Range)
    r12 = r1.rFrom <= r2.rFrom AND r1.rTo >= r2.rTo
    r21 = r2.rFrom <= r1.rFrom AND r2.rTo >= r1.rTo
    IsContained = r12 OR r21
END FUNCTION

FUNCTION IsOverlap (r1 AS Range, r2 AS Range)
    IF r1.rFrom > r2.rFrom THEN
        IsOverlap = IsOverlap(r2, r1)
    ELSE
        IsOverlap = r1.rTo >= r2.rFrom
    END IF
END FUNCTION

SUB SplitBy (s$, sep$, l$, r$)
    sepPos = INSTR(s$, sep$)
    l$ = LEFT$(s$, sepPos - 1)
    r$ = RIGHT$(s$, LEN(s$) - sepPos)
END SUB

