:- use_module(library(system)).
:- use_module(library(lists)).
:- include('facts.pl').
:- include('game.pl').
:- include('ui.pl').
:- include('rules.pl').

frozenForest :- mainMenu.

playGame(G) :-
    % Verificar se a personagem que vai jogar tem movimentos validos
    % Ver se é o bot ou um dos jogadores a jogar
    % Dar oportunidade ao bot ou ao jogador de jogar
    checkIfnextCharCanMove(G),
    getGameMode(G, Gmode),
    (
        Gmode = 'botVplayer' -> (getHumanPlay(G, NG), letBotPlay(NG, FG), playGame(FG)) ;
        getHumanPlay(G, NG), playGame(NG)
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

getHumanPlay(OldGameState, NewGameState) :-
    getPlayerToPlay(OldGameState, Player), % s e é p1 ou p2
    getGameBoard(OldGameState, Board),
    repeat,
    %clearConsole,
    printBoardWithChars(OldGameState),
    askPlayerToInsertPlay(OldGameState, Coords), % notifica um dos jogadores
    checkIfCoordsAreValid(Coords),
    convertToMatrixCoords(Coords, NewCoords),
    checkPlayerPlans(OldGameState, NewCoords),
    updateBoard(OldGameState, Board, NewBoard, NewCoords),
    updateGame(OldGameState, NewGameState, NewBoard, NewCoords).

checkIfnextCharCanMove(Game) :-
    getCharTurn(Game, Char),
    valid_moves(Game, Moves), !,
    nl, print('Next to play: '), print(Char),
    nl, print('Possible moves -> '), print(Moves),
    length(Moves, L),
    nl, print('Number of moves: '), print(L),
    L > 0, pressEnterToContinue.

letBotPlay(OldGameState, NewGameState) :-
    print('Bot').

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



%TO DO LIST:
  % quando a primeira ronda acaba começa a segunda. DONE
  % quando a segunda ronda acaba, anunciar o vencedor. A METADE
  % avaliar tabuleiro
  % fazer bots
