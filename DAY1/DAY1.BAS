DEFINT A-Z

TYPE VectorHeader
    capacity AS INTEGER
    length AS INTEGER
END TYPE

DECLARE SUB LInitVector (header AS VectorHeader, arr() AS LONG)
DECLARE SUB LPrintVector (header AS VectorHeader, arr() AS LONG)
DECLARE SUB LPushBack (header AS VectorHeader, arr() AS LONG, el AS LONG)
DECLARE SUB LSort (header AS VectorHeader, arr() AS LONG)
DECLARE SUB LSortHelper (arr() AS LONG, l AS INTEGER, r AS INTEGER)
DECLARE FUNCTION LPartition (arr() AS LONG, l AS INTEGER, r AS INTEGER)

RANDOMIZE TIMER

DIM caloriesHeader AS VectorHeader
' $DYNAMIC
DIM calories(0) AS LONG
LInitVector caloriesHeader, calories()

DIM ans AS LONG
ans = 0
DIM current AS LONG
current = 0

OPEN "in.txt" FOR INPUT AS #1
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    IF ln$ <> "" THEN
        x& = VAL(ln$)
        current = current + x&
    ELSE
        IF current > ans THEN
            ans = current
        END IF
        LPushBack caloriesHeader, calories(), current
        current = 0
    END IF
LOOP
CLOSE #1

IF current > ans THEN
    ans = current
END IF
LPushBack caloriesHeader, calories(), current

PRINT "Task 1 answer="; ans

' LPrintVector caloriesHeader, calories()
LSort caloriesHeader, calories()
' LPrintVector caloriesHeader, calories()

DIM top3 AS LONG
top3 = 0
FOR i = caloriesHeader.length - 3 TO caloriesHeader.length - 1
    top3 = top3 + calories(i)
NEXT

PRINT "Task 2 answer="; top3

END

SUB LInitVector (header AS VectorHeader, arr() AS LONG)
    header.capacity = 2
    header.length = 0
    REDIM arr(header.capacity - 1) AS LONG
END SUB

FUNCTION LPartition (arr() AS LONG, l AS INTEGER, r AS INTEGER)
    m = INT(RND * (r - l + 1)) + l
    SWAP arr(m), arr(r)
    position = l
    DIM pivot AS LONG
    pivot = arr(r)

    FOR i = l TO r - 1
        IF arr(i) < pivot THEN
            SWAP arr(i), arr(position)
            position = position + 1
        END IF
    NEXT

    SWAP arr(position), arr(r)

    LPartition = position
END FUNCTION

SUB LPrintVector (header AS VectorHeader, arr() AS LONG)
    PRINT "<";
    FOR i = 0 TO header.length - 1
        PRINT LTRIM$(STR$(arr(i))); ",";
    NEXT
    PRINT ">"
END SUB

SUB LPushBack (header AS VectorHeader, arr() AS LONG, el AS LONG)
    IF header.length = header.capacity THEN
        ' $DYNAMIC
        DIM tmpArr(header.capacity - 1) AS LONG
        FOR i = 0 TO header.capacity - 1
            tmpArr(i) = arr(i)
        NEXT
        newCapacity = 2 * header.capacity
        REDIM arr(newCapacity - 1) AS LONG
        FOR i = 0 TO header.capacity - 1
            arr(i) = tmpArr(i)
        NEXT
        ERASE tmpArr
        header.capacity = newCapacity
    END IF
    arr(header.length) = el
    header.length = header.length + 1
END SUB

SUB LSort (header AS VectorHeader, arr() AS LONG)
    LSortHelper arr(), 0, header.length - 1
END SUB

SUB LSortHelper (arr() AS LONG, l AS INTEGER, r AS INTEGER)
    IF l < r THEN
        m = LPartition(arr(), l, r)
        LSortHelper arr(), l, m - 1
        LSortHelper arr(), m + 1, r
    END IF
END SUB

