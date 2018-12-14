not(X) :- X, !, fail.
not(_).

getSumOfList([], 0).

getSumOfList([H|T], Sum) :-
  getSumOfList(T, OtherSum),
  value(H, V),
  Sum is OtherSum + V.

% Checks if all members of a list are different except if they are 'X'
allDiferent([]).
% allDiferent([H|T]):-
%   (H == 'X',
%   allDiferent(T)) ;
%   (not(member(H, T)),
%   allDiferent(T)).
allDiferent([H|T]):-
  (H =:= 0,
  allDiferent(T)) ;
  (not(member(H, T)),
  allDiferent(T)).

shadedDoesntShareEdge(List):-
  nth0(12, List, Elem),
  Elem =:= 0,
  findall(X, (square(X), X =\= 12, nth0(X, List, Elem), Elem =:= 0), R),
  length(R, 0).

shadedDoesntShareEdge(List):-
  nth0(0, List, FirstElem),
  FirstElem =:= 0,
  nth0(11, List, LastElem),
  LastElem \= FirstElem,
  findall(X, (square(X), nth0(X, List, Elem), Elem =:= 0, Y is X+1, nth0(Y, List, Elem2), Elem2 =:= 0), R),
  print(R),
  length(R, 0).

shadedDoesntShareEdge(List):-
  findall(X, (square(X), nth0(X, List, Elem), Elem =:= 0, Y is X+1, nth0(Y, List, Elem2), Elem2 =:= 0), R),
  print(R),
  length(R, 0).

validAnswerList(List) :-
  getSumOfList(List, Sum),
  Sum =:= 45,
  length(List, 13),
  allDiferent(List),
  shadedDoesntShareEdge(List).
