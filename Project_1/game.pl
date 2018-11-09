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

gmode(playerVplayer).
gmode(botVplayer).

gameChar(yuki).
gameChar(mina).

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

createPlayerVsPlayerGame(G) :- initialBoard(Board), G = [Board, 0, 0, [-1,-1], [-1, -1], yuki, playerVplayer].

createPlayerVsBotGame(G, Bot) :- initialBoard(Board), G = [Board, 0, 0, [-1,-1], [-1, -1], yuki, botVplayer, Bot].

getGameBoard(G, Board) :- nth0(0, G, Board).

getPlayerScore(G, Score) :- nth0(1, G, Score).

getPlayer2Score(G, Score) :- nth0(2, G, Score).

getBotScore(G, Score) :- nth0(2, G, Score).

getYukiCoordinates(G, Coords) :- nth0(3, G, Coords).

getMinaCoordinates(G, Coords) :- nth0(4, G, Coords).

getCharTurn(G, Char) :- nth0(5, G, Char).

getGameMode(G, Gmode) :- nth0(6, G, Gmode).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%