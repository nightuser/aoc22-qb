DEFINT A-Z
DECLARE FUNCTION SplitBy (s$, c$, ps$())

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

