DEFINT A-Z

DECLARE FUNCTION ShapeCost (shape)
DECLARE FUNCTION OutcomeCost (outcome)
DECLARE FUNCTION ConvertOpponent (c$)
DECLARE FUNCTION ConvertPlayer (c$)
DECLARE FUNCTION WinningHand (hand)
DECLARE FUNCTION LosingHand (hand)
DECLARE FUNCTION DoRound (opHand, plHand)

DIM SHARED ROCK, PAPER, SCISSORS
ROCK = 0: PAPER = 1: SCISSORS = 2

DIM SHARED LOSS, TIE, WIN
LOSS = 0: TIE = 1: WIN = 2

DIM totalCost AS LONG
totalCost = 0

OPEN "in.txt" FOR INPUT AS #1
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    op$ = LEFT$(ln$, 1)
    pl$ = RIGHT$(ln$, 1)
    opHand = ConvertOpponent(op$)
    plHand = ConvertPlayer(pl$)
    outcome = DoRound(opHand, plHand)
    cost = ShapeCost(plHand) + OutcomeCost(outcome)
    totalCost = totalCost + cost
LOOP
CLOSE #1

PRINT "Ans1 = "; totalCost

END

FUNCTION ConvertOpponent (c$)
    ConvertOpponent = ASC(c$) - ASC("A")
END FUNCTION

FUNCTION ConvertPlayer (c$)
    ConvertPlayer = ASC(c$) - ASC("X")
END FUNCTION

FUNCTION DoRound (opHand, plHand)
    IF opHand = plHand THEN
        DoRound = TIE
    ELSEIF WinningHand(opHand) = plHand THEN
        DoRound = WIN
    ELSE
        DoRound = LOSS
    END IF
END FUNCTION

FUNCTION OutcomeCost (outcome)
    OutcomeCost = outcome * 3
END FUNCTION

FUNCTION ShapeCost (shape)
    ShapeCost = shape + 1
END FUNCTION

FUNCTION WinningHand (hand)
    WinningHand = (hand + 1) MOD 3
END FUNCTION

