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
%   1: player or bot score
%   2: other player score
%   3: yuki coordinates
%   4: mina 
%   5: character turn
%   6: gameMode

createPlayerVsPlayerGame(G) :- initialBoard(Board), G = [Board, 0, 0, [-1,-1], [-1, -1], yuki, playerVplayer].

createPlayerVsBotGame(G) :- initialBoard(Board), G = [Board, 0, 0, [-1,-1], [-1, -1], yuki, botVplayer].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%