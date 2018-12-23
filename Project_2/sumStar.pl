:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- include('facts.pl').
:- include('rules.pl').
:- include('generator.pl').

sumStar(1):-
  firstProblem(X),
  nl, print('Solving -> '), print(X), nl,
  reset_timer,
  solveSimpleCase(X, R),
  print_time,
  fd_statistics,
  printSolutions(['A', 'B', 'C'], R).

sumStar(2):-
  secondProblem(X),
  nl, print('Solving -> '), print(X), nl,
  reset_timer,
  solveSimpleCase(X, R),
  print_time,
  fd_statistics,
  printSolutions(['A', 'B', 'C'], R).

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
  print_time,
  fd_statistics.

reset_timer :- statistics(walltime,_).
print_time :-
  statistics(walltime,[_,T]),
  TS is ((T//10)*10)/1000,
  nl, write('Time: '), write(TS), write('s'), nl, nl.

solveSimpleCase(ListOfLists, R):-
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
