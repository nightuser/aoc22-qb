DEFINT A-Z
DECLARE FUNCTION GetReachable (x, y)
DECLARE SUB SetReachable (x, y)
DECLARE SUB SetGrid (grid(), x, y)
DECLARE FUNCTION GetGrid (grid(), x, y)
DECLARE SUB InitGrid (grid(), rshape, top, dirPos)
DECLARE FUNCTION DoStep$ (grid(), rshape, top, dirPos, skipProfile)
DECLARE SUB QueuePush (x, y)
DECLARE SUB QueuePop (x, y)
DECLARE FUNCTION QueueEmpty ()
DECLARE SUB PlaceRock (grid(), rshape, rx, ry)
DECLARE FUNCTION CanMove (grid(), rshape, rx, ry, dx, dy)
DECLARE FUNCTION GetDir (dirPos)

CONST GridWidth = 7
CONST MaxHeight = 10000
CONST MaxProfileHeight = 100

TYPE PointT
    x AS INTEGER
    y AS INTEGER
END TYPE

REDIM SHARED grid1(1 TO MaxHeight)
REDIM SHARED grid2(1 TO MaxHeight)

DIM SHARED shape(4, 3, 3)
DIM SHARED shapeW(4)
DIM SHARED shapeH(4)

' ####
shape(0, 0, 0) = -1
shape(0, 1, 0) = -1
shape(0, 2, 0) = -1
shape(0, 3, 0) = -1
shapeW(0) = 4
shapeH(0) = 1

' .#.
' ###
' .#.
shape(1, 1, 2) = -1
shape(1, 0, 1) = -1
shape(1, 1, 1) = -1
shape(1, 2, 1) = -1
shape(1, 1, 0) = -1
shapeW(1) = 3
shapeH(1) = 3

' ..#
' ..#
' ###
shape(2, 2, 2) = -1
shape(2, 2, 1) = -1
shape(2, 0, 0) = -1
shape(2, 1, 0) = -1
shape(2, 2, 0) = -1
shapeW(2) = 3
shapeH(2) = 3

' #
' #
' #
' #
shape(3, 0, 3) = -1
shape(3, 0, 2) = -1
shape(3, 0, 1) = -1
shape(3, 0, 0) = -1
shapeW(3) = 1
shapeH(3) = 4

' ##
' ##
shape(4, 0, 1) = -1
shape(4, 1, 1) = -1
shape(4, 0, 0) = -1
shape(4, 1, 0) = -1
shapeW(4) = 2
shapeH(4) = 2

DIM SHARED shift(1 TO GridWidth)
pow = 1
FOR i = 1 TO GridWidth
    shift(i) = pow
    pow = 2 * pow
NEXT

DIM SHARED dirs AS STRING
DIM SHARED dirsLen

OPEN "in.txt" FOR INPUT AS #1
LINE INPUT #1, dirs
CLOSE #1
dirsLen = LEN(dirs)

DIM SHARED reachable(MaxProfileHeight)
DIM SHARED queue(GridWidth * MaxProfileHeight - 1) AS PointT
DIM SHARED queueStart, queueEnd

InitGrid grid1(), rshape1, top1, dirPos1
FOR i = 1 TO 2022
    ignore$ = DoStep(grid1(), rshape1, top1, dirPos1, -1)
NEXT

PRINT "Ans1 = "; top1

ERASE grid1
REDIM SHARED grid1(1 TO MaxHeight)
InitGrid grid1(), rshape1, top1, dirPos1
InitGrid grid2(), rshape2, top2, dirPos2
DO
    prof1$ = DoStep(grid1(), rshape1, top1, dirPos1, 0)
    ignore$ = DoStep(grid2(), rshape2, top2, dirPos2, -1)
    prof2$ = DoStep(grid2(), rshape2, top2, dirPos2, 0)
    IF prof1$ = prof2$ THEN
        EXIT DO
    END IF
LOOP

ERASE grid1
REDIM SHARED grid1(1 TO MaxHeight)
InitGrid grid1(), rshape1, top1, dirPos1
mu = 0
DO
    prof1$ = DoStep(grid1(), rshape1, top1, dirPos1, 0)
    prof2$ = DoStep(grid2(), rshape2, top2, dirPos2, 0)
    IF prof1$ = prof2$ THEN
        PRINT "mu = "; mu
        EXIT DO
    END IF
    mu = mu + 1
LOOP

initH = top1

lam = 1
DO
    prof2$ = DoStep(grid1(), rshape1, top1, dirPos1, 0)
    IF prof1$ = prof2$ THEN
        PRINT "lam = "; lam
        EXIT DO
    END IF
    lam = lam + 1
LOOP

dH = top1 - initH

PRINT "(1000000000000 - "; LTRIM$(STR$(mu)); ") mod ";
PRINT LTRIM$(STR$(lam)); " = ";
INPUT "", rest

FOR i = 1 TO rest - 1
    ignore$ = DoStep(grid1(), rshape1, top1, dirPos1, -1)
NEXT

