:- use_module(library(system)).
:- use_module(library(lists)).
:- use_module(library(random)).
:- include('facts.pl').
:- include('game.pl').
:- include('ui.pl').
:- include('rules.pl').

frozenForest :- mainMenu.

playGame(G) :-
    % Verificar se a personagem que vai jogar tem movimentos validos
    % Ver se é o bot ou um dos jogadores a jogar
    % Dar oportunidade ao bot ou ao jogador de jogar
    checkIfnextCharCanMove(G, Moves),
    length(Moves, L),
    L > 0,
    getPlayerToPlay(G, Player),
    (((Player == 'player1' ; Player == 'player2'), getHumanPlay(G, Moves, NG)) ;
    (Player == 'bot', letBotPlay(G, Moves, NG))),
    playGame(NG).

playGame(G) :-
    isItEndOfFirstRound(G),
    clearConsole,
    printBoardWithChars(G),
    getRoundWinner(G, Winner),
    pressEnterToContinue,
    getGameForSecondRound(G, Winner, NG),
    playGame(NG), !.

playGame(G) :-
    (getGameWinner(G, Winner),
    clearConsole,
    printBoardWithChars(G),
    nl, print('End of the game.'),
    nl, print('Winner is '), print(Winner), print(.), nl,
    pressEnterToContinue, !) ;
    (clearConsole, printBoardWithChars(G), nl, print('It s a draw'), nl, pressEnterToContinue , !).

getHumanPlay(OldGameState, PossibleMoves, NewGameState) :-
    getPlayerToPlay(OldGameState, Player), % s e é p1 ou p2
    getGameBoard(OldGameState, Board),
    repeat,
    clearConsole,
    printBoardWithChars(OldGameState),
    askPlayerToInsertPlay(OldGameState, Coords), % notifica um dos jogadores
    checkIfCoordsAreValid(Coords),
    convertToMatrixCoords(Coords, NewCoords),
    validPlay(PossibleMoves, NewCoords),
    updateBoard(OldGameState, Board, NewBoard, NewCoords),
    move(OldGameState, Board, NewGameState, NewCoords).

letBotPlay(OldGameState, Moves, NewGameState) :-
    length(Moves, L),
    L > 0,
    getBot(OldGameState, Difficulty),
    getGameBoard(OldGameState, Board),
    getBoardWithChars(OldGameState, BoardChars),
    getCharTurn(OldGameState, Char),
    repeat,
    ((Difficulty == 'easy', choose_move(BoardChars, Char, 0, Play)) ; (Difficulty == 'hard', choose_move(BoardChars, Char, 1, Play))), % meter a jogada do bot dificil
    nl, print('Received -> '), print(Play),nl,
    validPlay(Moves, Play),
    move(OldGameState, Board, NewGameState, Play).

move(OldGame, OldBoard, NewGame, NewCoords) :-
    updateBoard(OldGame, OldBoard, NewBoard, NewCoords),
    updateGame(OldGame, NewGame, NewBoard, NewCoords).

validPlay(Moves, Play) :-
    member(Play, Moves).

checkIfnextCharCanMove(Game, Moves) :-
    getCharTurn(Game, Char),
    getBoardWithChars(Game, Board),
    valid_moves(Board, Char, Moves), !,
    nl, print('Next to play: '), print(Char),
    %nl, print('Possible moves -> '), print(Moves),
    length(Moves, L),
    nl, print('Number of moves: '), print(L),
    L > 0,
    nl, print('Value: '), value(Board, Char, Value), print(Value).

isItEndOfFirstRound(Game) :-
    getPlayerScore(Game, Score1),
    getPlayer2Score(Game, Score2),
    Sum is Score1 + Score2,
    Sum =:= 0.

getRoundWinner(Game, Winner) :-
    getPlayerToPlay(Game, Player),
    getGameMode(Game, Gmode),
    (
    Gmode == 'botVplayer' -> (Player == 'player1' -> Winner = 'bot'; Winner = 'player1') ;
                             (Player == 'player1' -> Winner = 'player2' ; Winner = 'player1')),
    nl, print(Winner), print(' wins the round.').

%TO DO LIST:
  % quando a primeira ronda acaba começa a segunda. DONE
  % quando a segunda ronda acaba, anunciar o vencedor. A METADE
  % avaliar tabuleiro
  % fazer bots
