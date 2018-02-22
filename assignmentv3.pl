/*check if X is a member of list that will be specified by the second parameter*/
member(X,[X|_]).
member(X,[_|R]) :- member(X,R).

/*Used to iterate through the list. By taking out the head element in each of the list.*/
takeout(X,[X|R],R).
takeout(X,[F|R],[F|S]) :-
	takeout(X,R,S).
/*initial start state where user click go. to start conversation*/	
go:-
	hypothesize(A).
	

/*each function manage the 5 main root category:
learn, play, eat, clean, sports. ! is used to cut and prevent backtracking.*/	
hypothesize(learn):- learn, !.
hypothesize(play) :- play, !. 
hypothesize(eat) :- eat, !. 
hypothesize(clean) :- clean, !. 
hypothesize(sports) :- sports, !. 

/*learn will call the ask if kid did learn today at school.
Used as a prerequesite to block out kids that did not learn anything today.
If answer is yes, then learn list will be loaded and learnRec and askLearn is used
to pass in each item in the list L to ask. Similar workings for the reset of the root activities.*/

/*LEARN*/
learn:-
	ask(learn), learnlist(L), learnRec(L).
learnRec(L):-
	member(X,L), askLearn(X,L).	
askLearn(X,L):-
	write('So what did you learn? '), write(X),  write('? '), 
	read(Response), nl, 
	( (Response == yes ; Response == y) 
         -> (assert(yes(Question)), assert(learnhistory(X)))  ; 
         assert(no(Question)), takeout(Question, L, R), learnRec(R)).

/*PLAY*/
play:-
	ask(play), playlist(L), playRec(L).
playRec(L):-
	member(X,L), askPlay(X,L).	
askPlay(X,L):-
	write('So what did you play? '), write(X),  write('? '), 
	read(Response), nl, 
	( (Response == yes ; Response == y) 
         -> (assert(yes(Question)), assert(playhistory(X)))  ; 
         assert(no(Question)), takeout(Question, L, R), playRec(R)).	

/*EAT*/	
eat:-
	ask(eat), eatlist(L), eatRec(L).
eatRec(L):-
	member(X,L), askEat(X,L).	
askEat(X,L):-
	write('So what did you eat? '), write(X),  write('? '), 
	read(Response), nl, 
	( (Response == yes ; Response == y) 
         -> (assert(yes(Question)), assert(eathistory(X))) ; 
         assert(no(Question)), takeout(Question, L, R), eatRec(R)).	
         
/*CLEAN*/	
clean:-
	ask(clean), cleanlist(L), cleanRec(L).
cleanRec(L):-
	member(X,L), askClean(X,L).	
askClean(X,L):-
	write('So where did you clean? '), write(X),  write('? '), 
	read(Response), nl, 
	( (Response == yes ; Response == y) 
         -> (assert(yes(Question)), assert(cleanhistory(X))) ; 
         assert(no(Question)), takeout(Question, L, R), cleanRec(R)).	
         
/*SPORTS*/	
sports:-
	ask(sports), sportslist(L), sportsRec(L).
sportsRec(L):-
	member(X,L), askSports(X,L).	
askSports(X,L):-
	write('So what did you do in PE? '), write(X),  write('? '), 
	read(Response), nl, 
	( (Response == yes ; Response == y) 
         -> (assert(yes(Question)), assert(sportshistory(X))) ; 
         assert(no(Question)), takeout(Question, L, R), sportsRec(R)).	
	
/*actionRec(L):-
	member(X,L), askAction(X,L).	*/
ask(Question) :- 
        write('What did you do today '), 
        write(Question), write('? '), 
         read(Response), nl, 
         ( (Response == yes ; Response == y) 
         -> (assert(yes(Question)), assert(actionhistory(Question))) ; 
         assert(no(Question)), fail). 
         

         
overall:-
	print('Child Report for the day: '), nl,
	findnsols(10, X, (print('Action: '), actionhistory(X), print(X)), ActionList), nl,
	findnsols(10, X, (print('Learnt: '), learnhistory(X), print(X)), LearnList), nl,
	findnsols(10, X, (print('Play: '), playhistory(X), print(X)), PlayList), nl,
	findnsols(10, X, (print('Eat: '), eathistory(X), print(X)), EatList), nl,
	findnsols(10, X, (print('Cleaned: '), cleanhistory(X), print(X)), CleanList), nl,
	findnsols(10, X, (print('Sports: '), sportshistory(X), print(X)), SportsList).
	
         
action([learn, play, eat, clean, sports]).
learnlist([alphabets, numbers, baking, spelling, grammar, music]).
playlist([slides, swing, sandbox, toys]).
eatlist([apple, orange, banana, pizza, spaghetti, bread, ice_cream, cake, chips]).
cleanlist([sweeping_the_classroom, cleaning_the_whiteboard, wiping_tables]).
sportslist([soccer, swimming, badminton, tennis]).

actionhistory(nothing).
learnhistory(nothing).
playhistory(nothing).
eathistory(nothing).
cleanhistory(nothing).
sportshistory(nothing).
	