PRINT "top = "; top1
PRINT "dh = "; dH
PRINT "reps = (1000000000000 - "; LTRIM$(STR$(mu)); ") \ ";
PRINT LTRIM$(STR$(lam))


PRINT "Ans2 = top + (reps - 1) * dh"

END

FUNCTION CanMove (grid(), rshape, rx, ry, dx, dy)
    FOR x = 0 TO shapeW(rshape) - 1
        FOR y = 0 TO shapeH(rshape) - 1
            IF shape(rshape, x, y) THEN
                newX = rx + x + dx
                newY = ry + y + dy
                IF newY <= 0 THEN
                    CanMove = 0
                    EXIT FUNCTION
                END IF
                IF NOT (newX >= 1 AND newX <= GridWidth) THEN
                    CanMove = 0
                    EXIT FUNCTION
                END IF
                IF GetGrid(grid(), newX, newY) THEN
                    CanMove = 0
                    EXIT FUNCTION
                END IF
            END IF
        NEXT
    NEXT
    CanMove = -1
END FUNCTION

FUNCTION DoStep$ (grid(), rshape, top, dirPos, skipProfile)
    rx = 3
    ry = top + 4

    DO
        dir = GetDir(dirPos)
        IF CanMove(grid(), rshape, rx, ry, dir, 0) THEN
            rx = rx + dir
        END IF
        IF NOT CanMove(grid(), rshape, rx, ry, 0, -1) THEN
            PlaceRock grid(), rshape, rx, ry
            EXIT DO
        END IF
        ry = ry - 1
    LOOP

    rtop = ry + shapeH(rshape) - 1
    IF rtop > top THEN
        top = rtop
    END IF

    IF NOT skipProfile THEN
        DIM profile AS STRING * 100
    queueStart = 0
    queueEnd = 0
    ERASE reachable
    QueuePush 1, 0
    SetReachable 1, 0
    DO WHILE NOT QueueEmpty
        QueuePop x, dy
        y = top + 1 - dy
        IF x > 1 THEN
            IF NOT GetGrid(grid(), x - 1, y) AND NOT GetReachable(x - 1, dy) THEN
                SetReachable x - 1, dy
                QueuePush x - 1, dy
            END IF
        END IF
        IF x < GridWidth THEN
            IF NOT GetGrid(grid(), x + 1, y) AND NOT GetReachable(x + 1, dy) THEN
                SetReachable x + 1, dy
                QueuePush x + 1, dy
            END IF
        END IF
        IF y > 1 THEN
            IF NOT GetGrid(grid(), x, y - 1) AND NOT GetReachable(x, dy + 1) THEN
                SetReachable x, dy + 1
                QueuePush x, dy + 1
            END IF
        END IF
    LOOP

    profile = SPACE$(MaxProfileLen)
    FOR dy = 1 TO MaxProfileHeight - 1
        res = 0
        pow = 1
        FOR x = 1 TO GridWidth
            IF GetReachable(x, dy) THEN
                res = res + pow
            END IF
            pow = 2 * pow
        NEXT
        IF res = 0 THEN
            EXIT FOR
        END IF
        MID$(profile$, dy, 1) = CHR$(res)
    NEXT
    END IF

    rshape = rshape + 1
    IF rshape = 5 THEN
        rshape = 0
    END IF

    DoStep$ = profile
END FUNCTION

FUNCTION GetDir (dirPos)
    dir$ = MID$(dirs, dirPos, 1)
    dirPos = dirPos + 1
    IF dirPos > dirsLen THEN
        dirPos = 1
    END IF
    IF dir$ = ">" THEN
        GetDir = 1
    ELSE
        GetDir = -1
    END IF
END FUNCTION

FUNCTION GetGrid (grid(), x, y)
    GetGrid = ((grid(y) AND shift(x)) <> 0)
END FUNCTION

FUNCTION GetReachable (x, y)
    GetReachable = ((reachable(y) AND shift(x)) <> 0)
END FUNCTION

SUB InitGrid (grid(), rshape, top, dirPos)
    rshape = 0
    top = 0
    dirPos = 1
END SUB

SUB PlaceRock (grid(), rshape, rx, ry)
    FOR x = 0 TO shapeW(rshape) - 1
        FOR y = 0 TO shapeH(rshape) - 1
            IF shape(rshape, x, y) THEN
                SetGrid grid(), rx + x, ry + y
            END IF
        NEXT
    NEXT
END SUB

FUNCTION QueueEmpty
    QueueEmpty = (queueStart = queueEnd)
END FUNCTION

SUB QueuePop (x, y)
    x = queue(queueStart).x
    y = queue(queueStart).y
    queueStart = queueStart + 1
END SUB

SUB QueuePush (x, y)
    queue(queueEnd).x = x
    queue(queueEnd).y = y
    queueEnd = queueEnd + 1
END SUB

SUB SetGrid (grid(), x, y)
    grid(y) = grid(y) OR shift(x)
END SUB

SUB SetReachable (x, y)
    reachable(y) = reachable(y) OR shift(x)
END SUB

