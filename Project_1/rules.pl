not(X) :- X, !, fail.
not(X).

checkIfThereIsATree(Board, Coords) :-
    getElementAtCoord(Board, Coords, Elem),
    Elem == 'X'.

thereareNoTreesInTheMiddle(_Board, _LeapX, _LeapY, XtoTest, YtoTest, GoalX, GoalY) :-
    XtoTest =:= GoalX,
    YtoTest =:= GoalY.

thereareNoTreesInTheMiddle(Board, LeapX, LeapY, XtoTest, YtoTest, GoalX, GoalY) :-
    not(checkIfThereIsATree(Board, [XtoTest, YtoTest])),
    NewX is XtoTest + LeapX,
    NewY is YtoTest + LeapY,
    thereareNoTreesInTheMiddle(Board, LeapX, LeapY, NewX, NewY, GoalX, GoalY).

notNeighboor(DiffX, DiffY) :-
    AbsDX is abs(DiffX),
    AbsDY is abs(DiffY),
    (AbsDX > 1 ; AbsDY > 1).
    %nl, print([AbsDX, AbsDY]),
    %nl, print('       NOT NEIGHBOORS       ').

checkIfThereIsNotALineOfSight(Board, NewCoords, EnemyCoords) :-
    getX(NewCoords, NX),
    getY(NewCoords, NY),
    getX(EnemyCoords, EX),
    getY(EnemyCoords, EY),
    DiffX is NX - EX,
    DiffY is NY - EY, !,
    notNeighboor(DiffX, DiffY), !,
    %nl, print('DIFFS -> '), print([DiffX, DiffY]),
    CoPrime is gcd(DiffX, DiffY),
    CoPrime =\= 1,
    StepX is round(DiffX / CoPrime),
    StepY is round(DiffY / CoPrime),
    %nl, print('STEPS -> '), print([StepX, StepY]),
    FirstX is round(NX + StepX),
    FirstY is round(NY + StepY),
    LastX is round(EX - StepX),
    LastY is round(EY - StepY),
    findall(Elem, getElemntsInALine(Board, StepX, StepY, LastX, LastY, FirstX, FirstY, Elem), R),
    member('X', R).
    %nl, print('R Trees -> '), print(R).

checkMinaPlanToMove(PreviousCoords, NewCoords) :-
    not(areCoordsValid(PreviousCoords)) ; %in case of first movement
    (getX(NewCoords, NX),
    getY(NewCoords, NY),
    getX(PreviousCoords, PX),
    getY(PreviousCoords, PY),
    DiffX is abs(NX - PX),
    DiffY is abs(NY - PY),
    ((DiffX > 0, DiffY =:= 0) ; (DiffY > 0, DiffX =:= 0) ; (DiffX =:= DiffY , DiffX > 0))).

checkYukiPlanToMove(PreviousCoords, NewCoords) :-
    (not(areCoordsValid(PreviousCoords))) ; %in case of first movement
    (getX(NewCoords, NX),
    getY(NewCoords, NY),
    getX(PreviousCoords, PX),
    getY(PreviousCoords, PY),
    DiffX is abs(NX - PX),
    DiffY is abs(NY - PY),
    ((DiffX =:= 1, DiffY =:= 0) ; (DiffY =:= 1, DiffX =:= 0) ; (DiffX =:= DiffY , DiffX =:= 1))).

getElemntsInALine(Board, LeapX, LeapY, XtoTest, YtoTest, GoalX, GoalY, Elem) :-
    multiples(XtoTest, YtoTest, LeapX, LeapY, RX, RY),
    getElementAtCoord(Board, [RX, RY], Elem).

isYukiInTheMiddle(Board, LeapX, LeapY, XtoTest, YtoTest, GoalX, GoalY) :-
    findall(Elem, getElemntsInALine(Board, LeapX, LeapY, XtoTest, YtoTest, GoalX, GoalY, Elem), R), !,
    member('Y', R).
    %nl, print('R -> '), print(R).

yukiIsNotInTheMiddle(Board, LeapX, LeapY, XtoTest, YtoTest, GoalX, GoalY) :-
    not(isYukiInTheMiddle(Board, LeapX, LeapY, XtoTest, YtoTest, GoalX, GoalY)).

multiples(X, Y, DX, DY,X1, Y1):-
    factor(N),
    NDX is N*DX,
    NDY is N*DY,
    RX is X+NDX,
    RY is Y+NDY,
    casa(RX, RY),
    X1 is RX,
    Y1 is RY.

