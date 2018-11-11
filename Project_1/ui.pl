lineGuides([1, 2, 3, 4, 5, 6, 7, 8, 9]).
rowGuides(['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i']).



printColumnGuide :- write('   a  b  c  d  e  f  g  h  i').

printRowValues([]).
printRowValues([Value | OtherValues]) :- write(Value), write('  '), printRowValues(OtherValues).

printBoardRow(Row, Identifier):- format('~w  ', Identifier), printRowValues(Row).


printRestOfTheBoard([], []).
printRestOfTheBoard([Row | OtherRows], [Identifier | OtherIdentifiers]) :- printBoardRow(Row, Identifier), nl, nl, printRestOfTheBoard(OtherRows, OtherIdentifiers).


printBoard(Board) :- printColumnGuide, nl, nl, lineGuides(RI), printRestOfTheBoard(Board, RI), nl.

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
    Coords = [Col, Line],
    print(Coords).


askPlayerToInsertPlay(Player, Coords) :- 
    (
    Player = 'player1' -> write('Player1 turn. ');
    Player = 'player2' -> write('Player2 turn. ');
    Player = _ -> ;
    ),
    getCoord(Coords).

helpMenu :- write('help!!!!!'), nl.
clearConsole :- write('\e[2J').
    
