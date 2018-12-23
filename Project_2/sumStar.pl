:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- include('facts.pl').
:- include('rules.pl').
:- include('generator.pl').

sumStar(1):-
  firstProblem(X),
  reset_timer,
  solveSimpleCase(X, R),
  print_time,
  fd_statistics,
  printSolutions(R).

sumStar(2):-
  secondProblem(X),
  reset_timer,
  solveSimpleCase(X, R),
  print_time,
  fd_statistics,
  printSolutions(R).

getAllSolutionsForFirst:-
  firstProblem(X),
  reset_timer,
  findall(R, (solveSimpleCase(X, R), nl, print(R)), _),
  print_time,
  fd_statistics.

getAllSolutionsForSecond:-
  secondProblem(X),
  reset_timer,
  findall(R, (solveSimpleCase(X, R), nl, print(R)), _),
  %findall(R, (solveSimpleCase(X, R), nl, print(R)), L),
  print_time,
  fd_statistics.

reset_timer :- statistics(walltime,_).
print_time :-
  statistics(walltime,[_,T]),
  TS is ((T//10)*10)/1000,
  nl, write('Time: '), write(TS), write('s'), nl, nl.

solveSimpleCase(ListOfLists, R):-
  % A = [A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13],
  % B = [B1, B2, B3, B4, B5, B6, B7, B8, B9, B10, B11, B12, B13],
  % C = [C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13],
  %nl, print('solving'),
  length(A, 13),
  length(B, 13),
  length(C, 13),
  global_cardinality(A, [0-4, 1-1, 2-1, 3-1, 4-1, 5-1, 6-1, 7-1, 8-1, 9-1]),
  global_cardinality(B, [0-4, 1-1, 2-1, 3-1, 4-1, 5-1, 6-1, 7-1, 8-1, 9-1]),
  global_cardinality(C, [0-4, 1-1, 2-1, 3-1, 4-1, 5-1, 6-1, 7-1, 8-1, 9-1]),
  nth0(0, ListOfLists, SumList1),
  nth0(1, ListOfLists, SumList2),
  nth0(2, ListOfLists, SumList3),
  simpleRestrictions(0, SumList1, A),
  simpleRestrictions(1, SumList2, B),
  simpleRestrictions(2, SumList3, C),
  doubleRestrictions(0, SumList1, [A, B]),
  doubleRestrictions(1, SumList2, [B, C]),
  doubleRestrictions(2, SumList3, [C, A]),
  tripleRestriction(SumList1, [A, B, C]),
  crossListShadedEdges([A, B, C]),
  shadedDontShareEdge(A),
  shadedDontShareEdge(B),
  shadedDontShareEdge(C),
  append(A, B, LT),
  append(LT, C, S),
  labeling([min], S),
  R = [A, B, C].
