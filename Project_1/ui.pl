lineGuides([1, 2, 3, 4, 5, 6, 7, 8, 9]).
rowGuides(['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i']).

printColumnGuide :- write('|   | a | b | c | d | e | f | g | h | i |').

printRowValues([]).
printRowValues([Value | OtherValues]) :-
    write(' '),
    (Value == 'X' -> print('+') ; print(Value)),
    write(' |'),
    printRowValues(OtherValues).

printBoardRow(Row, Identifier):- format('| ~w |', Identifier), printRowValues(Row).

printBoardEndOrBegin :- write('-----------------------------------------').

printBoardDivisory :- write('|---|---|---|---|---|---|---|---|---|---|').

printRestOfTheBoard([], []).
printRestOfTheBoard([Row | OtherRows], [Identifier | OtherIdentifiers]) :- printBoardRow(Row, Identifier), nl, printBoardDivisory, nl, printRestOfTheBoard(OtherRows, OtherIdentifiers).

printBoard(Board) :- nl, printBoardEndOrBegin, nl, printColumnGuide, nl, printBoardDivisory, nl, lineGuides(RI), printRestOfTheBoard(Board, RI), nl.

printMainMenu :-
    clearConsole,
    write(' VVVVVVVVVVVVVVVVVVVVVV '), nl,
    write('|    Frozen Forest     |'), nl,
    write(' VVVVVVVVVVVVVVVVVVVVVV '), nl,
    write('|                      |'), nl,
    write('|       1 - Play       |'), nl,
    write('|   2 - How to play    |'), nl,
    write('|       3 - Exit       |'), nl,
    write('|                      |'), nl,
    write(' VVVVVVVVVVVVVVVVVVVVVV '), nl,
    write('Choose an option: '), nl.

getCoordinates(Coord) :- read(Coord), print(Coord).

getChar(Option):-
	get_char(Option),
    discardInputChar.

getInt(Input):-
	get_code(TempInput),
    Input is TempInput - 48,
    discardInputChar.

discardInputChar:-
	get_code(_).

pressEnterToContinue:-
	write('Press <Enter> to continue.'), nl,
	waitForEnter, !.

waitForEnter:-
	get_char(_).

mainMenu :-
    printMainMenu,
    getChar(Option),
    (
    Option = '1' -> gameModeMenu, mainMenu;
    Option = '2' -> helpMenu, mainMenu;
    Option = '3';
    nl,
    write('Error: invalid input.'), nl,
    pressEnterToContinue, nl,
    mainMenu
).

printGameModeMenu :-
    clearConsole,
    write(' VVVVVVVVVVVVVVVVVVVVVV '), nl,
    write('|    Frozen Forest     |'), nl,
    write(' VVVVVVVVVVVVVVVVVVVVVV '), nl,
    write('|                      |'), nl,
    write('| 1 - Player Vs Player |'), nl,
    write('|  2 - Bot Vs PLayer   |'), nl,
    write('|       3 - Exit       |'), nl,
    write('|                      |'), nl,
    write(' VVVVVVVVVVVVVVVVVVVVVV '), nl,
    write('Choose an option: '), nl.

gameModeMenu :-
    printGameModeMenu,
    getChar(Option),
    (
    Option = '1' -> createPlayerVsPlayerGame(G), playGame(G);
    Option = '2' -> botOptionsMenu, mainMenu;
    Option = '3';
    nl,
    write('Error: invalid input.'), nl,
    pressEnterToContinue, nl,
    mainMenu
).

printBotOptionsMenu :-
    clearConsole,
    write(' VVVVVVVVVVVVVVVVVVVVVV '), nl,
    write('|    Frozen Forest     |'), nl,
    write(' VVVVVVVVVVVVVVVVVVVVVV '), nl,
    write('|                      |'), nl,
    write('|     1 - Easy Bot     |'), nl,
    write('|     2 - Hard Bot     |'), nl,
    write('|       3 - Exit       |'), nl,
    write('|                      |'), nl,
    write(' VVVVVVVVVVVVVVVVVVVVVV '), nl,
    write('Choose an option: '), nl.

botOptionsMenu :-
    printBotOptionsMenu,
    getChar(Option),
    (
    Option = '1' -> createPlayerVsBotGame(Game, 'easy'), playGame(Game);
    Option = '2' -> createPlayerVsBotGame(Game, 'hard'), playGame(Game);
    Option = '3';
    nl,
    write('Error: invalid input.'), nl,
    pressEnterToContinue, nl,
    mainMenu
).

getCoord(Coords) :-
    nl,
    write('Insert column: '),
    getChar(Col),
    write('Insert line: '),
    getInt(Line),
    Coords = [Col, Line].

askPlayerToInsertPlay(Game, Coords) :-
    getPlayerToPlay(Game, Player),
    getCharTurn(Game, Char),
    (
    Player = 'player1' -> write('Player1 as ');
    Player = 'player2' -> write('Player2 as ');
    Player = _ -> ;
    ), write(Char), write(' turn.'),
    getCoord(Coords).

getBoardWithChars(Game, AfterYuki) :-
    getGameBoard(Game, Board), % get the latest board representation
    getMinaCoordinates(Game, Mcoords), % get Mina coordinates
    getYukiCoordinates(Game, Ycoords), % get Yuki coordinates
    getX(Mcoords, MX), % get X value from mina coordinates
    getY(Mcoords, MY), % get Y value from mina coordinates
    ( % if coords are valid insert mina letter in position, if not let as it is
        areCoordsValid(Mcoords) -> replace(Board, MY, MX, 'M', AfterMina); AfterMina = Board
    ),
    getX(Ycoords, YX), % get X value from yuki coordinates
    getY(Ycoords, YY), % get Y value from yuki coordinates
    ( % if coords are valid insert yuki letter in position, if not let as it is
        areCoordsValid(Ycoords) -> replace(AfterMina, YY, YX, 'Y', AfterYuki); AfterYuki = AfterMina
    ).

printBoardWithChars(Game) :-
    getBoardWithChars(Game, Board),
    printBoard(Board).


% helpMenu :-
%   clearConsole,
%   write('-------------------- Basic game flow ---------------------'), nl, nl, nl,
%   write(' One player plays Yuki and the other player plays Mina. In the end of the ﬁrst round, the players must switch characters, making a total of two rounds.'), nl, nl,
%   write('The Yuki player starts by putting Yuki wherever he wants, eating the tree that is in the selected position.'), nl,
%   write('Then Mina player, puts Mina wherever on any other tree that is not in Yuki’s line of sight.It must be at least one tree between Yuki and Mina along an imaginary straight line connecting both places.'),nl,
%   write('After that, starting with Yuki, players alternate turns.'), nl,
%   nl, pressEnterToContinue.



clearConsole :- write('\e[2J').
