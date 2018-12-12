:-use_module(library(clpfd)).

guards(Vars) :-
  Vars = [S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12],
  domain(Vars, 0, 5),
  sum(Vars, #=, 12),
  S1 + S2 + S3 + S4 #= 5,
  S4 + S5 + S6 + S7 #= 5,
  S7 + S8 + S9 + S10 #= 5,
  S10 + S11 + S12 + S1 #= 5,
  labeling([], Vars).
