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
    getGameMode(G, Gmode),
    (
        Gmode = 'botVplayer' -> (getHumanPlay(G, Moves, NG), letBotPlay(NG, FG), playGame(FG)) ;
        getHumanPlay(G, Moves, NG), playGame(NG)
    ).

playGame(G) :-
    isItEndOfFirstRound(G),
    getRoundWinner(G, Winner),
    pressEnterToContinue,
    getGameForSecondRound(G, Winner, NG),
    playGame(NG), !.

playGame(G) :-
    nl, print('End of the game.'), nl,
    pressEnterToContinue, !.

getHumanPlay(OldGameState, PossibleMoves, NewGameState) :-
    getPlayerToPlay(OldGameState, Player), % s e é p1 ou p2
    getGameBoard(OldGameState, Board),
    repeat,
    %clearConsole,
    printBoardWithChars(OldGameState),
    askPlayerToInsertPlay(OldGameState, Coords), % notifica um dos jogadores
    checkIfCoordsAreValid(Coords),
    convertToMatrixCoords(Coords, NewCoords),
    validPlay(PossibleMoves, NewCoords),
    updateBoard(OldGameState, Board, NewBoard, NewCoords),
    updateGame(OldGameState, NewGameState, NewBoard, NewCoords).

validPlay(Moves, Play) :-
    member(Play, Moves).

checkIfnextCharCanMove(Game, Moves) :-
    (areCharsNeighboors(Game), Moves = [], !) ; (
    !,
    getCharTurn(Game, Char),
    getBoardWithChars(Game, Board),
    valid_moves(Board, Char, Moves),
    nl, print('Next to play: '), print(Char),
    nl, print('Possible moves -> '), print(Moves),
    length(Moves, L),
    nl, print('Number of moves: '), print(L),
    L > 0).

letBotPlay(OldGameState, NewGameState) :-
    valid_moves(OldGameState, Moves),
    length(Moves, L),
    L > 0,
    getBot(OldGameState, Difficulty),
    ((Difficulty == 'easy', getRandomPlay(Moves, Play)) ; getRandomPlay(Moves, Play)), % meter a jogada do bot dificil
    getGameBoard(OldGameState, Board),
    updateBoard(OldGameState, Board, NewBoard, Play),
    updateGame(OldGameState, NewGameState, NewBoard, Play).


isItEndOfFirstRound(Game) :-
    getPlayerScore(Game, Score1),
    getPlayer2Score(Game, Score2),
    Sum is Score1 + Score2,
    nl, print('Score sum = '), print(Sum), nl,
    Sum =:= 0.

getRoundWinner(Game, Winner) :-
    getPlayerToPlay(Game, Player),
    getGameMode(Game, Gmode),
    (
    Gmode == 'botVplayer' -> (Player == 'player1' -> Winner = 'bot'; Winner = 'player1') ;
                             (Player == 'player1' -> Winner = 'player2' ; Winner = 'player1')),
    nl, print(Winner), print(' wins the round.').


getRandomPlay(Moves, SelectedPLay) :-
    length(Moves, L),
    Max is L-1,
    random(0, Max, R),
    nth0(R, Moves, SelectedPLay),
    nl, print('PLAY: '), print(R), print(' -> '), print(SelectedPLay).
%TO DO LIST:
  % quando a primeira ronda acaba começa a segunda. DONE
  % quando a segunda ronda acaba, anunciar o vencedor. A METADE
  % avaliar tabuleiro
  % fazer bots