checkIfMinaDoestGoAboveYuki(Board, NewMinaCoords) :-
    (not(findMina(Board, PX, PY))) ; ( %se nao encontra a mina e pq e o 1 move
    findMina(Board, PX, PY),
    getX(NewMinaCoords, NX),
    getY(NewMinaCoords, NY),
    DiffX is NX - PX,
    DiffY is NY - PY,
    CoPrime is gcd(DiffX, DiffY),
    StepX is round(DiffX / CoPrime),
    StepY is round(DiffY / CoPrime), !,
    yukiIsNotInTheMiddle(Board, StepX, StepY, PX, PY, NX, NY)).

areCoordsEqual(Coords1, Coords2) :-
    getX(Coords1, X1),
    getY(Coords1, Y1),
    getX(Coords2, X2),
    getY(Coords2, Y2),
    X1 =:= X2, Y1 =:= Y2.

checkIfMinaCanMoveTo(Board, MinaCoords) :-
    findYuki(Board, YX, YY),
    YukiCoords = [YX, YY],
    findMina(Board, X, Y),
    PreviousMinaCoords = [X, Y],
    not(areCoordsEqual(MinaCoords, YukiCoords)), !,
    %nl,print('Evaluating: '),print(PreviousMinaCoords), print(' -> '), print(MinaCoords),
    checkMinaPlanToMove(PreviousMinaCoords, MinaCoords), !, % can move diagonally or ortoganlly has many cases as she wants
    %nl,print('Legal move'), nl,
    checkIfThereIsNotALineOfSight(Board, MinaCoords, YukiCoords), !, % yuki can t have a line of sight
    %nl,print('No line of sight'), nl,
    checkIfMinaDoestGoAboveYuki(Board, MinaCoords), !.
    %nl,print('DOesn t go above yuki'), nl.

checkIfYukiCanMoveTo(Board, YukiCoords) :-
    isYukiFirstMove(Board) ;
    (
    findYuki(Board, X, Y),
    PreviousYukiCoords = [X, Y],
    findMina(Board, MX, MY),
    MinaCoords = [MX, MY],
    checkIfThereIsATree(Board, YukiCoords), % must eat a tree
    checkYukiPlanToMove(PreviousYukiCoords, YukiCoords), % can only move diagonally or ortoganlly one case
    not(checkIfThereIsNotALineOfSight(Board, YukiCoords, MinaCoords))). % must have a line of sight

minaPossibleMoves(X, Y, X1, Y1) :-
    (not(areCoordsValid([X,Y])), casa(X1, Y1)) ;
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

valid_moves(Board, Char, ListOfMoves) :-
  (isYukiFirstMove(Board), % is Yuki first move
  findall([X, Y], casa(X,Y), ListOfMoves))  % returns all positions
  ; % OR
  (
  (Char == 'mina', findMina(Board, MX, MY), findall([X, Y], (minaPossibleMoves(MX, MY, X,Y), checkIfMinaCanMoveTo(Board, [X,Y])), Moves)) % Returns all mina possible moves
  ;
  (findall([X, Y], (casa(X,Y), checkIfYukiCanMoveTo(Board, [X,Y])), Moves)) % Returns all yuki possible moves
  ), remove_duplicates(Moves, ListOfMoves). % assures that there are not duplicated members

findYuki(Board, X, Y) :-
    casa(X,Y),
    getElementAtCoord(Board, [X,Y], Elem),
    Elem == 'Y'.

findMina(Board, X, Y) :-
    casa(X,Y),
    getElementAtCoord(Board, [X,Y], Elem),
    Elem == 'M'.

findMina(Board, X, Y) :-
    X is -1,
    Y is -1.

findEatenTrees(Board, NumberOfEatenTrees) :-
    findall(casa(X,Y), (getElementAtCoord(Board, [X,Y], Elem), Elem == 'O'), R),
    length(R, NumberOfEatenTrees).

isMinaInTheBoarder(Game) :-
  getMinaCoordinates(Game, MC),
  getX(MC, X),
  getY(MC, Y),
  (X == 0 ;
  X == 8 ;
  Y == 0;
  Y == 8).

isYukiFirstMove(Board) :- not(findYuki(Board, X, Y)).

isMinaFirstMove(Board) :- not(findMina(Board, X, Y)).

