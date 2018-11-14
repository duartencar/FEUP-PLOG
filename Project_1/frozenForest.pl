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
    nl,
    print('END').

getHumanPlay(OldGameState, NewGameState) :-
    getPlayerToPlay(OldGameState, Player), % s e é p1 ou p2
    getGameBoard(OldGameState, Board),
    repeat,
    %clearConsole,
    printBoardWithChars(OldGameState),
    askPlayerToInsertPlay(Player, Coords), % notifica um dos jogadores
    checkIfCoordsAreValid(Coords),
    convertToMatrixCoords(Coords, NewCoords),
    checkPlayerPlans(OldGameState, NewCoords),
    updateBoard(OldGameState, Board, NewBoard, NewCoords),
    updateGame(OldGameState, NewGameState, NewBoard, NewCoords).

checkIfnextCharCanMove(Game) :-
    getCharTurn(Game, Char),
    Char = 'yuki' -> checkIfYukiHasMoves(Game) ; checkIfMinaHasMoves(Game).

letBotPlay(OldGameState, NewGameState) :-
    print('Bot').
    
    
    