DEFINT A-Z

CONST MaxMonkeys = 8
CONST MaxItems = 50

CONST TotalRounds = 10000

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

DECLARE SUB AddItem (i, xs())
DECLARE SUB Apply (f AS Operation, xs())
DECLARE FUNCTION GetValue (y, x)
DECLARE FUNCTION ParseOperand (s$)
DECLARE FUNCTION SplitBy (s$, c$, ps$())

DIM SHARED mks(MaxMonkeys - 1) AS Monkey
DIM SHARED items(MaxMonkeys - 1, MaxItems - 1, MaxMonkeys - 1) AS INTEGER
DIM SHARED itemsCnt(MaxMonkeys - 1) AS INTEGER
DIM inspections(MaxMonkeys - 1) AS LONG
DIM SHARED totalMonkeys AS INTEGER

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
        items(i, j, 0) = VAL(ps$(j))
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

FOR i = 0 TO totalMonkeys - 1
    FOR j = 0 TO itemsCnt(i)
        x = items(i, j, 0)
        FOR k = 0 TO totalMonkeys - 1
            items(i, j, k) = x MOD mks(k).test
        NEXT
    NEXT
NEXT

REDIM worry(totalMonkeys - 1) AS INTEGER
FOR round = 1 TO TotalRounds
    FOR i = 0 TO totalMonkeys - 1
        FOR j = 0 TO itemsCnt(i) - 1
            FOR k = 0 TO totalMonkeys - 1
                worry(k) = items(i, j, k)
            NEXT
            Apply mks(i).f, worry()
            IF worry(i) = 0 THEN
                rec = mks(i).ifT
            ELSE
                rec = mks(i).ifF
            END IF
            AddItem rec, worry()
        NEXT
        inspections(i) = inspections(i) + itemsCnt(i)
        itemsCnt(i) = 0
    NEXT
NEXT
ERASE worry

FOR i = 0 TO totalMonkeys - 1
    x& = inspections(i)
    IF x& >= top1& THEN
        top2& = top1&
        top1& = x&
    ELSEIF x& > top2& THEN
        top2& = x&
    END IF
NEXT

PRINT top1&; top2&
ans2# = 1# * top1& * top2&
PRINT "Ans2 = "; ans2#

END

SUB AddItem (i, worry())
    cnt = itemsCnt(i)
    FOR k = 0 TO totalMonkeys - 1
        items(i, cnt, k) = worry(k)
    NEXT
    itemsCnt(i) = cnt + 1
END SUB

SUB Apply (f AS Operation, xs())
    FOR k = 0 TO totalMonkeys - 1
        lhs = GetValue(f.lhs, xs(k))
        rhs = GetValue(f.rhs, xs(k))
        IF f.op = "*" THEN
            res = lhs * rhs
        ELSEIF f.op = "+" THEN
            res = lhs + rhs
        END IF
        xs(k) = res MOD mks(k).test
    NEXT
END SUB

FUNCTION GetValue (y, x)
    IF y = Variable THEN
        res = x
    ELSE
        res = y
    END IF
    GetValue = res
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

