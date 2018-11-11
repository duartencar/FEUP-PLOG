:- use_module(library(system)).
:- use_module(library(lists)).
:- include('game.pl').
:- include('ui.pl').


frozenForest :- mainMenu.

playGame(G) :-
    % Verificar se a personagem que vai jogar tem movimentos validos
    % Ver se é o bot ou um dos jogadores a jogar
    % Dar oportunidade ao bot ou ao jogador de jogar
    getHumanPlay(G, NG),
    playGame(NG).

getHumanPlay(OldGameState, NewGameState) :-
    getGameBoard(OldGameState, Board),
    getPlayerToPlay(OldGameState, Player), % s e é p1 ou p2
    repeat,
    %clearConsole,
    printBoard(Board),
    askPlayerToInsertPlay(Player, Coords), % notifica um dos jogadores
    checkIfCoordsAreValid(Coords),
    convertToMatrixCoords(Coords, NewCoords),
    %verificar se é possível mover personagem para as coordenadas,
    updateBoard(OldGameState, Board, NewBoard, NewCoords),
    updateGame(OldGameState, NewGameState, NewBoard, NewCoords).
    
    
    