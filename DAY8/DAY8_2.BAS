DEFINT A-Z

CONST MaxSize = 99

TYPE Entry
    value AS INTEGER
    index AS INTEGER
END TYPE

DECLARE SUB UpdateScenicScore (j, i, index)
DECLARE SUB StackPush (value, index)
DECLARE SUB StackPop ()
DECLARE SUB StackClear ()
DECLARE FUNCTION StackPeekValue ()
DECLARE FUNCTION StackPeekIndex ()
DECLARE FUNCTION StackEmpty ()

DIM SHARED map(MaxSize - 1, MaxSize - 1) AS INTEGER
DIM SHARED scenicScore(MaxSize - 1, MaxSize - 1) AS LONG
DIM SHARED stack(MaxSize - 1) AS Entry
DIM SHARED stackLength AS INTEGER
stackLength = 0

j = 0
OPEN "in.txt" FOR INPUT AS #1
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    w = LEN(ln$)
    FOR i = 0 TO w - 1
        x = VAL(MID$(ln$, i + 1, 1))
        map(j, i) = x
        scenicScore(j, i) = 1
    NEXT
    j = j + 1
LOOP
CLOSE #1
h = j

FOR j = 0 TO h - 1
    scenicScore(j, 0) = 0
    StackClear
    StackPush map(j, 0), 0
    FOR i = 1 TO w - 2
        UpdateScenicScore j, i, i
    NEXT
    scenicScore(j, w - 1) = 0
    StackClear
    StackPush map(j, w - 1), 0
    FOR i = w - 2 TO 1 STEP -1
        UpdateScenicScore j, i, w - 1 - i
    NEXT
NEXT

FOR i = 0 TO w - 1
    scenicScore(0, i) = 0
    StackClear
    StackPush map(0, i), 0
    FOR j = 1 TO h - 2
        UpdateScenicScore j, i, j
    NEXT
    scenicScore(h - 1, i) = 0
    StackClear
    StackPush map(h - 1, i), 0
    FOR j = h - 2 TO 1 STEP -1
        UpdateScenicScore j, i, h - 1 - j
    NEXT
NEXT

ans2& = -1
FOR j = 1 TO h - 2
    FOR i = 1 TO w - 2
        x& = scenicScore(j, i)
        IF x& > ans2& THEN
            ans2& = x&
        END IF
    NEXT
NEXT

PRINT "Ans2 = "; ans2&

END

SUB StackClear
    stackLength = 0
END SUB

FUNCTION StackEmpty
    StackEmpty = (stackLength <= 0)
END FUNCTION

FUNCTION StackPeekIndex
    StackPeekIndex = stack(stackLength - 1).index
END FUNCTION

FUNCTION StackPeekValue
    StackPeekValue = stack(stackLength - 1).value
END FUNCTION

SUB StackPop
    stackLength = stackLength - 1
END SUB

SUB StackPush (value, index)
    stack(stackLength).value = value
    stack(stackLength).index = index
    stackLength = stackLength + 1
END SUB

SUB UpdateScenicScore (j, i, index)
    x = map(j, i)
    DO WHILE NOT StackEmpty
        IF x <= StackPeekValue THEN
            EXIT DO
        END IF
        StackPop
    LOOP
    IF StackEmpty THEN
        visible = index
    ELSE
        visible = index - StackPeekIndex
    END IF
    StackPush x, index
    scenicScore(j, i) = scenicScore(j, i) * visible
END SUB

