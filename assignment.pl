/* 2 statements that is used to define how member() work
First statement is the base condition where X is found at head of list
Second statement is a recursive statement where member() is asked to run again
on a remaining list R which results from removing the head element of the list.
So we are calling member() again on list R which is the second element
of the original list to find X.*/
member(X,[X|_]).
member(X,[_|R]) :- member(X,R).


takeout(X,[X|R],R).
takeout(X,[F|R],[F|S]) :-
	takeout(X,R,S).
	
append([A | B], C, [A | D]) :- 
	append(B, C, D).
append([], A, A).

/*did assertion here to make predicate dynamic*/
ask(0):-
	assert(action([learn, play, eat, clean, sports])),
	assert(learnlist([alphabets, numbers, baking, spelling, grammar, music])),
	assert(playlist([slides, swing, sandbox, toys])),
	assert(eatlist([apple, orange, banana, pizza, spaghetti, bread, ice_cream, cake, chips])),
	assert(cleanlist([sweeping_the_classroom, cleaning_the_whiteboard, wiping_tables])),
	assert(sportslist([soccer, swimming, badminton, tennis])),
	print('Hey...What did you do today?'), validate_and_query_options(learn).

/*X here should be an element of a list.
So i first get a list that contain one element from generateoptions().
and i delete that element from the actual list before querying*/	
ask(X):-
	action(Z), member(X,Z), generate_options(X,L), member(Y,L), takeout(X,Z,Result), retract(action(Z)), assert(action(Result)), assert(actionhistory(X)), validate_and_query_options(Y);
	learnlist(Z), member(X,Z), generate_options(X,L), member(Y,L), takeout(X,Z,Result), retract(learnlist(Z)), assert(learnlist(Result)), assert(learnhistory(X)),validate_and_query_options(Y);
	playlist(Z), member(X,Z), generate_options(X,L), member(Y,L), takeout(X,Z,Result), retract(playlist(Z)), assert(playlist(Result)), assert(playhistory(X)),validate_and_query_options(Y);
	eatlist(Z), member(X,Z), generate_options(X,L), member(Y,L), takeout(X,Z,Result), retract(eatlist(Z)), assert(eatlist(Result)), assert(eathistory(X)),validate_and_query_options(Y);
	cleanlist(Z), member(X,Z), generate_options(X,L), member(Y,L), takeout(X,Z,Result), retract(cleanlist(Z)), assert(cleanlist(Result)), assert(cleanhistory(X)),validate_and_query_options(Y);
	sportslist(Z), member(X,Z), generate_options(X,L), member(Y,L), takeout(X,Z,Result), retract(sportslist(Z)), assert(sportslist(Result)), assert(sportshistory(X)),validate_and_query_options(Y).
	
/*so Y here should be the various list that belongs to didsecond()
Eg. learnlist, playlist... L should be the elements in the list.
So generate_options(X,L) will take in the X which is the category chosen from action
and return a list L which can contain elements from the learn, play, eat, clean or sports lists*/
/*if there is no element in didfirst(), the function should randomly select sth from action list.*/
generate_options(X,L):-
	didfirst(X), print('I see... So what did you '), print(X), findnsols(10, Y, conversion(X,Y),L).
	/*print('Hmmm... So what else did you do'), findnsols(10, Y, related(Y,X), L).*/

/*Function to progress from didfirst to didsecond. X = elements in the action
Y = elements in the other lists*/
conversion(X,Y):-
	didfirst(X), X == learn, learnlist(L), member(Y,L);
	didfirst(X), X == play, playlist(L), member(Y,L);
	didfirst(X), X == eat, eatlist(L), member(Y,L);
	didfirst(X), X == clean, cleanlist(L), member(Y,L);
	didfirst(X), X == sports, sportslist(L), member(Y,L).
	
related(X,Y):-
	action(L),member(X,L),member(Y,L);
	learnlist(L),member(X,L),member(Y,L);
	playlist(L),member(X,L),member(Y,L);
	eatlist(L),member(X,L),member(Y,L);
	cleanlist(L),member(X,L),member(Y,L);
	sportslist(L),member(X,L),member(Y,L).
	
/*Function that goes through list and asserting into predicate
I want it to be such that I pass in the list, and the function store all the elements in the list
into predicate. 
list_predicate(Y):-*/
	

/*not sure why have ask(L) at the back. I think the ask(L) in the back is to pass in
the action selected into ask() for them to generate a relevant qtn to ask.
May change when answer is no.*/
/*I think that we should have a foward and backward*/
/*Since there is always first and second stage. where user will go through action before the details of it, hence we
store the action selected into a list called didfirst, respectively if the user selected no, then the action will be placed
in notdo.
after a category of action is selected, the details will be asked. So the details of the specific action will be stored
respectively into notdo() and notdosecond().*/
validate_and_query_options(L):-
	action(X), member(L, X), print(L), print(' '), print('? y/n/q: '), read(Action), (Action==q -> abort; Action==y -> assert(didfirst(L));assert(notdo(L))), ask(L);
	print(' '), print(L), print('? y/n/q: '), read(Action), (Action==q -> abort; Action==y -> assert(didsecond(L));assert(notdosecond(L))), ask(L).

action().
learnlist().
playlist().
eatlist().
cleanlist().
sportslist().

didfirst().
didsecond().
notdo().
notdosecond().
actionhistory().
learnhistory().
playhistory().
eathistory().
cleanhistory().
sportshistory().
a.

/*action:
learn -> learnlist
play -> playlist
eat -> eatlist
clean -> cleanlist
sports -> sportslist*/

