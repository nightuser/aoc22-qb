DECLARE FUNCTION GetIndex% (x%, y%)
DECLARE FUNCTION GetPoint% (x%, y%)
DECLARE SUB SetPoint (x%, y%, v%)
DEFINT A-Z

CONST MaxSize = 32766

CONST DirStop = 0
CONST DirD = 1
CONST DirDL = 2
CONST DirDR = 3

TYPE PointT
    x AS INTEGER
    y AS INTEGER
END TYPE

DECLARE FUNCTION GetDir (x, y, floor)
DECLARE SUB DrawLine (pFrom AS PointT, pTo AS PointT)
DECLARE FUNCTION SplitBy (s$, c$, ps$())

DIM SHARED map(0 TO MaxSize - 1)
DIM SHARED sx, sy
sx = 500
sy = 0

CLS

DIM ps$(30), coord$(1)
OPEN "in.txt" FOR INPUT AS #1
maxX = -32768
minX = 32767
maxY = -32768
minY = 32767
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    n = SplitBy(ln$, " -> ", ps$())
    REDIM points(n - 1) AS PointT
    FOR i = 0 TO n - 1
        m = SplitBy(ps$(i), ",", coord$())
        x = VAL(coord$(0))
        y = VAL(coord$(1))
        points(i).x = x
        points(i).y = y
        ' PRINT x; ";"; y; " ";
        IF x > maxX THEN
            maxX = x
        END IF
        IF x < minX THEN
            minX = x
        END IF
        IF y > maxY THEN
            maxY = y
        END IF
        IF y < minY THEN
            minY = y
        END IF
    NEXT
    FOR i = 0 TO n - 2
        DrawLine points(i), points(i + 1)
    NEXT
    ERASE points
    ' PRINT
LOOP
CLOSE #1

'PRINT minX; maxX
'PRINT minY; maxY

floor = maxY + 2

ans1 = 0
ans1Complete = 0
ans2 = 0
DO
    x = sx
    y = sy
    DO
        dir = GetDir(x, y, floor)
        SELECT CASE dir
            CASE DirStop
                EXIT DO
            CASE DirD
                y = y + 1
            CASE DirDL
                x = x - 1
                y = y + 1
            CASE DirDR
                x = x + 1
                y = y + 1
        END SELECT
    LOOP
    IF y = floor - 1 THEN
        ans1Complete = -1
    END IF
    IF ans1Complete THEN
        SetPoint x, y, 3
    ELSE
        SetPoint x, y, 2
        ans1 = ans1 + 1
    END IF
    ans2 = ans2 + 1
    IF x > maxX THEN
        maxX = x
    END IF
    IF x < minX THEN
        minX = x
    END IF
    IF y > maxY THEN
        maxY = y
    END IF
    IF y < minY THEN
        minY = y
    END IF
LOOP UNTIL y = sy

FOR y = 0 TO maxY
    FOR x = minX TO maxX
        v = GetPoint(x, y)
        IF v = 1 THEN
            PRINT "#";
        ELSEIF v = 2 THEN
            PRINT "o";
        ELSEIF v = 3 THEN
            PRINT "*";
        ELSE
            PRINT ".";
        END IF
    NEXT
    PRINT
NEXT

PRINT "Ans1 = "; ans1
PRINT "Ans2 = "; ans2

END

SUB DrawLine (pFrom AS PointT, pTo AS PointT)
    IF pFrom.x = pTo.x THEN
        FOR y = pFrom.y TO pTo.y STEP SGN(pTo.y - pFrom.y)
            'PRINT pFrom.x; y
            SetPoint pFrom.x, y, 1
        NEXT
    ELSE
        FOR x = pFrom.x TO pTo.x STEP SGN(pTo.x - pFrom.x)
            'PRINT x; pFrom.y
            SetPoint x, pFrom.y, 1
        NEXT
    END IF
END SUB

FUNCTION GetDir (x, y, floor)
    IF y + 1 = floor THEN
        dir = DirStop
    ELSEIF GetPoint(x, y + 1) = 0 THEN
        dir = DirD
    ELSEIF GetPoint(x - 1, y + 1) = 0 THEN
        dir = DirDL
    ELSEIF GetPoint(x + 1, y + 1) = 0 THEN
        dir = DirDR
    ELSE
        dir = DirStop
    END IF
    GetDir = dir
END FUNCTION

FUNCTION GetIndex (x, y)
    lx = sx - y
    rx = sx + y
    IF x < lx OR x > rx THEN
        index = -1
    ELSE
        before = y * y
        index = before + (x - lx)
    END IF
    GetIndex = index
END FUNCTION

FUNCTION GetPoint (x, y)
    index = GetIndex(x, y)
    IF index = -1 THEN
        GetPoint = 0
    ELSE
        GetPoint = map(index)
    END IF
END FUNCTION

SUB SetPoint (x, y, v)
    index = GetIndex(x, y)
    map(index) = v
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

