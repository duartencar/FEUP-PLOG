:-use_module(library(clpfd)).

carteiro(N, S, SDist):-
  length(S, N),
  domain(S, 1, N),
  all_distinct(S),
  sum_dist(S, SDist),
  element(N, S, 6),
  labeling([maximize(SDist)], S).


sum_dist([_], 0).

sum_dist([A, B|R], D):-
  D #= abs(A-B) + RD,
  sum_dist([B|R], RD).
