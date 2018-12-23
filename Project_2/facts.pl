
% ['X', 4, 'X', 7, 6, 3, 'X', 5, 9, 8, 'X', 2, 1]

firstProblem(ListOfLists) :-
  ListOfLists = [
                [6, 33, 45, 11, 22, 10],
                [15, 3, 7, 11, 45, 33],
                [45, 11, 17, 13, 9, 11]
                ].

secondProblem(X) :-
  X = [
      [6, 20, 40, 30, 10, 3],
      [5, 7, 17, 36, 40, 20],
      [40, 36,21, 7, 7, 30]].

possibleAnswerOne(X) :- X = [12, 4, 11, 7, 6, 3, 10, 5, 9, 8, 0, 2, 1].

possibleAnswerTwo(X) :- X = [6, 0, 3, 10, 7, 11, 1, 2, 4, 8, 5, 9, 12].

possibleAnswerThree(X) :- X = [9, 5, 0, 3, 8, 6, 10, 7, 11, 2, 12, 1, 4].

printSolution([]) :- nl.

printSolution([H|T]) :-
	H =:= 0,
  print(' X'),
	printSolution(T).

printSolution([H|T]) :-
  print(' '),
	print(H),
	printSolution(T).

printSolutions(_, []).

printSolutions([H1|T1], [H|T]):-
  nl, print(H1), print(': '),
	printSolution(H), nl,
	printSolutions(T1, T).
