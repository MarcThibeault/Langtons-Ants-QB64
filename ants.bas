RANDOMIZE TIMER

Torique = 1
Rebonds = 0

BGauche = 110

PRINT "Welcome to Langton's Ants on steroids!"
INPUT "Number of ants <1-128>[15]:", NColor
INPUT "Universe width [1920]:", LEcran
INPUT "Universe height [1030]:", HEcran
IF NColor = 0 THEN NColor = 15
IF NColor > 128 THEN NColor = 128
IF LEcran = 0 THEN LEcran = 1920
IF HEcran = 0 THEN HEcran = 1030
INPUT "Toroidal universe? <Y/N>[Y]:", R$
IF UCASE$(R$) = "N" THEN Torique = 0

DIM Alive(NColor)
DIM X(NColor)
DIM Y(NColor)
DIM DX(NColor)
DIM DY(NColor)
DIM NB(NColor) AS LONG
DIM IN AS STRING
DIM Vitesse AS LONG
DIM Iterations AS LONG
DIM Vivantes AS INTEGER
DIM Score1 AS LONG
DIM Score2 AS LONG
DIM Score3 AS LONG

Vitesse = 1
Tours = 0
Iterations = 0
Vivantes = 0

PRINT "Press ENTER to start!"
SLEEP

handle& = _NEWIMAGE(LEcran, HEcran, 256)
SCREEN handle&
CLS
LINE (BGauche, 1)-(BGauche, HEcran), 15

FOR I = 1 TO NColor
    Alive(I) = 1
    X(I) = INT(RND * 3 / 4 * LEcran + BGauche)
    Y(I) = INT(RND * 3 / 4 * HEcran + 1 / 8 * HEcran)
    D = INT(RND * 4 + 1)
    SELECT CASE D
        CASE 1
            DX(I) = 1
            DY(I) = 0
        CASE 2
            DX(I) = 0
            DY(I) = -1
        CASE 3
            DX(I) = -1
            DY(I) = 0
        CASE 4
            DX(I) = 0
            DY(I) = 1
    END SELECT
NEXT I

DO
    IN = INKEY$
    IF IN = "-" AND Vitesse > 1 THEN Vitesse = Vitesse - 1
    IF IN = "+" AND Vitesse < 9 THEN Vitesse = Vitesse + 1
    IF IN = "l" OR IN = "L" THEN LINE (INT(BGauche + RND * (LEcran - BGauche)), INT(RND * HEcran))-(INT(BGauche + RND * (LEcran - BGauche)), INT(RND * HEcran)), 129

    Vivantes = 0
    FOR K = 1 TO (10 - Vitesse) ^ 6
    NEXT K

    FOR I = 1 TO NColor
        IF Alive(I) = 1 THEN
            Vivantes = Vivantes + 1
            P = POINT(X(I), Y(I))
            W = DX(I)
            DX(I) = DY(I)
            DY(I) = W
            IF P = 0 THEN
                PSET (X(I), Y(I)), I
                NB(I) = NB(I) + 1
                DY(I) = DY(I) * -1
            ELSE
                IF P <> 129 THEN
                    NB(P) = NB(P) - 1
                    PSET (X(I), Y(I)), 0
                    DX(I) = DX(I) * -1
                END IF
            END IF
            X(I) = X(I) + DX(I)
            Y(I) = Y(I) + DY(I)
            Iterations = Iterations + 1
        END IF
        IF Torique = 1 THEN
            IF X(I) = BGauche THEN X(I) = LEcran - 1
            IF X(I) = LEcran THEN X(I) = BGauche + 1
            IF Y(I) = 0 THEN Y(I) = HEcran - 1
            IF Y(I) = HEcran THEN Y(I) = 1
        ELSE
            IF X(I) = BGauche THEN Alive(I) = 0
            IF X(I) = LEcran THEN Alive(I) = 0
            IF Y(I) = 0 THEN Alive(I) = 0
            IF Y(I) = HEcran THEN Alive(I) = 0

        END IF
    NEXT

    Tours = Tours + 1

    LOCATE 1, 1: COLOR 15: PRINT "Speed [1-9]"
    LOCATE 2, 1: COLOR 15: PRINT Vitesse;
    LOCATE 3, 1: COLOR 15: PRINT "Steps"
    LOCATE 4, 1: COLOR 15: PRINT Iterations
    LOCATE 5, 1: COLOR 15: PRINT "Living Ants"
    LOCATE 6, 1: COLOR 15: PRINT Vivantes; "/"; NColor

    Score1 = 0
    Score2 = 0
    Score3 = 0

    FOR I = 1 TO NColor
        IF NB(I) > NB(Score1) THEN
            Score3 = Score2
            Score2 = Score1
            Score1 = I
        ELSE
            IF NB(I) > NB(Score2) THEN
                Score3 = Score2
                Score2 = I
            ELSE
                IF NB(I) > NB(Score3) THEN
                    Score3 = I
                END IF
            END IF
        END IF
    NEXT I

    IF Tours MOD 30 = 0 THEN
        LOCATE 8, 1: COLOR 15: PRINT "Top 3"
        LOCATE 9, 1: COLOR 15: PRINT "1: "
        LOCATE 9, 4: COLOR Score1: PRINT NB(Score1)
        LOCATE 10, 1: COLOR 15: PRINT "2: "
        LOCATE 10, 4: COLOR Score2: PRINT NB(Score2)
        LOCATE 11, 1: COLOR 15: PRINT "3: "
        LOCATE 11, 4: COLOR Score3: PRINT NB(Score3)
    END IF
LOOP
END
