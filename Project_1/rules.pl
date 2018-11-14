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
    (not(areCoordsValid(PreviousCoords)), print('first move')) ; %in case of first movement
    (print('not first move'),
    getX(NewCoords, NX),
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
    isYukiFirstMove(Game) ;
    ( 
    getGameBoard(Game, Board),
    getYukiCoordinates(Game, PreviousYukiCoords),
    getMinaCoordinates(Game, MinaCoords),
    checkIfThereIsATree(Board, YukiCoords), % must eat a tree
    checkYukiPlanToMove(PreviousYukiCoords, YukiCoords), % can only move diagonally or ortoganlly one case
    not(checkIfThereIsNotALineOfSight(Board, YukiCoords, MinaCoords))). % must have a line of sight

checkPlayerPlans(Game, Coords) :-
    getCharTurn(Game, CharToMove),
    (
        CharToMove = 'mina' -> checkIfMinaCanMoveTo(Game, Coords); checkIfYukiCanMoveTo(Game, Coords)
    ).
    
minaPossibleMoves(Game, X1, Y1) :-
    getMinaCoordinates(Game, Coords),
    getX(Coords, X),
    getY(Coords, Y),
    casa(X1, Y1),
    DiffX is abs(X-X1),
    DiffY is abs(Y-Y1),
    ((DiffX =:= 0 , DiffY  >  0);
     (DiffX >   0 , DiffY =:= 0);
     (DiffX >   0 , DiffY =:= DiffX)
    ).

yukiPossibleMoves(Game, X1, Y1) :-
    getYukiCoordinates(Game, Coords),
    getX(Coords, X),
    getY(Coords, Y),
    casa(X1, Y1),
    isItATree(Game, X1, Y1),
    DiffX is abs(X-X1),
    DiffY is abs(Y-Y1),
    ((DiffX =:= 0 , DiffY =:= 1);
     (DiffX =:= 1 , DiffY =:= 0);
     (DiffX =:= 1 , DiffY =:= DiffX)
    ).

checkIfYukiHasMoves(Game) :-
    print('Checking if yuki can move'),nl,
    isYukiFirstMove(Game) ; (
    yukiPossibleMoves(Game, X,Y),
    Coords = [X, Y],
    nl ,print('Going to test ->'), print(Coords), nl,
    checkIfYukiCanMoveTo(Game, Coords), !
    ).

checkIfMinaHasMoves(Game) :- 
    print('Checking if mina can move'),nl,
    isMinaFirstMove(Game) ; (
    getGameBoard(Game, Board),
    getYukiCoordinates(Game, YC),
    getX(MC, X),
    getY(MC, Y),
    minaPossibleMoves(Game,X1,Y1),
    Coords = [X1, Y1],
    nl,print('Going to test ->'), print(Coords),nl,
    checkIfThereIsNotALineOfSight(Board, Coords, YC),!).
