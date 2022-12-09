DEFINT A-Z

DECLARE SUB CalculateTotalSize (dirID)
DECLARE SUB UpdateDirSize (dirID, size&)
DECLARE FUNCTION GetID (dirID, dname$)
DECLARE FUNCTION GetDirName$ (dirID)
DECLARE FUNCTION GetFullPath$ (dirID)
DECLARE FUNCTION AddDir (dname$, parent)
DECLARE FUNCTION SplitBy (s$, c$, ps$())
DECLARE SUB Sort (arr&(), l, r)
DECLARE FUNCTION Partition (arr&(), l, r)

CONST DeviceTotalSpace = 70000000
CONST ReqUnusedSpace = 30000000

TYPE DirT
    dname AS STRING * 32
    size AS LONG
    totalSize AS LONG
    parent AS INTEGER
    nxt AS INTEGER
    child AS INTEGER
END TYPE

RANDOMIZE TIMER

DIM SHARED DirsPool(255) AS DirT
DIM SHARED DirsPoolSize AS INTEGER
DIM ps$(2)
rootID = AddDir("ROOT", -1)
currentDirID = rootID

OPEN "in.txt" FOR INPUT AS #1
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    n = SplitBy(ln$, " ", ps$())
    IF ps$(0) = "$" THEN
        parseLS = 0
        cmd$ = ps$(1)
        arg$ = ps$(2)
        ' PRINT GetFullPath(currentDirID); " % "; cmd$; " "; arg$
        IF cmd$ = "cd" THEN
            IF arg$ = "/" THEN
                currentDirID = rootID
            ELSEIF arg$ = ".." THEN
                currentDirID = DirsPool(currentDirID).parent
            ELSE
                currentDirID = GetID(currentDirID, arg$)
            END IF
        ELSEIF cmd$ = "ls" THEN
            parseLS = -1
        END IF
    ELSEIF parseLS THEN
        name$ = ps$(1)
        IF ps$(0) = "dir" THEN
            dirID = AddDir(name$, currentDirID)
        ELSE
            size& = VAL(ps$(0))
            UpdateDirSize currentDirID, size&
        END IF
    END IF
LOOP
CLOSE #1

CalculateTotalSize rootID

ans1& = 0
DIM totalSizes(DirsPoolSize - 1) AS LONG

FOR i = 0 TO DirsPoolSize - 1
    totalSize& = DirsPool(i).totalSize
    ' PRINT GetDirName$(i); " has size "; totalSize&
    IF totalSize& <= 100000 THEN
        ans1& = ans1& + totalSize&
    END IF
    totalSizes(i) = totalSize&
NEXT

PRINT "Ans1 = "; ans1&

Sort totalSizes(), 0, DirsPoolSize - 1

unused& = DeviceTotalSpace - DirsPool(rootID).totalSize
threshold& = ReqUnusedSpace - unused&
IF threshold& > 0 THEN
    FOR i = 0 TO DirsPoolSize - 1
        totalSize& = totalSizes(i)
        IF totalSize& >= threshold& THEN
            ans2& = totalSize&
            EXIT FOR
        END IF
    NEXT
END IF

PRINT "Ans2 = "; ans2&

END

FUNCTION AddDir (dname$, parent)
    dirID = DirsPoolSize
    DirsPool(dirID).dname = dname$
    DirsPool(dirID).size = 0
    DirsPool(dirID).totalSize = 0
    DirsPool(dirID).parent = parent
    IF parent <> -1 THEN
        DirsPool(dirID).nxt = DirsPool(parent).child
        DirsPool(parent).child = dirID
    ELSE
        DirsPool(dirID).nxt = -1
    END IF
    DirsPool(dirID).child = -1
    DirsPoolSize = DirsPoolSize + 1

    AddDir = dirID
END FUNCTION

SUB CalculateTotalSize (dirID)
    totalSize& = DirsPool(dirID).size

    currentID = DirsPool(dirID).child
    DO WHILE currentID <> -1
        CalculateTotalSize currentID
        totalSize& = totalSize& + DirsPool(currentID).totalSize
        currentID = DirsPool(currentID).nxt
    LOOP

    DirsPool(dirID).totalSize = totalSize&
END SUB

FUNCTION GetDirName$ (dirID)
    GetDirName$ = RTRIM$(DirsPool(dirID).dname)
END FUNCTION

FUNCTION GetFullPath$ (dirID)
    parent = DirsPool(dirID).parent
    IF parent <> -1 THEN
        dname$ = RTRIM$(DirsPool(dirID).dname)
        res$ = GetFullPath$(parent) + dname$ + "/"
    ELSE
        res$ = "/"
    END IF
    GetFullPath$ = res$
END FUNCTION

FUNCTION GetID (dirID, dname$)
    currentID = DirsPool(dirID).child
    DO WHILE currentID <> -1
        IF GetDirName$(currentID) = dname$ THEN
            GetID = currentID
            EXIT FUNCTION
        END IF
        currentID = DirsPool(currentID).nxt
    LOOP
    GetID = -1
END FUNCTION

FUNCTION Partition (arr&(), l, r)
    m = INT(RND * (r - l + 1)) + l
    SWAP arr&(m), arr&(r)
    position = l
    DIM pivot AS LONG
    pivot = arr&(r)
    FOR i = l TO r - 1
        IF arr&(i) < pivot THEN
            SWAP arr&(i), arr&(position)
            position = position + 1
        END IF
    NEXT
    SWAP arr&(position), arr&(r)
    Partition = position
END FUNCTION

SUB Sort (arr&(), l, r)
    IF l < r THEN
        m = Partition(arr&(), l, r)
        Sort arr&(), l, m - 1
        Sort arr&(), m + 1, r
    END IF
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
        posFrom = posTo + 1
    LOOP
    SplitBy = i
END FUNCTION

SUB UpdateDirSize (dirID, size&)
    DirsPool(dirID).size = DirsPool(dirID).size + size&
END SUB

