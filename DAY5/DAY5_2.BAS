DEFINT A-Z

CONST MaxStacks = 9
CONST MaxSize = 1000

DECLARE SUB Reverse (i)
DECLARE SUB PushStack (i, x)
DECLARE SUB Move (f, t, cnt)
DECLARE FUNCTION PopStack (i)
DECLARE FUNCTION PeekStack (i)
DECLARE FUNCTION IsAscii (c$)
DECLARE FUNCTION IsDigit (c$)
DECLARE FUNCTION SplitBy (s$, c$, ps$())

DIM SHARED stacks(MaxStacks - 1, MaxSize - 1) AS INTEGER
DIM SHARED lengths(MaxStacks - 1) AS INTEGER

OPEN "in.txt" FOR INPUT AS #1
numStacks = 0
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    IF IsDigit(MID$(ln$, 2, 1)) THEN
        numStacks = (LEN(ln$) - 2) \ 4 + 1
        EXIT DO
    END IF
    FOR i = 2 TO LEN(ln$) STEP 4
        c$ = MID$(ln$, i, 1)
        j = (i - 2) \ 4
        IF IsAscii(c$) THEN
            PushStack j, ASC(c$)
        END IF
    NEXT
LOOP

FOR i = 0 TO numStacks - 1
    Reverse i
    'PRINT CHR$(PeekStack(i))
NEXT

LINE INPUT #1, ln$
IF ln$ <> "" THEN
    PRINT "Wrong file format"
    SYSTEM
END IF

DIM ps$(5)
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    n = SplitBy(ln$, " ", ps$())
    cnt = VAL(ps$(1))
    f = VAL(ps$(3)) - 1
    t = VAL(ps$(5)) - 1
    Move f, t, cnt
LOOP

FOR i = 0 TO numStacks - 1
    PRINT CHR$(PeekStack(i));
NEXT
PRINT

CLOSE #1

END

FUNCTION IsAscii (c$)
    IF c$ >= "A" AND c$ <= "Z" THEN
        IsAscii = -1
    ELSE
        IsAscii = 0
    END IF
END FUNCTION

FUNCTION IsDigit (c$)
    IF c$ >= "0" AND c$ <= "9" THEN
        IsDigit = -1
    ELSE
        IsDigit = 0
    END IF
END FUNCTION

SUB Move (f, t, cnt)
    fLen = lengths(f)
    tLen = lengths(t)
    FOR i = 0 TO cnt - 1
        stacks(t, tLen + i) = stacks(f, fLen - cnt + i)
    NEXT
    lengths(f) = fLen - cnt
    lengths(t) = tLen + cnt
END SUB

FUNCTION PeekStack (i)
    PeekStack = stacks(i, lengths(i) - 1)
END FUNCTION

FUNCTION PopStack (i)
    PopStack = stacks(i, lengths(i) - 1)
    lengths(i) = lengths(i) - 1
END FUNCTION

SUB PushStack (i, x)
    length = lengths(i)
    IF length = MaxSize THEN
        ERROR 80
    END IF
    stacks(i, length) = x
    lengths(i) = length + 1
END SUB

SUB Reverse (i)
    length = lengths(i)
    m = (length - 1) \ 2
    FOR j = 0 TO m
        SWAP stacks(i, j), stacks(i, length - j - 1)
    NEXT
END SUB

FUNCTION SplitBy (s$, c$, ps$())
    posFrom = 1
    sLen = LEN(s$)
    i = 0
    DO WHILE posFrom <= sLen
        posTo = INSTR(posFrom, s$, c$)
        IF posTo = 0 THEN
            posTo = sLen + 1
        END IF
        IF posTo <> posFrom THEN
            part$ = MID$(s$, posFrom, posTo - posFrom)
            ps$(i) = part$
            i = i + 1
        END IF
        posFrom = posTo + 1
    LOOP
    SplitBy = i
END FUNCTION

