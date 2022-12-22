DEFINT A-Z
DECLARE SUB MoveForward (p, x)
DECLARE FUNCTION GetNxt (i)
DECLARE FUNCTION GetAfter (i, shift)

CONST MaxSize = 5000
CONST DecKey = 811589153

DIM SHARED xs(MaxSize - 1)
DIM SHARED positions(MaxSize - 1)
DIM SHARED inverse(MaxSize - 1)
DIM SHARED size

i = 0
OPEN "in.txt" FOR INPUT AS #1
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    x = VAL(ln$)
    xs(i) = x
    positions(i) = i
    inverse(i) = i
    IF x = 0 THEN
        zeroPos = i
    END IF
    i = i + 1
LOOP
size = i

smallKey& = DecKey MOD (size - 1)

FOR cnt = 1 TO 10
    FOR i = 0 TO size - 1
        ' PRINT cnt; ": "; (i + 1); " / "; size
        p = inverse(i)
        dir = SGN(xs(i))
        shift& = (ABS(xs(i)) MOD (size - 1)) * smallKey&
        shift = shift& MOD (size - 1)
        IF dir > 0 THEN
            MoveForward p, shift
        ELSEIF dir < 0 THEN
            MoveForward p, size - 1 - shift
        END IF
    NEXT
NEXT

num1000 = GetAfter(zeroPos, 1000)
num2000 = GetAfter(zeroPos, 2000)
num3000 = GetAfter(zeroPos, 3000)
ans2 = num1000 + num2000 + num3000
PRINT "Ans2 = "; ans2 * 1# * DecKey

END

FUNCTION GetAfter (i, shift)
    p = inverse(i)
    q = (p + shift) MOD size
    GetAfter = xs(positions(q))
END FUNCTION

FUNCTION GetNxt (i)
    res = (i + 1) MOD size
    GetNxt = res
END FUNCTION

SUB MoveForward (p, x)
    shift = x MOD (size - 1)
    cur = p
    nxt = GetNxt(cur)
    DO WHILE shift > 0
        SWAP positions(cur), positions(nxt)
        inverse(positions(cur)) = cur
        inverse(positions(nxt)) = nxt
        cur = nxt
        nxt = GetNxt(cur)
        shift = shift - 1
    LOOP
END SUB

