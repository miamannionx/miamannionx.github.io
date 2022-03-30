/* Dual Clause Form Program
Propositional operators are: neg, and, or, imp, revimp, uparrow, downarrow, notimp and notrevimp. 
*/

?-op(140, fy, neg).
?-op(160, xfy, [and, or, imp, revimp, uparrow, downarrow, notimp, notrevimp]).

/* neg(Item) :- Unary operator that returns negation of Item. */

neg(X) :- not(X).

/* and(X, Y) :- Binary operator that returns whether X and Y evaluates to True. */

and(X, Y) :- X,Y.

/* or(X, Y) :- Binary operator that returns whether X or Y evaluates to True. */

or(X, Y) :- X;Y.

/* imp(X, Y) :- Binary operator that returns whether X implies Y. */

imp(X, Y) :- neg(X);Y.

/* revimp(X, Y) :- Binary operator that returns whether X reverse implies Y. */

revimp(X, Y) :- X;neg(Y).

/* uparrow(X, Y) :- Binary operator that returns whether X XOR Y (Not X or Not Y). */

uparrow(X, Y) :- neg(X);neg(Y).

/* downarrow(X, Y) :- Binary operator that returns whether X XAND Y (Not X and Not Y). */

downarrow(X, Y) :- neg(X),neg(Y).

/* notimp(X, Y) :- Binary operator that returns the negation of X implies Y. */

notimp(X, Y) :- neg(X;neg(Y)).

/* notimp(X, Y) :- Binary operator that returns the negation of X reverse implies Y. */

notimp(X, Y) :- neg(X;neg(Y)).

/* member(Item, List) :- Item occurs in List. */ 

member(X, [X | _]).

member(X, [_ | Tail]) :- 
    member(X, Tail).

/* remove(Item, List, Newlist) :- Newlist is the result of removing all occurences of Item from List. */

remove(X, [], []).

remove(X, [X | Tail], Newtail) :-
    remove(X, Tail, Newtail).

remove(X, [Head | Tail], [Head | Newtail]) :-
    remove(X, Tail, Newtail).

/* conjuctive(X) :- X is an alpha formula. */

conjunctive(_ and _).
conjunctive(neg(_ or _)).
conjunctive(neg(_ imp _)).
conjunctive(neg(_ revimp _)).
conjunctive(neg(_ uparrow _)).
conjunctive(_ downarrow _).
conjunctive(_ notimp _).
conjunctive(_ notrevimp _).

/* disjunctive(X) :- X is a beta formula. */

disjunctive(neg(_ and _)).
disjunctive(_ or _).
disjunctive(_ imp _).
disjunctive(_ revimp _).
disjunctive(_ uparrow _).
disjunctive(neg(_ downarrow _)).
disjunctive(neg(_ notimp _)).
disjunctive(neg(_ notrevimp _)). 

/* unary(X) :- X is a double negation, or a negated constant. */

unary(neg neg _).
unary(neg true).
unary(neg false).

/* components(X, Y, Z) :- Y and Z are the components of the formula X, as defined in the alpha and beta tables. */

components(X and Y, X, Y).
components(neg(X and Y), neg X, neg Y).
components(X or Y, X, Y).
components(neg(X or Y), neg X, neg Y).
components(X imp Y, neg X, Y).
components(neg(X imp Y), X, neg Y). 
components(X revimp Y, X, neg Y).
components(neg(X revimp Y), neg X, Y).
components(X uparrow Y, neg X, neg Y).
components(neg(X uparrow Y), X, Y).
components(X downarrow Y, neg X, neg Y).
components(neg(X downarrow Y), X, Y).
components(X notimp Y, X, neg Y).
components(neg(X notimp Y), neg X, Y).
components(X notrevimp Y, neg X, Y).
components(neg(X notrevimp Y), X, neg Y).

/* component(X, Y) :- Y is the component of the unary formula X. */

component(neg neg X, X).
component(neg true, false).
component(neg false, true).

/* singlestep(Old, New) :- New is the result of applying a single step of the expansion process to Old, which is a generalized disjunction of generalized conjunctions. */

singlestep([Conjunction | Rest], New) :-
    member(Formula, Conjunction),
    unary(Formula),
    component(Formula, Newformula),
    remove(Formula, Conjunction, Temporary),
    Newconjunction = [Newformula | Temporary],
    New = [Newconjunction | Rest].

singlestep([Conjunction | Rest], New) :-
    member(Alpha, Conjunction),
    conjunctive(Alpha) ,
    components(Alpha, Alphaone, Alphatwo),
    remove(Alpha, Conjunction, Temporary),
    Newcon = [Alphaone, Alphatwo | Temporary],
    New = [Newcon | Rest].

singlestep([Conjunction | Rest], New) :-
    member(Beta, Conjunction),
    disjunctive(Beta),
    components(Beta, Betaone, Betatwo), 
    remove(Beta, Conjunction, Temporary),
    Newconone = [Betaone | Temporary],
    Newcontwo = [Betatwo | Temporary],
    New = [Newconone, Newcontwo | Rest].

singlestep([Conjunction | Rest], [Conjunction | Newrest]) :-
    singlestep(Rest, Newrest).

/* expand(Old, New) :- New is the result of applying singlestep as many times as possible, starting with Old. */

expand(Dis, Newdis) :-
    singlestep(Dis, Temp),
    expand(Temp, Newdis).

expand(Dis, Dis).

/* dualclauseform(X, Y) :- Y is the dual clause form of X. */

dualclauseform(X, Y) :- expand([[X]], Y).

/* closed(Tableau) :- every branch of Tableau contains a contradiction. */

closed([Branch | Rest]) :-
    member(false, Branch),
    closed(Rest).

closed([Branch | Rest]) :-
    member(X, Branch),
    member(neg X, Branch),
    closed(Rest).

closed([]).

/* test(X) :- create a complete Tableau expansion for neg X, and see if it is closed.*/

test(X) :-
    if_then_else(expand_and_close([[neg X]]), yes, no).

yes :-
    write(yes).

no :-
    write(no).

/* if_then_else(P, Q, R) :- either P and Q, or not P and not R. */

if_then_else(P, Q, R) :- 
    P,
    !,
    Q.

if_then_else(P, Q, R) :-
    R.

/* expand_and_close(Tableau) :- some expansion of Tableau closes. */
    
expand_and_close(Tableau) :-
    closed(Tableau).

expand_and_close(Tableau) :-
    singlestep(Tableau, NewTableau),
    !,
    expand_and_close(NewTableau).