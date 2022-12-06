DEFINT A-Z

CONST markerLen = 14

DECLARE FUNCTION GetSymbol (fileNum, i)

DIM count(25) AS INTEGER
' $STATIC
DIM last(markerLen - 1) AS INTEGER
lastPos = 0

OPEN "in.txt" FOR BINARY AS #1
uniq = 0
FOR i = 1 TO LOF(1) - 2
    x = GetSymbol(1, i)
    IF i > markerLen THEN
        y = last(lastPos)
        count(y) = count(y) - 1
        IF count(y) = 0 THEN
            uniq = uniq - 1
        END IF
    END IF
    count(x) = count(x) + 1
    IF count(x) = 1 THEN
        uniq = uniq + 1
    END IF
    last(lastPos) = x
    lastPos = (lastPos + 1) MOD markerLen
    IF uniq = markerLen THEN
        ans = i
        EXIT FOR
    END IF
NEXT
CLOSE #1
PRINT "Ans2 = "; ans

END

FUNCTION GetSymbol (fileNum, i)
    STATIC c AS STRING * 1
    GET #fileNum, i, c
    GetSymbol = ASC(c) - ASC("a")
END FUNCTION

