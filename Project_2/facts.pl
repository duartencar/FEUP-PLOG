index(0).
index(1).
index(2).
index(3).
index(4).
index(5).
index(6).
index(7).
index(8).
index(9).
index(10).
index(11).
index(12).

%value('X', 0).
value(1, 1).
value(2, 2).
value(3, 3).
value(4, 4).
value(5, 5).
value(6, 6).
value(7, 7).
value(8, 8).
value(9, 9).
value(0, 0).
value(10, 0).
value(11, 0).
value(12, 0).

triangle(1).
triangle(3).
triangle(5).
triangle(7).
triangle(9).
triangle(11).

square(0).
square(2).
square(4).
square(6).
square(8).
square(10).

hexagon(12).

% ['X', 4, 'X', 7, 6, 3, 'X', 5, 9, 8, 'X', 2, 1]

simpleDod(X) :-
  X = [
      [6, 33, 45, 11, 22, 10],
      [15, 3, 7, 11, 45, 33],
      [45, 11, 17, 13, 9, 11]].

possibleAnswerOne(X) :- X = [12, 4, 11, 7, 6, 3, 10, 5, 9, 8, 0, 2, 1].

possibleAnswerTwo(X) :- X = [6, 0, 3, 10, 7, 11, 1, 2, 4, 8, 5, 9, 12].

possibleAnswerThree(X) :- X = [9, 5, 0, 3, 8, 6, 10, 7, 11, 2, 12, 1, 4].

shadedSquare(List, Index) :-
  square(Index),
  nth0(Index, List, Elem),
  value(Elem, 0).

shadedTriangle(List, Index) :-
  triangle(Index),
  nth0(Index, List, Elem),
  value(Elem, 0).

shadedHexagon(List):-
  nth0(12, List, Elem),
  value(Elem, 0).

valueOfElem(List, Index, Value) :-
  nth0(Index, List, Elem),
  value(Elem, Value).

printSolution([]) :- nl.

printSolution([H|T]) :-
	value(H, 0),
	print('X'),
	printSolution(T).
printSolution([H|T]) :-
	print(H),
	printSolution(T).

printSolutions([]).

printSolutions([H|T]):-
	printSolution(H),
	printSolutions(T).
