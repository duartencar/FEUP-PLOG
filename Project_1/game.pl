
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

getGameForSecondRound(OldGame, Winner, NewGame) :-
    initialBoard(B),
    getGameMode(OldGame, Gmode),
    (
    Gmode == 'playerVplayer' -> (Winner == 'player1' -> NewGame = [B, 1, 0, [-1,-1], [-1, -1], 'yuki', 'playerVplayer'];
                                                        NewGame = [B, 0, 1, [-1,-1], [-1, -1], 'yuki', 'playerVplayer']) ;
                                (getBot(OldGame, Bot), Winner == 'player1' -> NewGame = [B, 1, 0, [-1,-1], [-1, -1], 'yuki', 'playerVplayer', Bot];
                                                                              NewGame = [B, 0, 1, [-1,-1], [-1, -1], 'yuki', 'playerVplayer', Bot])

    ).


getGameBoard(G, Board) :- nth0(0, G, Board).

isItATree(G, X, Y) :- getGameBoard(G, Board), getElementAtCoord(Board, [X, Y], Elem), Elem == 'X'.

isItYuki(G, X, Y) :- getGameBoard(G, Board), getElementAtCoord(Board, [X, Y], Elem), Elem == 'Y'.

getPlayerScore(G, Score) :- nth0(1, G, Score).

getPlayer2Score(G, Score) :- nth0(2, G, Score).

getBotScore(G, Score) :- nth0(2, G, Score).

getYukiCoordinates(G, Coords) :- nth0(3, G, Coords).

isYukiFirstMove(G) :- getYukiCoordinates(G, Coords), not(areCoordsValid(Coords)).

getMinaCoordinates(G, Coords) :- nth0(4, G, Coords).

isMinaFirstMove(G) :- getMinaCoordinates(G, Coords), not(areCoordsValid(Coords)).

getCharTurn(G, Char) :- nth0(5, G, Char).

getGameMode(G, Gmode) :- nth0(6, G, Gmode).

getBot(G, TypeOfBot) :- nth0(7, G, TypeOfBot).

getX(Coords, X) :- nth0(0, Coords, X).

getY(Coords, Y) :- nth0(1, Coords, Y).

getPlayerToPlay(G, P) :-
    getCharTurn(G, Char),
    getGameMode(G, Gmode),
    print('Mode -> '), print(Gmode), nl,
    getPlayerScore(G, S1),
    getPlayer2Score(G, S2),
    Sum is S1+S2,
    print('Sum -> '), print(Sum), nl,
    (
      Sum =:= 0 -> (Char == 'yuki' -> P = 'player1' ; (Gmode == 'playerVplayer' -> P = 'player2' ; P = 'bot')) ;
      (Char == 'mina' -> P = 'player1' ; (Gmode == 'playerVplayer' -> P = 'player2' ; P = 'bot'))
    ), print('NEXT -> '), print(P), nl.


areCoordsValid(Coords) :-
    getX(Coords, X),
    getY(Coords, Y),
    casa(X,Y).

getElementAtCoord(Board, Coords, Elem) :-
    getX(Coords, X),
    getY(Coords, Y),
    nth0(Y, Board, Line),
    nth0(X, Line, Elem).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    ).


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
    ConvertedCoords = [NewX, NewY],
    nl,
    print('Converted: '),
    print(ConvertedCoords),
    nl.

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

remove_duplicates([],[]).

remove_duplicates([H | T], List) :-
    member(H, T),
    remove_duplicates( T, List).

remove_duplicates([H | T], [H|T1]) :-
    \+member(H, T),
    remove_duplicates( T, T1).

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
