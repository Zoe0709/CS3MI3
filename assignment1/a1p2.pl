isExpr(constE(X)) :- true,!.
isExpr(negE(X)) :- true,!.
isExpr(absE(X)) :- true,!.
isExpr(plusE(X,Y)) :- isExpr(X), isExpr(Y).
isExpr(timesE(X,Y)) :- isExpr(X), isExpr(Y).
isExpr(minusE(X,Y)) :- isExpr(X), isExpr(Y).
isExpr(expE(X,Y)) :- isExpr(X), isExpr(Y).

interpretExpr(constE(A),X) :- X is A.
interpretExpr(negE(A),X) :- interpretExpr(A,X1), X is X1 * (-1).
interpretExpr(absE(A),X) :- interpretExpr(A,X1), X is abs(X1).
interpretExpr(plusE(A,B),X) :- interpretExpr(A,X1), interpretExpr(B,X2), X is X1 + X2.
interpretExpr(timesE(A,B),X) :- interpretExpr(A,X1), interpretExpr(B,X2), X is X1 * X2.
interpretExpr(minusE(A,B),X) :- interpretExpr(A,X1), interpretExpr(B,X2), X is X1 - X2.
interpretExpr(expE(A,B),X) :- interpretExpr(A,X1), interpretExpr(B,X2), pow(X1,X2,X).


