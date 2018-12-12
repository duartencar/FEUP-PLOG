append([], L, L).
append([X|L1], L2, [X, L3]):- append(L1, L2, L3).

invert(L, InvL):- rev(L, [], InvL).
rev([H|T], S, R):- rev(T, [H|S], R).
rev([], R, R).

membro([H|_], X) :- H = X.
membro([_|T], X) :- membro(T, X).