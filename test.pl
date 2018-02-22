did().
notdo().
listofsth([a,b,c,d,e]).

takeout(X,[X|R],R).
takeout(X,[F|R],[F|S]) :- takeout(X,R,S).

del(X,[X|Tail],Tail).
del(X,[Head|Tail],[Head|NewTail]):-
	del(X,Tail,NewTail).
	
p(0):-
	assert(did(something)),
	assert(did(something2)).
	
p(1):-
	retract(did(something2)).
	
p(2):-	
	listofsth(L), random_member(X,L), print('? a/d: '), read(Answer), 
	(Answer == a -> assert(did(X)); assert(notdo(X))).
	
p(3):-
	listofsth(L), random_member(X,L), takeout(X, L, L).
	
p(4):-	
	listofsth(L), assert(did(L)), takeout(a,L,Result), print(Result), retract(did(L)), assert(did(Result)).
	
ask(0):-
	assert(action([learn, play, eat, clean, sports])),
	print('Hey...What did you do today?'), validate_and_query_options(learn).
	
	


go :- hypothesize(Animal), 
       write('I guess that the animal is: '), 
       write(Animal), nl, undo.

 /* hypotheses to be tested */ 
hypothesize(cheetah) :- cheetah, !. 
hypothesize(tiger) :- tiger, !. 
hypothesize(giraffe) :- giraffe, !. 
hypothesize(zebra) :- zebra, !. 
hypothesize(ostrich) :- ostrich, !. 
hypothesize(penguin) :- penguin, !. 
hypothesize(albatross) :- albatross, !. 
hypothesize(unknown). /* no diagnosis */ 

/* animal identification rules */ 
cheetah :- mammal, carnivore, 
                verify(has_tawny_color), 
                verify(has_dark_spots). 
tiger :- mammal, carnivore, 
            verify(has_tawny_color), 
            verify(has_black_stripes). 
giraffe :- ungulate, 
               verify(has_long_neck), 
               verify(has_long_legs). 
zebra :- ungulate, 
             verify(has_black_stripes). 
ostrich :- bird, 
               verify(does_not_fly), 
               verify(has_long_neck). 
penguin :- bird, 
                 verify(does_not_fly), 
                 verify(swims), 
                 verify(is_black_and_white). 
albatross :- bird, 
                   verify(appears_in_story_Ancient_Mariner), 
                   verify(flys_well). 
/* classification rules */ 
mammal :- verify(has_hair), !. 
mammal :- verify(gives_milk). 
bird :- verify(has_feathers), !. 
bird :- verify(flys), 
           verify(lays_eggs). 
carnivore :- verify(eats_meat), !. 
carnivore :- verify(has_pointed_teeth), 
                    verify(has_claws), 
                    verify(has_forward_eyes). 
ungulate :- mammal, verify(has_hooves), !. 
ungulate :- mammal, verify(chews_cud). 
/* how to ask questions */ 
ask(Question) :- 
        write('Does the animal have the following attribute: '), 
        write(Question), write('? '), 
         read(Response), nl, 
         ( (Response == yes ; Response == y) 
         -> assert(yes(Question)) ; 
         assert(no(Question)), fail). 
:- dynamic yes/1,no/1. 
/* How to verify something */ 
verify(S) :- (yes(S) -> true ; (no(S) -> fail ; ask(S))). 
/* undo all yes/no assertions */ 
undo :- retract(yes(_)),fail. 
undo :- retract(no(_)),fail. 
undo. 