getDistanceBetweenChar(Board, Distance) :-
    findMina(Board, MX, MY),
    findYuki(Board, YX, YY),
    DiffX is MX-YX,
    DiffY is MY-YY,
    Distance is round(sqrt(DiffX*DiffX + DiffY*DiffY)).

gameOver(Board, Winner):-
    valid_moves(Board, 'mina', Moves),
    length(Moves, L),
    L == 0,
    Winner = 'yuki'.

gameOver(Board, Winner) :-
    valid_moves(Board, 'yuki', Moves),
    length(Moves, L),
    L == 0,
    Winner = 'mina'.

value(Board, Char, Value) :-
    gameOver(Board, Winner),
    Winner == Char,
    Value is 1000000, !.

value(Board, Char, Value) :-
    enemy(Char, Enemy),
    gameOver(Board, Winner),
    Winner == Enemy,
    Value is 0, !.

value(Board, Char, Value) :-
    Char == 'yuki',
    valid_moves(Board, Char, YukiMoves),
    valid_moves(Board, 'mina', MinaMoves),
    length(YukiMoves, NumberOfYukiMoves),
    length(MinaMoves, NumberOfMinaMoves),
    findEatenTrees(Board, NumberOfEatenTrees),
    getDistanceBetweenChar(Board, Distance),
    Value is (NumberOfYukiMoves * 2000 - NumberOfMinaMoves * 700 - NumberOfEatenTrees * 100 - Distance*500).
    % ,
    % nl, print('yuki moves ->'), print(NumberOfYukiMoves * 1000),
    % nl, print('mina moves ->'), print(NumberOfMinaMoves * 500),
    % nl, print('eaten trees ->'), print(NumberOfEatenTrees * 100),
    % nl, print('distance ->'), print(Distance * 100).

value(Board, Char, Value) :-
    Char == 'mina',
    valid_moves(Board, Char, MinaMoves),
    valid_moves(Board, 'yuki', YukiMoves),
    length(YukiMoves, NumberOfYukiMoves),
    length(MinaMoves, NumberOfMinaMoves),
    findEatenTrees(Board, NumberOfEatenTrees),
    getDistanceBetweenChar(Board, Distance),
    Value is (NumberOfMinaMoves * 1000 - NumberOfYukiMoves * 700 + NumberOfEatenTrees * 20 + Distance*500).
    % ,
    % nl, print('yuki moves ->'), print(NumberOfYukiMoves * 400),
    % nl, print('mina moves ->'), print(NumberOfMinaMoves * 1000),
    % nl, print('eaten trees ->'), print(NumberOfEatenTrees * 100),
    % nl, print('distance ->'), print(Distance * 100).

getPlayValue(Board, Elem, PlayingChar, Value) :-
    updateAuxBoard(Board, NewB, Elem, PlayingChar),
    value(NewB, PlayingChar, Value).

getRandomPlay(Moves, SelectedPLay) :-
    length(Moves, L),
    Max is L-1,
    random(0, Max, R),
    nth0(R, Moves, SelectedPLay),
    nl, print('PLAY: '), print(R), print(' -> '), print(SelectedPLay).

choose_move(Board, PlayingChar, 0, Move) :-
    valid_moves(Board, PlayingChar, Moves),
    getRandomPlay(Moves, Move).

choose_move(Board, PlayingChar, 1, Move) :-
    valid_moves(Board, PlayingChar, Moves),
    length(Moves, L),
    evaluateMoveList(Board, PlayingChar, Moves, EvaluationList),
    %nl, print('Moves -> '), print(Moves),
    getMaxElemIndex(EvaluationList, PlayIndex),
    ActualIndex is L-PlayIndex-1,
    %nl, print('Index -> '), print(PlayIndex),
    nth0(ActualIndex, Moves, Move),
    nl, print('PLAY: '), print(ActualIndex), print(' -> '), print(Move).


evaluateMoveList(_, _, [], []).

evaluateMoveList(Board, Char, [H|T], ListValueOfMoves) :-
    evaluateMoveList(Board, Char, T, OtherValues), !,
    updateAuxBoard(Board, NewBoard, H, Char),
    value(NewBoard, Char, Evaluation),
    Levaluation = [Evaluation],
    append(OtherValues, Levaluation, ListValueOfMoves).

getMaxElemIndex(ListValueOfMoves, Index):-
    max_member(MaxValue, ListValueOfMoves),
    nth0(Index, ListValueOfMoves, MaxValue).
