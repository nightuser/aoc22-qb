DEFINT A-Z

CONST MaxMonkeys = 8
CONST MaxItems = 50

CONST TotalRounds = 20

CONST Variable = -32768

TYPE Operation
    op AS STRING * 1
    lhs AS INTEGER
    rhs AS INTEGER
END TYPE

TYPE Monkey
    test AS INTEGER
    f AS Operation
    ifT AS INTEGER
    ifF AS INTEGER
END TYPE

DECLARE SUB AddItem (i, x&)
DECLARE FUNCTION Apply& (f AS Operation, x&)
DECLARE FUNCTION GetValue& (y, x&)
DECLARE FUNCTION ParseOperand (s$)
DECLARE FUNCTION SplitBy (s$, c$, ps$())

DIM SHARED mks(MaxMonkeys - 1) AS Monkey
DIM SHARED items(MaxMonkeys - 1, MaxItems - 1) AS LONG
DIM SHARED itemsCnt(MaxMonkeys - 1) AS INTEGER
DIM inspections(MaxMonkeys - 1) AS INTEGER

OPEN "in.txt" FOR INPUT AS #1
i = 0
REDIM ps$(MaxItems - 1)
DO WHILE NOT EOF(1)
    DO
        LINE INPUT #1, ln$
    LOOP WHILE ln$ = ""
    LINE INPUT #1, ln$
    curItems$ = RIGHT$(ln$, LEN(ln$) - 17)
    n = SplitBy(curItems$, ",", ps$())
    FOR j = 0 TO n - 1
        items(i, j) = VAL(ps$(j))
    NEXT
    itemsCnt(i) = n
    LINE INPUT #1, ln$
    op$ = RIGHT$(ln$, LEN(ln$) - 18)
    n = SplitBy(op$, " ", ps$())
    mks(i).f.op = ps$(1)
    mks(i).f.lhs = ParseOperand(ps$(0))
    mks(i).f.rhs = ParseOperand(ps$(2))
    LINE INPUT #1, ln$
    test$ = RIGHT$(ln$, LEN(ln$) - 21)
    mks(i).test = VAL(test$)
    LINE INPUT #1, ln$
    ifT$ = RIGHT$(ln$, LEN(ln$) - 29)
    mks(i).ifT = VAL(ifT$)
    LINE INPUT #1, ln$
    ifF$ = RIGHT$(ln$, LEN(ln$) - 30)
    mks(i).ifF = VAL(ifF$)
    i = i + 1
LOOP
totalMonkeys = i
ERASE ps$
CLOSE #1

DIM worry AS LONG
FOR round = 1 TO TotalRounds
    FOR i = 0 TO totalMonkeys - 1
        FOR j = 0 TO itemsCnt(i) - 1
            worry = items(i, j)
            worry = Apply&(mks(i).f, worry)
            worry = worry \ 3
            IF worry MOD mks(i).test = 0 THEN
                rec = mks(i).ifT
            ELSE
                rec = mks(i).ifF
            END IF
            AddItem rec, worry
        NEXT
        inspections(i) = inspections(i) + itemsCnt(i)
        itemsCnt(i) = 0
    NEXT
NEXT

FOR i = 0 TO totalMonkeys - 1
    x = inspections(i)
    IF x >= top1 THEN
        top2 = top1
        top1 = x
    ELSEIF x > top2 THEN
        top2 = x
    END IF
NEXT

ans1& = 1& * top1 * top2
PRINT "Ans1 = "; ans1&

END

SUB AddItem (i, x&)
    cnt = itemsCnt(i)
    items(i, cnt) = x&
    itemsCnt(i) = cnt + 1
END SUB

FUNCTION Apply& (f AS Operation, x&)
    lhs& = GetValue&(f.lhs, x&)
    rhs& = GetValue&(f.rhs, x&)
    IF f.op = "*" THEN
        res& = lhs& * rhs&
    ELSEIF f.op = "+" THEN
        res& = lhs& + rhs&
    END IF
    Apply& = res&
END FUNCTION

FUNCTION GetValue& (y, x&)
    IF y = Variable THEN
        res& = x&
    ELSE
        res& = y
    END IF
    GetValue& = res&
END FUNCTION

FUNCTION ParseOperand (s$)
    IF s$ = "old" THEN
        res = Variable
    ELSE
        res = VAL(s$)
    END IF
    ParseOperand = res
END FUNCTION

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

