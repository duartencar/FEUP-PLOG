initialBoard(
    [['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
    ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
    ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
    ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
    ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
    ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
    ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
    ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
    ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X']]
    ).

gmode('playerVplayer').
gmode('botVplayer').

gameChar('yuki').
gameChar('mina').

playerChar('mina', 'player2').
playerChar('yuki', 'player1').
playerChar('mina', 'bot').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The two functions below return the game object as a List.
% Elements: 
%   0: Board matrix.
%   1: player score
%   2: player or bot score
%   3: yuki coordinates
%   4: mina coordinates
%   5: character turn
%   6: gameMode
%   7: bot difficulty

createPlayerVsPlayerGame(G) :- initialBoard(Board), G = [Board, 0, 0, [-1,-1], [-1, -1], 'yuki', 'playerVplayer'].

createPlayerVsBotGame(G, Bot) :- initialBoard(Board), G = [Board, 0, 0, [-1,-1], [-1, -1], 'yuki', 'botVplayer', Bot].

getGameBoard(G, Board) :- nth0(0, G, Board).

getPlayerScore(G, Score) :- nth0(1, G, Score).

getPlayer2Score(G, Score) :- nth0(2, G, Score).

getBotScore(G, Score) :- nth0(2, G, Score).

getYukiCoordinates(G, Coords) :- nth0(3, G, Coords).

getMinaCoordinates(G, Coords) :- nth0(4, G, Coords).

getCharTurn(G, Char) :- nth0(5, G, Char).

getGameMode(G, Gmode) :- nth0(6, G, Gmode).

getBot(G, TypeOfBot) :- nth0(7, G, TypeOfBot).

getX(Coords, X) :- nth0(0, Coords, X).

getY(Coords, Y) :- nth0(1, Coords, Y).

getPlayerToPlay(G, P) :- getCharTurn(G, Char), playerChar(Char, P).

setNewMinaCoords(G, NewCoords) :-  
    getMinaCoordinates(G, MinaCoords),
    print('Old coords'),
    print(MinaCoords),
    =(MinaCoords, NewCoords),
    print('New Coords'),
    print(MinaCoords).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gcd(0, DeltaX, DeltaX):- DeltaX > 0, !.
gcd(DeltaX, DeltaY, GDC) :- DeltaX >= DeltaY, X1 is DeltaX - DeltaY, gcd(X1, DeltaY, GDC).
gcd(DeltaX, DeltaY, GDC) :- DeltaX < DeltaY, X1 is DeltaY - DeltaX, gcd(X1, DeltaX, GDC).

checkLineOfSight(DeltaX, DeltaY) :- %So ha linha de visao se o maximo divisor comum entre os 2 for 1.
    (DeltaX =\= 0 ; DeltaY =\= 0),
    gcd(DeltaX, DeltaY, GDC),
    GDC =:= 1.

convertXValue(X, NewX) :-
    (
        X == 'a' -> NewX = 0;
        X == 'b' -> NewX = 1;
        X == 'c' -> NewX = 2;
        X == 'd' -> NewX = 3;
        X == 'e' -> NewX = 4;
        X == 'f' -> NewX = 5;
        X == 'g' -> NewX = 6;
        X == 'h' -> NewX = 7;
        X == 'i' -> NewX = 8;
        X ==  _ -> ;
    ), print('Converted').
    

checkIfCoordsAreValid(Coords) :-
    length(Coords, L),
    L =:= 2,
    rowGuides(RG),
    lineGuides(LG),
    getX(Coords, X),
    getY(Coords, Y),
    member(X, RG),
    member(Y, LG).


convertToMatrixCoords(Coords, ConvertedCoords) :- 
    getY(Coords, Y),
    getX(Coords, X),
    NewY is Y-1,
    convertXValue(X, NewX),
    ConvertedCoords = [NewX, NewY].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% replace a single cell in a list-of-lists
% L - the source list-of-lists
% X - The cell to be replaced is indicated with a row offset
% Y - and a column offset within the row
% Z - The replacement value
% R - the transformed list-of-lists
%
replace([L|Ls], 0, Y, Z, [R|Ls]) :-       % once we find the desired row,
    replace_column(L,Y,Z,R).              % - we replace specified column, and we're done.

replace([L|Ls], X, Y, Z, [L|Rs]) :-      % if we haven't found the desired row yet
  X > 0,                                 % - and the row offset is positive,
  X1 is X-1,                             % - we decrement the row offset
  replace(Ls, X1, Y, Z, Rs).             % - and recurse down


replace_column([_|Cs], 0, Z, [Z|Cs]) .       % once we find the specified offset, just make the substitution and finish up.
replace_column([C|Cs], Y, Z, [C|Rs]) :-      % otherwise,
  Y > 0,                                     % - assuming that the column offset is positive,
  Y1 is Y-1,                                 % - we decrement it
  replace_column(Cs, Y1, Z, Rs).             % - and recurse down.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
updateBoard(OldGame, OldBoard, NewBoard, NewCoords) :-
    print('udating board'),
    getCharTurn(OldGame, Char),
    getX(NewCoords, X),
    getY(NewCoords, Y),
    (
        Char = 'yuki' -> replace(OldBoard, Y, X, 'O', NewBoard);  NewBoard = OldBoard %if it s yuki the tree is eaten
    ),
    print('updated').

updateGame(OldGame, UpdatedGame, NewBoard, NewCoords) :-
    print('updating game'),
    length(OldGame, L),
    getPlayerScore(OldGame, P1Score),
    getPlayer2Score(OldGame, P2Score),
    getYukiCoordinates(OldGame, Ycoords),
    getMinaCoordinates(OldGame, Mcoords),
    getCharTurn(OldGame, LastMovedChar),
    getGameMode(OldGame, Gmode),
    (
        LastMovedChar = 'yuki' -> AuxGame = [NewBoard, P1Score, P2Score, NewCoords, Mcoords, 'mina', Gmode];
        LastMovedChar = 'mina' -> AuxGame = [NewBoard, P1Score, P2Score, Ycoords, NewCoords, 'yuki', Gmode];
        LastMovedChar = _ -> ;
    ),
    (
        L = 7 -> UpdatedGame = AuxGame;
        L = 8 -> getBot(OldGame, B) , append(AuxGame, [B], UpdatedGame);
        L = _ -> ;
    ).
    

