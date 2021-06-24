isVarExpr(constE(X)) :- true,!.
isVarExpr(negE(X)) :- true,!.
isVarExpr(absE(X)) :- true,!.
isVarExpr(plusE(X,Y)) :- isVarExpr(X), isVarExpr(Y).
isVarExpr(timesE(X,Y)) :- isVarExpr(X), isVarExpr(Y).
isVarExpr(minusE(X,Y)) :- isVarExpr(X), isVarExpr(Y).
isVarExpr(expE(X,Y)) :- isVarExpr(X), isVarExpr(Y).
isVarExpr(var(V)) :- true,!.
isVarExpr(subst(S1,SV,S2)) :- isVarExpr(S1), isVarExpr(V), isVarExpr(S2).

interpretVarExpr(constE(A),X) :- X is A.
interpretVarExpr(negE(A),X) :- interpretVarExpr(A,X1), X is X1 * (-1).
interpretVarExpr(absE(A),X) :- interpretVarExpr(A,X1), X is abs(X1).
interpretVarExpr(plusE(A,B),X) :- interpretVarExpr(A,X1), interpretVarExpr(B,X2), X is X1 + X2.
interpretVarExpr(timesE(A,B),X) :- interpretVarExpr(A,X1), interpretVarExpr(B,X2), X is X1 * X2.
interpretVarExpr(minusE(A,B),X) :- interpretVarExpr(A,X1), interpretVarExpr(B,X2), X is X1 - X2.
interpretVarExpr(expE(A,B),X) :- interpretVarExpr(A,X1), interpretVarExpr(B,X2), pow(X1,X2,X).
interpretVarExpr(subst(S1,SV,S2),X) :- substitution(S1,SV,S2,X1), interpretVarExpr(X1,X).

substitution(plusE(A,B),SV,E,X) :- 
	( A == var(SV), X = plusE(E,B)
	; B == var(SV), X = plusE(A,E)).
substitution(timesE(A,B),SV,E,X) :- 
	( A == var(SV), X = timesE(E,B)
	; B == var(SV), X = timeE(A,E)).
substitution(minusE(A,B),SV,E,X) :- 
	( A == var(SV), X = minusE(E,B)
	; B == var(SV), X = minusE(A,E)).
substitution(expE(A,B),SV,E,X) :- 
	( A == var(SV), X = expE(E,B)
	; B == var(SV), X = expE(A,E)).
substitution(var(V),SV,E,X) :- V == SV, X = E.
substitution(subst(S1,SV1,S2),SV2,E,X) :- substitution(S1,SV1,S2,X1), substitution(X1,SV2,E,X).

