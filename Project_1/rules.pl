getElementAtCoord(Board, Coords, Elem) :-
    getX(Coords, X),
    getY(Coords, Y),
    nth0(Y, Board, Line),
    nth0(X, Line, Elem).

not(X) :- X, !, fail.
not(X).

checkIfThereIsATree(Board, Coords) :- 
    getElementAtCoord(Board, Coords, Elem),
    nl,
    Elem == 'X'.

thereareNoTreesInTheMiddle(Board, LeapX, LeapY, XtoTest, YtoTest, GoalX, GoalY) :- 
    XtoTest =:= GoalX,
    YtoTest =:= GoalY.

thereareNoTreesInTheMiddle(Board, LeapX, LeapY, XtoTest, YtoTest, GoalX, GoalY) :-
    not(checkIfThereIsATree(Board, [XtoTest, YtoTest])),
    NewX is XtoTest + LeapX,
    NewY is YtoTest + LeapY,
    thereareNoTreesInTheMiddle(Board, LeapX, LeapY, NewX, NewY, GoalX, GoalY).

checkIfThereIsNotALineOfSight(Board, NewCoords, EnemyCoords) :-
    getX(NewCoords, NX),
    getY(NewCoords, NY),
    getX(EnemyCoords, EX),
    getY(EnemyCoords, EY),
    DiffX is EX - NX,
    DiffY is EY - NY,
    (abs(DiffX) >= 2 ; abs(DiffY) >= 2),
    CoPrime is gcd(DiffX, DiffY),
    CoPrime =\= 1,
    StepX is round(DiffX / CoPrime),
    StepY is round(DiffY / CoPrime),
    FirstX is round(NX + StepX),
    FirstY is round(NY + StepY),
    not(thereareNoTreesInTheMiddle(Board, StepX, StepY, FirstX, FirstY, EX, EY)).

checkMinaPlanToMove(PreviousCoords, NewCoords) :-
    not(areCoordsValid(PreviousCoords)) ; %in case of first movement
    (getX(NewCoords, NX),
    getY(NewCoords, NY),
    getX(PreviousCoords, PX),
    getY(PreviousCoords, PY),
    DiffX is abs(NX - PX),
    DiffY is abs(NY - PY),
    ((DiffX > 0, DiffY =:= 0) ; (DiffY > 0, DiffX =:= 0) ; (DiffX =:= DiffY , DiffX > 0)),
    print('valid movement')).

checkYukiPlanToMove(PreviousCoords, NewCoords) :-
    not(areCoordsValid(PreviousCoords)) ; %in case of first movement
    (getX(NewCoords, NX),
    getY(NewCoords, NY),
    getX(PreviousCoords, PX),
    getY(PreviousCoords, PY),
    DiffX is abs(NX - PX),
    DiffY is abs(NY - PY),
    ((DiffX =:= 1, DiffY =:= 0) ; (DiffY =:= 1, DiffX =:= 0) ; (DiffX =:= DiffY , DiffX =:= 1)),
    print('valid movement')).

checkIfMinaCanMoveTo(Game, MinaCoords) :-
    getGameBoard(Game, Board),
    getYukiCoordinates(Game, YukiCoords),
    getMinaCoordinates(Game, PreviousMinaCoords),
    checkMinaPlanToMove(PreviousMinaCoords, MinaCoords), % can move diagonally or ortoganlly has many cases as she wants
    checkIfThereIsNotALineOfSight(Board, MinaCoords, YukiCoords). % yuki can t have a line of sight

checkIfYukiCanMoveTo(Game, YukiCoords) :- 
    getGameBoard(Game, Board),
    getYukiCoordinates(Game, PreviousYukiCoords),
    getMinaCoordinates(Game, MinaCoords),
    checkIfThereIsATree(Board, YukiCoords), % must eat a tree
    checkYukiPlanToMove(PreviousYukiCoords, YukiCoords), % can only move diagonally or ortoganlly one case
    not(checkIfThereIsNotALineOfSight(Board, YukiCoords, MinaCoords)). % must have a line of sight

checkPlayerPlans(Game, Coords) :-
    getCharTurn(Game, CharToMove),
    (
        CharToMove = 'mina' -> checkIfMinaCanMoveTo(Game, Coords); checkIfYukiCanMoveTo(Game, Coords)
    ).



%%%TESTAR FUNCAO DA MINA

