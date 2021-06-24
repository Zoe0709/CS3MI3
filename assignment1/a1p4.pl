isMixedExpr(constE(X)) :- true,!.
isMixedExpr(negE(X)) :- true,!.
isMixedExpr(absE(X)) :- true,!.
isMixedExpr(plusE(X,Y)) :- isMixedExpr(X), isMixedExpr(Y).
isMixedExpr(timesE(X,Y)) :- isMixedExpr(X), isMixedExpr(Y).
isMixedExpr(minusE(X,Y)) :- isMixedExpr(X), isMixedExpr(Y).
isMixedExpr(expE(X,Y)) :- isMixedExpr(X), isMixedExpr(Y).
isMixedExpr(tt) :- true,!.
isMixedExpr(ff) :- true,!.
isMixedExpr(bnot(X)) :- isMixedExpr(X).
isMixedExpr(band(X,Y)) :- isMixedExpr(X), isMixedExpr(Y).
isMixedExpr(bor(X,Y)) :- isMixedExpr(X), isMixedExpr(Y).



interpretMixedExpr(constE(A),X) :- X is A.
interpretMixedExpr(negE(A),X) :- interpretMixedExpr(A,X1), X is X1 * (-1).
interpretMixedExpr(absE(A),X) :- interpretMixedExpr(A,X1), X is abs(X1).
interpretMixedExpr(plusE(A,B),X) :- interpretMixedExpr(A,X1), interpretMixedExpr(B,X2), X is X1 + X2.
interpretMixedExpr(timesE(A,B),X) :- interpretMixedExpr(A,X1), interpretMixedExpr(B,X2), X is X1 * X2.
interpretMixedExpr(minusE(A,B),X) :- interpretMixedExpr(A,X1), interpretMixedExpr(B,X2), X is X1 - X2.
interpretMixedExpr(expE(A,B),X) :- interpretMixedExpr(A,X1), interpretMixedExpr(B,X2), pow(X1,X2,X).
interpretMixedExpr(tt,X) :- X = true.
interpretMixedExpr(ff,X) :- X = false.
interpretMixedExpr(bnot(A),X) :- interpretMixedExpr(A,X1), \+ X = X1.
interpretMixedExpr(band(A,B),X) :- 
	( interpretMixedExpr(A,X1), X1 = true, interpretMixedExpr(B,X2), X2 = true, X = true
	; interpretMixedExpr(A,X1), X1 = true, interpretMixedExpr(B,X2), X2 = false, X = false
	; interpretMixedExpr(A,X1), X1 = false, interpretMixedExpr(B,X2), X2 = true, X = false
	; interpretMixedExpr(A,X1), X1 = false, interpretMixedExpr(B,X2), X2 = false, X = false).
interpretMixedExpr(bor(A,B),X) :- interpretMixedExpr(A,X);interpretMixedExpr(B,X).








