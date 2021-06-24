% part 1
hasDivisorLessThanOrEqualTo(_,1) :- !, false.
hasDivisorLessThanOrEqualTo(X,Y) :- 0 is X mod Y, !.
hasDivisorLessThanOrEqualTo(X,Y) :- Z is Y - 1, hasDivisorLessThanOrEqualTo(X,Z).

isPrime(2) :- true,!.
isPrime(X) :- X < 2,!,false.
isPrime(X) :- not(hasDivisorLessThanOrEqualTo(X,X - 1)).

% part 2
isDigitList(_,[]) :- false.
isDigitList(X,[X]) :- X < 10,true,!.
isDigitList(X,[H|T]) :- X1 is floor(X/10), H is X mod 10, isDigitList(X1,T).

% part 3
isPalindrome([]) :- true,!.
isPalindrome([_]) :- true,!.
isPalindrome([X,X]) :- true,!.
isPalindrome(L) :- append([H|T], [H], L), isPalindrome(T),!.

% part 4
primePalindrome(X) :- isPrime(X), isDigitList(X,L1), isPalindrome(L1).





