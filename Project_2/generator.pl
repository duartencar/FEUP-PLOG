
generate(Problem):-
  %nl, print('generating'),
  A = [A1, A2, A3, A4, A5, A6],
  B = [B1, B2, B3, B4, A3, A2],
  C = [A3, B4, C1, C2, C3, A4],
  domain(A, 3, 45),
  domain(B, 3, 45),
  domain(C, 3, 45),
  all_distinct(A),
  all_distinct(B),
  all_distinct(C),
  restrictDodecagonAllTypes(A),
  restrictDodecagonAllTypes(B),
  restrictDodecagonAllTypes(C),
  setHiearchyTripeDoubles([A3, A2, B4, A4]),
  setHiearchyDoubleSingles([A2, A4, A5, A6, A1]),
  setHiearchyDoubleSingles([A2, B4, B1, B2, B3]),
  setHiearchyDoubleSingles([B4, A4, C1, C2, C3]),
  allSinglesBoundries([A1, A4, A5, B1, B2, B3, C1, C2, C3]),
  restrictCenter(A3),
  restrictDoubles(A2),
  restrictDoubles(A4),
  restrictDoubles(B4),
  restrictSingles(A1),
  restrictSingles(A5),
  restrictSingles(A6),
  restrictSingles(B1),
  restrictSingles(B2),
  restrictSingles(B3),
  restrictSingles(C1),
  restrictSingles(C2),
  restrictSingles(C3),
  restrictDodecagonSingles([A1, A5, A6]),
  restrictDodecagonSingles([B1, B2, B3]),
  restrictDodecagonSingles([C1, C2, C3]),
  restrictProblemDoubles([A2, A4, B4]),

  append(A, B, LT),
  append(LT, C, S),
  labeling([], S),
  Problem = [A, B, C].
  %nl, print('generated -> '), print(Problem).

restrictCenter(Center):-
  Center #>= 20,
  Center #=< 45.

restrictDoubles(Double):-
  Double #>= 11,
  Double #=< 39.

restrictSingles(Single):-
  Single #>= 3,
  Single #=< 24.

restrictDodecagonSingles([S1, S2, S3]):-
  S1 + S2 + S3 #>= 15,
  S1 + S2 + S3 #=< 39.

restrictProblemDoubles([D1, D2, D3]) :-
  D1 + D2 + D3 #>= 19,
  D1 + D2 + D3 #=< 117.

restrictDodecagonAllTypes([T1, T2, T3, T4, T5, T6]) :-
  T1 + T2 + T3 + T4 + T5 + T6 #>= 48,
  T1 + T2 + T3 + T4 + T5 + T6 #=< 63.

setHiearchyTripeDoubles([Center, D1, D2, D3]) :-
  Center #> D1,
  Center #> D2,
  Center #> D3.

setHiearchyDoubleSingles([D1, D2, S1, S2, S3]) :-
  D1 + D2 #> S1,
  D1 + D2 #> S2,
  D1 + D2 #> S3.

allSinglesBoundries([S1, S2, S3, S4, S5, S6, S7, S8, S9]) :-
  S1 + S2 + S3 + S4 + S5 + S6 + S7 + S8 + S9 #> 31,
  S1 + S2 + S3 + S4 + S5 + S6 + S7 + S8 + S9 #< 55.
