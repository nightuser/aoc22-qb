DEFINT A-Z

DECLARE FUNCTION ShapeCost (shape)
DECLARE FUNCTION OutcomeCost (outcome)
DECLARE FUNCTION ConvertOpponent (c$)
DECLARE FUNCTION ConvertOutcome (c$)
DECLARE FUNCTION WinningHand (hand)
DECLARE FUNCTION LosingHand (hand)
DECLARE FUNCTION ChooseHand (op, outcome)

DIM SHARED ROCK, PAPER, SCISSORS
ROCK = 0: PAPER = 1: SCISSORS = 2

DIM SHARED LOSS, TIE, WIN
LOSS = 0: TIE = 1: WIN = 2

DIM totalCost AS LONG

OPEN "in.txt" FOR INPUT AS #1
DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    op$ = LEFT$(ln$, 1)
    out$ = RIGHT$(ln$, 1)
    opHand = ConvertOpponent(op$)
    outcome = ConvertOutcome(out$)
    plHand = ChooseHand(opHand, outcome)
    cost = ShapeCost(plHand) + OutcomeCost(outcome)
    totalCost = totalCost + cost
LOOP
CLOSE #1

PRINT "Ans2 = "; totalCost

END

FUNCTION ChooseHand (op, outcome)
    ChooseHand = (op + (outcome + 2)) MOD 3
END FUNCTION

FUNCTION ConvertOpponent (c$)
    ConvertOpponent = ASC(c$) - ASC("A")
END FUNCTION

FUNCTION ConvertOutcome (c$)
    ConvertOutcome = ASC(c$) - ASC("X")
END FUNCTION

FUNCTION OutcomeCost (outcome)
    OutcomeCost = outcome * 3
END FUNCTION

FUNCTION ShapeCost (shape)
    ShapeCost = shape + 1
END FUNCTION

