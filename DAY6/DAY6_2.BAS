DEFINT A-Z

CONST markerLen = 14

CR$ = CHR$(13)
LF$ = CHR$(10)

DIM count(25) AS INTEGER
' $STATIC
DIM last(markerLen - 1) AS INTEGER
lastPos = 0

OPEN "in.txt" FOR INPUT AS #1
uniq = 0
i = 0
DO WHILE NOT EOF(1)
    i = i + 1
    c$ = INPUT$(1, #1)
    IF c$ = CR$ OR c$ = LF$ THEN
        PRINT "Marker not found"
        END
    END IF
    IF i > markerLen THEN
        y = last(lastPos)
        count(y) = count(y) - 1
        IF count(y) = 0 THEN
            uniq = uniq - 1
        END IF
    END IF
    x = ASC(c$) - ASC("a")
    count(x) = count(x) + 1
    IF count(x) = 1 THEN
        uniq = uniq + 1
    END IF
    last(lastPos) = x
    lastPos = (lastPos + 1) MOD markerLen
    IF uniq = markerLen THEN
        ans = i
        EXIT DO
    END IF
LOOP
CLOSE #1
PRINT "Ans2 = "; ans

END

