not(X) :- X, !, fail.
not(_).

getSumOfList([], 0).

getSumOfList([H|T], Sum) :-
  getSumOfList(T, OtherSum),
  value(H, V),
  Sum #= OtherSum + V.

shadedCenterNoShadedSquares(List):-
  element(13, List, Center),
  Center #= 0,
  element(1, List, L1),
  element(3, List, L2),
  element(5, List, L3),
  element(7, List, L4),
  element(9, List, L5),
  element(11, List, L6),
  Center + L1 #\= 0,
  Center + L2 #\= 0,
  Center + L3 #\= 0,
  Center + L4 #\= 0,
  Center + L5 #\= 0,
  Center + L6 #\= 0.

shadedCenterNoShadedSquares(List):-
  element(13, List, Center),
  Center #\= 0.

shadedDontShareEdge(List, 11):-
  element(11, List, 0).

simpleRestrictions(0, SumList, [A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13]):-
  nth0(0, SumList, Restriction1),
  nth0(4, SumList, Restriction2),
  nth0(5, SumList, Restriction3),
  A1 + A2 + A12 #= Restriction1,
  A8 + A9 + A10 #= Restriction2,
  A12 + A11 + A10 #= Restriction3.

simpleRestrictions(1, SumList, [B1, B2, B3, B4, B5, B6, B7, B8, B9, B10, B11, B12, B13]):-
  nth0(0, SumList, Restriction1),
  nth0(1, SumList, Restriction2),
  nth0(2, SumList, Restriction3),
  B12 + B1 + B2 #= Restriction1,
  B2 + B3 + B4 #= Restriction2,
  B4 + B5 + B6 #= Restriction3.

simpleRestrictions(2, SumList, [C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13]):-
  nth0(2, SumList, Restriction1),
  nth0(3, SumList, Restriction2),
  nth0(4, SumList, Restriction3),
  C4 + C5 + C6 #= Restriction1,
  C6 + C7 + C8 #= Restriction2,
  C8 + C9 + C10 #= Restriction3.

% Restrições duplas em ciclo, começando pelo canto superior esquerdo

doubleRestrictions(0, SumList, [A, B]) :-
  nth0(1, SumList, Restriction),
  element(2, A, V1),
  element(3, A, V2),
  element(4, A, V3),
  element(12, B, V4),
  element(11, B, V5),
  element(10, B, V6),
  V1+V2+V3+V4+V5+V6 #= Restriction.

doubleRestrictions(1, SumList, [B, C]) :-
  nth0(3, SumList, Restriction),
  element(6, B, V1),
  element(7, B, V2),
  element(8, B, V3),
  element(2, C, V4),
  element(3, C, V5),
  element(4, C, V6),
  V1+V2+V3+V4+V5+V6 #= Restriction.

doubleRestrictions(2, SumList, [C, A]) :-
  nth0(5, SumList, Restriction),
  element(10, C, V1),
  element(11, C, V2),
  element(12, C, V3),
  element(6, A, V4),
  element(7, A, V5),
  element(8, A, V6),
  V1+V2+V3+V4+V5+V6 #= Restriction.

tripleRestriction(SumList, [A, B, C]) :-
  nth0(2, SumList, Restriction),
  element(4, A, V1),
  element(5, A, V2),
  element(6, A, V3),
  element(8, B, V4),
  element(9, B, V5),
  element(10, B, V6),
  element(1, C, V7),
  element(2, C, V8),
  element(12, C, V9),
  V1+V2+V3+V4+V5+V6+V7+V8+V9 #= Restriction.

crossListShadedEdges([A, B, C]) :-
  element(4, A, VA1),
  element(6, A, VA2),
  element(8, B, VB1),
  element(10, B, VB2),
  element(2, C, VC1),
  element(12, C, VC2),
  VA1 + VB2 #\= 0,
  VB1 + VC1 #\= 0,
  VC2 + VA2 #\= 0.

validAnswerList(List) :-
  getSumOfList(List, Sum),
  Sum #= 45,
  shadedDoesntShareEdge(List).
