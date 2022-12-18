DEFINT A-Z

CONST MaxSize = 20
CONST MaxPoints = 2500

TYPE PointT
    x AS INTEGER
    y AS INTEGER
    z AS INTEGER
END TYPE

DECLARE FUNCTION IsInCube (x, y, z)
DECLARE SUB QueuePush (x, y, z)
DECLARE SUB QueuePop (p AS PointT)
DECLARE FUNCTION QueueEmpty ()
DECLARE FUNCTION SplitBy (s$, c$, ps$())

REDIM SHARED grid(MaxSize - 1, MaxSize - 1, MaxSize - 1) AS INTEGER
REDIM SHARED vis(MaxSize - 1, MaxSize - 1, MaxSize - 1) AS INTEGER
REDIM points(MaxPoints - 1) AS PointT
DIM pointsLen AS INTEGER
REDIM SHARED queue(MaxSize * MaxSize * MaxSize) AS PointT
DIM SHARED queueStart, queueEnd

DIM borders(1)
borders(0) = 0
borders(1) = MaxSize - 1

DIM SHARED dirs(5) AS PointT
dirs(0).x = -1
dirs(1).x = 1
dirs(2).y = -1
dirs(3).y = 1
dirs(4).z = -1
dirs(5).z = 1

DIM ps$(2)
i = 0
OPEN "in.txt" FOR INPUT AS #1
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    n = SplitBy(ln$, ",", ps$())
    points(i).x = VAL(ps$(0))
    points(i).y = VAL(ps$(1))
    points(i).z = VAL(ps$(2))
    grid(points(i).x, points(i).y, points(i).z) = -1
    i = i + 1
LOOP
CLOSE #1
totalPoints = i

FOR i = 0 TO 1
    x = borders(i)
    FOR j = 0 TO 1
        y = borders(j)
        FOR k = 0 TO 1
            z = borders(k)
            QueuePush x, y, z
            vis(x, y, z) = -1
        NEXT
    NEXT
NEXT
DIM cur AS PointT
DO WHILE NOT QueueEmpty
    QueuePop cur
    FOR j = 0 TO 5
        x1 = cur.x + dirs(j).x
        y1 = cur.y + dirs(j).y
        z1 = cur.z + dirs(j).z
        IF IsInCube(x1, y1, z1) THEN
            IF NOT grid(x1, y1, z1) THEN
                IF NOT vis(x1, y1, z1) THEN
                    vis(x1, y1, z1) = -1
                    QueuePush x1, y1, z1
                END IF
            END IF
        END IF
    NEXT
LOOP

FOR i = 0 TO totalPoints - 1
    x = points(i).x
    y = points(i).y
    z = points(i).z
    FOR j = 0 TO 5
        x1 = x + dirs(j).x
        y1 = y + dirs(j).y
        z1 = z + dirs(j).z
        IF NOT IsInCube(x1, y1, z1) THEN
            ans1 = ans1 + 1
            ans2 = ans2 + 1
        ELSEIF NOT grid(x1, y1, z1) THEN
            ans1 = ans1 + 1
            IF vis(x1, y1, z1) THEN
                ans2 = ans2 + 1
            END IF
        END IF
    NEXT
NEXT

PRINT "Ans1 = "; ans1
PRINT "Ans2 = "; ans2

END

FUNCTION IsInCube (x, y, z)
    isInX = (x >= 0) AND (x < MaxSize)
    isInY = (y >= 0) AND (y < MaxSize)
    isInZ = (z >= 0) AND (z < MaxSize)
    IsInCube = isInX AND isInY AND isInZ
END FUNCTION

FUNCTION QueueEmpty
    QueueEmpty = (queueStart = queueEnd)
END FUNCTION

SUB QueuePop (p AS PointT)
    p.x = queue(queueStart).x
    p.y = queue(queueStart).y
    p.z = queue(queueStart).z
    queueStart = queueStart + 1
END SUB

SUB QueuePush (x, y, z)
    queue(queueEnd).x = x
    queue(queueEnd).y = y
    queue(queueEnd).z = z
    queueEnd = queueEnd + 1
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
        posFrom = posTo + LEN(c$)
    LOOP
    SplitBy = i
END FUNCTION

