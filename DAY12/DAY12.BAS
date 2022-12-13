DEFINT A-Z

CONST MaxSizeX = 95
CONST MaxSizeY = 41
CONST Inf = 32767

TYPE Position
    x AS INTEGER
    y AS INTEGER
END TYPE

DECLARE SUB AddEdge (x1, y1, x2, y2)
DECLARE SUB ProcessEdge (x1, y1, x2, y2)
DECLARE FUNCTION GetHeight (c$)
DECLARE FUNCTION GetDir (dx, dy)
DECLARE SUB QueuePush (x, y)
DECLARE SUB QueuePop (cur AS Position)
DECLARE FUNCTION QueueEmpty ()

DIM SHARED map(MaxSizeX - 1, MaxSizeY - 1)
DIM SHARED neighbor(MaxSizeX - 1, MaxSizeY - 1, 3)

DIM dirToDX(3)
dirToDX(2) = -1
dirToDX(3) = 1
DIM dirToDY(3)
dirToDY(0) = -1
dirToDY(1) = 1

j = 0
OPEN "in.txt" FOR INPUT AS #1
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    w = LEN(ln$)
    FOR i = 0 TO w - 1
        c$ = MID$(ln$, i + 1, 1)
        SELECT CASE c$
            CASE "S"
                map(i, j) = GetHeight("a")
                sx = i
                sy = j
            CASE "E"
                map(i, j) = GetHeight("z")
                ex = i
                ey = j
            CASE ELSE
                map(i, j) = GetHeight(c$)
        END SELECT
        IF i > 0 THEN
            ProcessEdge i - 1, j, i, j
        END IF
        IF j > 0 THEN
            ProcessEdge i, j - 1, i, j
        END IF
    NEXT
    j = j + 1
LOOP
CLOSE #1
h = j

REDIM SHARED queue(w * h - 1) AS Position
DIM SHARED queueStart, queueEnd
REDIM visited(w - 1, h - 1)
REDIM dist(w - 1, h - 1)
FOR x = 0 TO w - 1
    FOR y = 0 TO h - 1
        dist(x, y) = Inf
    NEXT
NEXT
QueuePush ex, ey
dist(ex, ey) = 0

ans2 = -1

DIM cur AS Position
DO WHILE NOT QueueEmpty
    QueuePop cur
    FOR dir = 0 TO 3
        IF neighbor(cur.x, cur.y, dir) THEN
            dx = dirToDX(dir)
            dy = dirToDY(dir)
            x = cur.x + dx
            y = cur.y + dy
            IF dist(x, y) = Inf THEN
                dist(x, y) = dist(cur.x, cur.y) + 1
                IF ans2 = -1 AND map(x, y) = 0 THEN
                    ans2 = dist(x, y)
                END IF
                IF x = sx AND y = sy THEN
                    EXIT DO
                END IF
                QueuePush x, y
            END IF
        END IF
    NEXT
LOOP

PRINT "Ans1 = "; dist(sx, sy)
PRINT "Ans2 = "; ans2

END

SUB AddEdge (x1, y1, x2, y2)
    dx = x2 - x1
    dy = y2 - y1
    neighbor(x1, y1, GetDir(dx, dy)) = -1
END SUB

FUNCTION GetDir (dx, dy)
    IF dx = 0 THEN
        res = (dy + 1) \ 2
    ELSE
        res = 2 + (dx + 1) \ 2
    END IF
    GetDir = res
END FUNCTION

FUNCTION GetHeight (c$)
    GetHeight = ASC(c$) - ASC("a")
END FUNCTION

SUB ProcessEdge (x1, y1, x2, y2)
    dh = map(x2, y2) - map(x1, y1)
    IF dh <= 1 THEN
        AddEdge x2, y2, x1, y1
    END IF
    IF dh >= -1 THEN
        AddEdge x1, y1, x2, y2
    END IF
END SUB

FUNCTION QueueEmpty
    QueueEmpty = (queueStart = queueEnd)
END FUNCTION

SUB QueuePop (cur AS Position)
    cur.x = queue(queueStart).x
    cur.y = queue(queueStart).y
    queueStart = queueStart + 1
END SUB

SUB QueuePush (x, y)
    queue(queueEnd).x = x
    queue(queueEnd).y = y
    queueEnd = queueEnd + 1
END SUB

