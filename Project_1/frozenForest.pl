:- use_module(library(system)).
:- use_module(library(lists)).
:- include('game.pl').
:- include('ui.pl').

frozenForest :- mainMenu.

playGame(G) :- getGameBoard(G, Board), clearConsole, printBoard(Board), getChar(Option).