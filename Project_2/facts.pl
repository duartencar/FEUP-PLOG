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

value('X', 0).
value(0, 0).
value(1, 1).
value(2, 2).
value(3, 3).
value(4, 4).
value(5, 5).
value(6, 6).
value(7, 7).
value(8, 8).
value(9, 9).

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

% ['X', 4, 'X', 7, 6, 3, 'X', 5, 9, 8, 'X', 2, 1]

simpleDod(X) :-
  X = [6, 33, 45, 11, 22, 10].

solveSimpleDod(Dod, Answer) :-
  length(S, 13),
  all_distinct(S).
