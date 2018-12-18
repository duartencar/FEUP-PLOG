not(X) :- X, !, fail.
not(_).

getSumOfList([], 0).

getSumOfList([H|T], Sum) :-
  getSumOfList(T, OtherSum),
  value(H, V),
  Sum is OtherSum + V.

shadedDoesntShareEdge(List):-
  %print('1'), nl,
  shadedHexagon(List),
  findall(X, shadedSquare(List, X), R),
  %print('Primeiro: '), print(R), !,
  length(R, 0).

shadedDoesntShareEdge(List):-
  %print('2'), nl,
  shadedSquare(List, 0),
  not(shadedTriangle(List, 11)),
  findall((X, Y), (shadedSquare(List, X), Y #= X+1, shadedTriangle(List, Y)), R),
  %print('Segundo: '), print(R),
  length(R, 0).

shadedDoesntShareEdge(List):-
  %print('3'), nl,
  not(shadedSquare(List, 0)),
  findall(X, (shadedSquare(List, X), Y #= X+1, shadedTriangle(List, Y)), R),
  %print('Terceiro: '), print(R),
  length(R, 0).

validAnswerList(List) :-
  getSumOfList(List, Sum),
  Sum #= 45,
  length(List, 13),
  shadedDoesntShareEdge(List).
