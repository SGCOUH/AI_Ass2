member(X,[X|_]).
member(X,[_|R]) :- member(X,R).


takeout(X,[X|R],R).
takeout(X,[F|R],[F|S]) :-
	takeout(X,R,S).
	
	
ask(0):-	
	assert(action([learn, play, eat, clean, sports])),
	assert(learnlist([alphabets, numbers, baking, spelling, grammar, music])),
	assert(playlist([slides, swing, sandbox, toys])),
	assert(eatlist([apple, orange, banana, pizza, spaghetti, bread, ice_cream, cake, chips])),
	assert(cleanlist([sweeping_the_classroom, cleaning_the_whiteboard, wiping_tables])),
	assert(sportslist([soccer, swimming, badminton, tennis])),
	print("Hey... Do you like "), validate_and_query_options([learn]).

ask(Y):-
	generate_options(Y,L), validate_and_query_options(L).
	
generate_options(Y,L):-
	didfirst(Y), print("I see... So what did you "), print(Y), print(' '),  findnsols(100,X,conversion(Y,X),L);
	print("Hmmm... What else "), findnsols(100,X,related(Y,X),L).
	
validate_and_query_options(L):-
	findnsols(100,X,didfirst(X),DidList), findnsols(100,X,notdo(X),Notdolist), append(Didlist,Notdolist,History), list_to_set(L,S), list_to_set(History,H), subtract(S,H,Valid), member(X,Valid), print(X), print('? y/n/q: '), read(Like), (Like==q -> abort;Like==y -> assert(didfirst(X));assert(notdo(X))), ask(X).
	
	
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

/*random(X):-*/
	


	
action().
learnlist().
playlist().
eatlist().
cleanlist().
sportslist().

didfirst(nothing).
didsecond(nothing).
notdo(nothing).
notdosecond(nothing).
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

