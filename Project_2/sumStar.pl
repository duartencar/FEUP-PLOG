:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- include('facts.pl').
:- include('rules.pl').

reset_timer :- statistics(walltime,_).
print_time :-
  statistics(walltime,[_,T]),
  TS is ((T//10)*10)/1000,
  nl, write('Time: '), write(TS), write('s'), nl, nl.

simpleRestrictions(0, SumList, ResultList):-
  nth0(0, SumList, Restriction1),
  valueOfElem(ResultList, 11, A1),
  valueOfElem(ResultList, 0, A2),
  valueOfElem(ResultList, 1, A3),
  A1+A2+A3 #= Restriction1,
  nth0(4, SumList, Restriction2),
  valueOfElem(ResultList, 7, A4),
  valueOfElem(ResultList, 8, A5),
  valueOfElem(ResultList, 9, A6),
  A4+A5+A6 #= Restriction2,
  nth0(5, SumList, Restriction3),
  valueOfElem(ResultList, 10, A7),
  A1+A6+A7 #= Restriction3.

simpleRestrictions(1, SumList, ResultList):-
  nth0(0, SumList, Restriction1),
  valueOfElem(ResultList, 11, A1),
  valueOfElem(ResultList, 0, A2),
  valueOfElem(ResultList, 1, A3),
  A1+A2+A3 #= Restriction1,
  nth0(1, SumList, Restriction2),
  valueOfElem(ResultList, 2, A4),
  valueOfElem(ResultList, 3, A5),
  A3+A4+A5 #= Restriction2,
  nth0(2, SumList, Restriction3),
  valueOfElem(ResultList, 4, A6),
  valueOfElem(ResultList, 5, A7),
  A5+A6+A7 #= Restriction3.

simpleRestrictions(2, SumList, ResultList):-
  nth0(2, SumList, Restriction1),
  valueOfElem(ResultList, 3, A1),
  valueOfElem(ResultList, 4, A2),
  valueOfElem(ResultList, 5, A3),
  A1+A2+A3 #= Restriction1,
  nth0(3, SumList, Restriction2),
  valueOfElem(ResultList, 6, A4),
  valueOfElem(ResultList, 7, A5),
  A3+A4+A5 #= Restriction2,
  nth0(4, SumList, Restriction3),
  valueOfElem(ResultList, 8, A6),
  valueOfElem(ResultList, 9, A7),
  A5+A6+A7 #= Restriction3.

% Restrições duplas em ciclo, começando pelo canto superior esquerdo

doubleRestrictions(0, SumList, [List1, List2]) :-
  nth0(1, SumList, Restriction),
  valueOfElem(List1, 1, A1),
  valueOfElem(List1, 2, A2),
  valueOfElem(List1, 3, A3),
  valueOfElem(List2, 9, A4),
  valueOfElem(List2, 10, A5),
  valueOfElem(List2, 11, A6),
  A1+A2+A3+A4+A5+A6 #= Restriction.

doubleRestrictions(1, SumList, [List1, List2]) :-
  nth0(3, SumList, Restriction),
  valueOfElem(List1, 5, A1),
  valueOfElem(List1, 6, A2),
  valueOfElem(List1, 7, A3),
  valueOfElem(List2, 1, A4),
  valueOfElem(List2, 2, A5),
  valueOfElem(List2, 3, A6),
  A1+A2+A3+A4+A5+A6 #= Restriction.

doubleRestrictions(2, SumList, [List1, List2]) :-
  nth0(5, SumList, Restriction),
  valueOfElem(List1, 9, A1),
  valueOfElem(List1, 10, A2),
  valueOfElem(List1, 11, A3),
  valueOfElem(List2, 5, A4),
  valueOfElem(List2, 6, A5),
  valueOfElem(List2, 7, A6),
  A1+A2+A3+A4+A5+A6 #= Restriction.

tripleRestriction(SumList, [List1, List2, List3]) :-
  nth0(2, SumList, Restriction),
  valueOfElem(List1, 3, A1),
  valueOfElem(List1, 4, A2),
  valueOfElem(List1, 5, A3),
  valueOfElem(List2, 7, A4),
  valueOfElem(List2, 8, A5),
  valueOfElem(List2, 9, A6),
  valueOfElem(List3, 11, A7),
  valueOfElem(List3, 0, A8),
  valueOfElem(List3, 1, A9),
  A1+A2+A3+A4+A5+A6+A7+A8+A9 #= Restriction.

solveSimpleCase(ListOfLists, Result):-
  Result = [L1, L2, L3],
  length(L1, 13),
  length(L2, 13),
  length(L3, 13),
  domain(L1,0,12),
  domain(L2,0,12),
  domain(L3,0,12),
  validAnswerList(L1),
  validAnswerList(L2),
  validAnswerList(L3),
  nth0(0, ListOfLists, SumList1),
  nth0(1, ListOfLists, SumList2),
  nth0(2, ListOfLists, SumList3),
  tripleRestriction(SumList1, [L1, L2, L3]),
  doubleRestrictions(0, SumList1, [L1, L2]),
  doubleRestrictions(1, SumList2, [L2, L3]),
  doubleRestrictions(2, SumList3, [L3, L1]),
  simpleRestrictions(0, SumList1, L1),
  simpleRestrictions(1, SumList2, L2),
  simpleRestrictions(2, SumList3, L3),
  all_distinct(L1),
  all_distinct(L2),
  all_distinct(L3),
  reset_timer,
  labeling([],Result),
  print_time,
  fd_statistics.
