rowGuides(['1', '2', '3', '4', '5', '6', '7', '8', '9']).
printColumnGuide :- write('   a  b  c  d  e  f  g  h  i').

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

printRowValues([]).
printRowValues([Value | OtherValues]) :- write(Value), write('  '), printRowValues(OtherValues).

printBoardRow(Row, Identifier):- format('~w  ', Identifier), printRowValues(Row).


printRestOfTheBoard([], []).
printRestOfTheBoard([Row | OtherRows], [Identifier | OtherIdentifiers]) :- printBoardRow(Row, Identifier), nl, nl, printRestOfTheBoard(OtherRows, OtherIdentifiers).


printBoard(Board) :- printColumnGuide, nl, nl, rowGuides(RI), printRestOfTheBoard(Board, RI), nl.

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
	get_char(Option),print(Option), 
	get_char(_).

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
    Option = '1' -> gameModeMenu, mainMenu;
    Option = '2' -> helpMenu, mainMenu;
    Option = '3';
    nl,
    write('Error: invalid input.'), nl,
    pressEnterToContinue, nl,
    mainMenu
).

helpMenu :- write('help!!!!!'), nl.
clearConsole :- write('\e[2J').
    
