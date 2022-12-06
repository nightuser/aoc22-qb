DEFINT A-Z
DECLARE FUNCTION GetSymbol (fileNum, i)

CLS

DIM count(25) AS INTEGER

markerLen = 14

OPEN "in.txt" FOR RANDOM AS #1 LEN = 1
uniq = 0
FOR i = 1 TO LOF(1) - 2
    x = GetSymbol(1, i)
    IF i > markerLen THEN
        y = GetSymbol(1, i - markerLen)
        count(y) = count(y) - 1
        IF count(y) = 0 THEN
            uniq = uniq - 1
        END IF
    END IF
    count(x) = count(x) + 1
    IF count(x) = 1 THEN
        uniq = uniq + 1
    END IF
    IF uniq = markerLen THEN
        ans = i
        EXIT FOR
    END IF
NEXT
CLOSE #1
PRINT "Ans1 = "; ans

END

FUNCTION GetSymbol (fileNum, i)
    STATIC c AS STRING * 1
    GET #fileNum, i, c
    GetSymbol = ASC(c) - ASC("a")
END FUNCTION

