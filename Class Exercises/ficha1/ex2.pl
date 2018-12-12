piloto('Lamb', 'Breitling', 'MX2').
piloto('Besenyei', 'Red Bull',  'Edge540').
piloto('Chambliss', 'Red Bull',  'Edge540').
piloto('MacLean', 'Mediterranean Racing Team', 'Edge540').
piloto('Mangold', 'Cobra', 'Edge540').
piloto('Jones', 'Matador', 'Edge540').
piloto('Bonhomme', 'Matador', 'Edge540').
circuito('Istanbul', 9, 'Mangold').
circuito('Budapest', 6, 'Mangold').
circuito('Porto', 5, 'Jones').
ganha(X, Y) :- circuito(Y,_, Z) , piloto(Z, X, _).
venceu2(P) :- piloto(P,_,_) , (C1, _ , P) , circuito(C2, _ , P), C1 \= C2.


/* a) circuito('Porto', _, X). */
/* b) ganha(Z, 'Porto'). */
/* c) */
/* d) circuito(X, N, _) , N > 8. */
/* e) piloto(X, _, Aviao), Aviao \= 'Edge540'. */