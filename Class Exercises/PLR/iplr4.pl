:-use_module(library(clpfd)).

puzzle(Vars) :-
  Vars = [S, E, N, D, M, O, R, Y],
  domain(Vars, 0, 9),
  S #> 0, M #> 0,
  all_different(Vars),
  1000 * S + 100 * E + 10 * N + D + 1000 * M + 100 * O + 10 * R + E #=
  10000 * M + 1000 * O + 100 * N + 10 * E + Y,
  labeling([], Vars).

send(Vars) :-
  Vars=[S,E,N,D,M,O,R,Y],
  domain(Vars,0,9),
  domain([C1,C2,C3,C4],0,1),
  all_distinct(Vars),
  S #\= 0, M #\= 0,
  D + E #= Y + C1*10,
  N + R + C1 #= E + C2*10,
  E + O + C2 #= N + C3*10,
  S + M + C3 #= O + C4*10,
  C4 #= M,
  labeling([ff],Vars).

problem(Vars) :-
  length(Vars,10),
  domain(Vars,1,100),
  all_distinct(Vars),
  Vars = [V|Vs],
  maximum(V,Vars),
  sum(Vs,#=,V),
  reset_timer,
  %labeling([],Vars),
  labeling([down],Vars),
  print_time,
  fd_statistics.

reset_timer :- statistics(walltime,_).
print_time :-
  statistics(walltime,[_,T]),
  TS is ((T//10)*10)/1000,
  nl, write('Time: '), write(TS), write('s'), nl, nl.

nqueens(N,Cols) :-
  length(Cols,N),
  domain(Cols,1,N),
  constrain(Cols),
  all_distinct(Cols), % redundante mas diminui tempo
  reset_timer,
  labeling([],Cols),
  print_time,
  fd_statistics.

constrain([]).
constrain([H|RCols]) :- safe(H,RCols,1), constrain(RCols).

safe(_,[],_).
safe(X,[Y|T],K) :- noattack(X,Y,K), K1 is K + 1, safe(X,T,K1).

noattack(X,Y,K) :- X #\= Y, X + K #\= Y, X - K #\= Y.
