% part 1
leaf(A).
branch(X,Y).

empty.
node(X,A,Y).

% True if S is a sorted copy of M
mySort([],[]) :- true,!.
mySort([X],[X]) :- true,!.
mySort(M,S) :- split(M,L,R), mySort(L,SL), mySort(R,SR), merge(SL,SR,S).

split([],[],[]) :- true,!.
split([X],[X],[]) :- true,!.
split([L,R|T],[L|LT],[R|RT]) :- split(T,LT,RT).

merge(LS,[],LS) :- true,!.
merge([],RS,RS) :- true,!.
merge([L|LS],[R|RS],[L|T]) :- L =< R, merge(LS,[R|RS],T).
merge([L|LS],[R|RS],[R|T]) :- L > R, merge([L|LS],RS,T).

% LeafTree flatten
flatten(leaf(A),[L]) :- L is A.
flatten(branch(X,Y),L) :- flatten(X,L1), flatten(Y,L2), append(L1,L2,L).

% BinTree flatten
flatten(empty,[]).
flatten(node(X,A,Y),L) :- flatten(X,L1), flatten(Y,L2), append(L1,[A|L2],L).

% LeafTree elemsOrdered
elemsOrdered(T,S) :- flatten(T,L), mySort(L,S).

% BinTree elemsOrdered
elemsOrdered(T,S) :- flatten(T,L), mySort(L,S).