DEFINT A-Z

DECLARE FUNCTION Compare (id1, id2)
DECLARE FUNCTION CompareNumList (id1, cur2)
DECLARE FUNCTION ToStr$ (id)
DECLARE FUNCTION MakeNode (t, value, nxt)
DECLARE FUNCTION MakeNumNode (num)
DECLARE FUNCTION MakeListNode ()
DECLARE FUNCTION Parse (s$, start, id)
DECLARE FUNCTION ParseNum (s$, start, id)
DECLARE FUNCTION ParseList (s$, start, id)
DECLARE FUNCTION GetChar$ (s$, i)
DECLARE FUNCTION IsDigit (c$)
DECLARE SUB AddPacket (id)
DECLARE SUB SortPackets (l, r)
DECLARE FUNCTION PartitionPackets (l, r)

CONST MaxSize = 20000

CONST NodeNum = 0
CONST NodeList = 1

REDIM SHARED nodesT(1 TO MaxSize)
REDIM SHARED nodesVal(1 TO MaxSize)
REDIM SHARED nodesNxt(1 TO MaxSize)
DIM SHARED nodesLen

DIM SHARED packets(350)
DIM SHARED PacketsLen

RANDOMIZE TIMER

n1 = Parse("[[2]]", 1, div1)
AddPacket div1
n2 = Parse("[[6]]", 1, div2)
AddPacket div2

ans1 = 0
index = 1
OPEN "in.txt" FOR INPUT AS #1
DO WHILE NOT EOF(1)
    DO
        LINE INPUT #1, ln1$
    LOOP WHILE LEN(ln1$) = 0
    n1 = Parse(ln1$, 1, id1)
    AddPacket id1
    LINE INPUT #1, ln2$
    n2 = Parse(ln2$, 1, id2)
    AddPacket id2
    res = Compare(id1, id2)
    IF res <= 0 THEN
        ans1 = ans1 + index
    END IF
    index = index + 1
LOOP
CLOSE #1

PRINT "Ans1 = "; ans1

SortPackets 0, PacketsLen - 1

ans2 = 1
FOR i = 0 TO PacketsLen - 1
    packet = packets(i)
    ' PRINT ToStr$(packet)
    IF packet = div1 OR packet = div2 THEN
        ans2 = ans2 * (i + 1)
    END IF
NEXT

PRINT "Ans2 = "; ans2

END

SUB AddPacket (id)
    packets(PacketsLen) = id
    PacketsLen = PacketsLen + 1
END SUB

FUNCTION Compare (id1, id2)
    t1 = nodesT(id1)
    t2 = nodesT(id2)
    cur1 = nodesVal(id1)
    cur2 = nodesVal(id2)
    IF t1 = t2 THEN
        IF t1 = NodeNum THEN
            res = SGN(cur1 - cur2)
        ELSE
            DO WHILE cur1 <> 0 AND cur2 <> 0
                res = Compare(cur1, cur2)
                IF res <> 0 THEN
                    EXIT DO
                END IF
                cur1 = nodesNxt(cur1)
                cur2 = nodesNxt(cur2)
            LOOP
            IF res = 0 THEN
                IF cur1 = 0 AND cur2 <> 0 THEN
                    res = -1
                ELSEIF cur1 <> 0 AND cur2 = 0 THEN
                    res = 1
                END IF
            END IF
        END IF
    ELSEIF t1 = NodeNum THEN
        res = CompareNumList(id1, cur2)
    ELSE
        res = -CompareNumList(id2, cur1)
    END IF
    Compare = res
END FUNCTION

FUNCTION CompareNumList (id1, cur2)
    IF cur2 = 0 THEN
        res = 1
    ELSE
        res = Compare(id1, cur2)
        IF res = 0 AND nodesNxt(cur2) <> 0 THEN
            res = -1
        END IF
    END IF
    CompareNumList = res
END FUNCTION

FUNCTION GetChar$ (s$, i)
    GetChar$ = MID$(s$, i, 1)
    i = i + 1
END FUNCTION

FUNCTION IsDigit (c$)
    a = ASC(c$)
    IsDigit = (a >= ASC("0") AND a <= ASC("9"))
END FUNCTION

FUNCTION MakeListNode
    MakeListNode = MakeNode(NodeList, 0, 0)
END FUNCTION

FUNCTION MakeNode (t, value, nxt)
    nodesLen = nodesLen + 1
    id = nodesLen
    nodesT(id) = t
    nodesVal(id) = value
    nodesNxt(id) = nxt
    MakeNode = id
END FUNCTION

FUNCTION MakeNumNode (num)
    MakeNumNode = MakeNode(NodeNum, num, 0)
END FUNCTION

FUNCTION Parse (s$, start, id)
    i = ParseList(s$, start, id)
    IF i = start THEN
        i = ParseNum(s$, start, id)
    END IF
    Parse = i
END FUNCTION

FUNCTION ParseList (s$, start, id)
    i = start
    c$ = GetChar$(s$, i)
    IF c$ <> "[" THEN
        ParseList = start
        EXIT FUNCTION
    END IF
    id = MakeListNode
    childID = 0
    DO
        oldI = i
        lastID = childID
        i = Parse(s$, i, childID)
        IF i > oldI THEN
            IF lastID = 0 THEN
                nodesVal(id) = childID
            ELSE
                nodesNxt(lastID) = childID
            END IF
        END IF
        c$ = GetChar$(s$, i)
        IF c$ = "]" THEN
            EXIT DO
        ELSEIF c$ <> "," THEN
            PRINT "Comma expected"
            SYSTEM
        END IF
    LOOP
    ParseList = i
END FUNCTION

FUNCTION ParseNum (s$, start, id)
    i = start
    length = LEN(s$)
    DO WHILE i <= length
        IF NOT IsDigit(GetChar$(s$, i)) THEN
            i = i - 1
            EXIT DO
        END IF
    LOOP
    num = VAL(MID$(s$, start, i - start))
    id = MakeNumNode(num)
    ParseNum = i
END FUNCTION

FUNCTION PartitionPackets (l, r)
    m = INT(RND * (r - l + 1)) + l
    SWAP packets(m), packets(r)
    position = l
    pivot = packets(r)
    FOR i = l TO r - 1
        IF Compare(packets(i), pivot) < 0 THEN
            SWAP packets(i), packets(position)
            position = position + 1
        END IF
    NEXT
    SWAP packets(position), packets(r)
    PartitionPackets = position
END FUNCTION

SUB SortPackets (l, r)
    IF l < r THEN
        m = PartitionPackets(l, r)
        SortPackets l, m - 1
        SortPackets m + 1, r
    END IF
END SUB

FUNCTION ToStr$ (id)
    t = nodesT(id)
    IF t = NodeNum THEN
        res$ = LTRIM$(STR$(nodesVal(id)))
    ELSE
        res$ = "["
        cur = nodesVal(id)
        DO WHILE cur <> 0
            res$ = res$ + ToStr$(cur)
            cur = nodesNxt(cur)
            IF cur <> 0 THEN
                res$ = res$ + ","
            END IF
        LOOP
        res$ = res$ + "]"
    END IF
    ToStr$ = res$
END FUNCTION

