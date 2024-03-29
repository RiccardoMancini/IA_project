:- dynamic alb/1.
:- consult(db_heart_attributes).
:- consult(db_heart_training).
:- consult(db_heart_test).

induce_albero( Albero ) :-
	findall( e(Classe,Oggetto), e(Classe,Oggetto), Esempi),
        findall( Att,a(Att,_), Attributi),
        induce_albero( Attributi, Esempi, Albero),!,
	assert(alb(Albero)).

induce_albero( _, [], null ) :- !.
induce_albero( _, [e(Classe,_)|Esempi], l(Classe):1) :-
	\+ ( member(e(ClassX,_),Esempi), ClassX \== Classe ),!.
induce_albero( Attributi, Esempi, t(Attributo,SAlberi) ) :-
	min_attr( Attributi, Esempi, Attributo), !,
	del( Attributo, Attributi, Rimanenti ),
	a( Attributo, Valori ),
	induce_alberi( Attributo, Valori, Rimanenti, Esempi, SAlberi).

induce_albero( _, Esempi, l(X):P) :-
	findall( Classe, member(e(Classe,_),Esempi), Classi),
	length(Classi,N),
	findall(1, member(n,Classi), Negativi),
	length(Negativi, NN),
	conta_classi(N,NN,X,P).

conta_classi(N,NN,y,P) :-
	NN < N/2,
	P is 1-(NN/N).

conta_classi(N,NN,n,P) :-
	NN > N/2,
	P is NN/N.

conta_classi(N,NN,nc,0) :-
	NN =:= N/2.

min_attr(Attributi, Esempi, BestAttr) :-
	findall( Sum/A,
		(member(A,Attributi) , somma_attributo( Esempi,A,Sum)),
		 L),
	findall(Sum, (member(Sum/A,L)), LValue),
	prendi_minimo(LValue, Min),
	member(Min/BestAttr,L).

prendi_minimo([L|Ls], Min) :-
    list_min(Ls, L, Min).

list_min([], Min, Min).
list_min([L|Ls], Min0, Min) :-
    Min1 is min(L, Min0),
    list_min(Ls, Min1, Min).

somma_attributo( Esempi, Attributo, Sum) :-
	a( Attributo, AttVals),
	somma( Esempi, Attributo, AttVals, 0, Sum),!.

somma(_,_,[],Pbase,Pbase).
somma( Esempi, Att, [Val|Valori], SommaParziale, Somma) :-
        length(Esempi, N),
	findall( C,
		 (member(e(C,Desc),Esempi) , soddisfa(Desc,[Att=Val])),
		 EsempiSoddisfatti ),
	length(EsempiSoddisfatti, NVal),
	NVal > 0, !,
	findall(P,
                (bagof(1,
                       member(y,EsempiSoddisfatti),
                       L),
                 length(L,NVC),
                 P is NVC/NVal),
                Pp),
        entropy(Pp,E),
        NuovaSommaParziale is SommaParziale + E*NVal/N,
        somma(Esempi,Att,Valori,NuovaSommaParziale,Somma)
        ;
        somma(Esempi,Att,Valori,SommaParziale,Somma).

entropy([],0).
entropy([1],0).
entropy([P],E):-
        log(P,L1),
        log((1-P),L2),
        E is -1*(P*L1+(1-P)*L2).


induce_alberi(_,[],_,_,[]).
induce_alberi(Att,[Val1|Valori],AttRimasti,Esempi,[Val1:Alb1|Alberi])  :-
	attval_subset(Att=Val1,Esempi,SottoinsiemeEsempi),
	induce_albero(AttRimasti,SottoinsiemeEsempi,Alb1),
	induce_alberi(Att,Valori,AttRimasti,Esempi,Alberi).

attval_subset(AttributoValore,Esempi,Sottoinsieme) :-
	findall(e(C,O),(member(e(C,O),Esempi),soddisfa(O,[AttributoValore])),Sottoinsieme).

soddisfa(Oggetto,Congiunzione)  :-
	\+ (member(Att=Val,Congiunzione),
	    member(Att=ValX,Oggetto),
	    ValX \== Val).

del(T,[T|C],C) :- !.
del(A,[T|C],[T|C1]) :-
	del(A,C,C1).

classifica(Oggetto,nc,t(Att,Valori)) :-
	member(Att=Val,Oggetto),
	member(Val:null,Valori).

classifica(Oggetto,Classe,t(Att,Valori)) :-
	member(Att=Val,Oggetto),
        member(Val:l(Classe):_,Valori).

classifica(Oggetto,Classe,t(Att,Valori)) :-
	member(Att=Val,Oggetto),
	delete(Oggetto,Att=Val,Resto),
	member(Val:t(AttFiglio,ValoriFiglio),Valori),
	classifica(Resto,Classe,t(AttFiglio,ValoriFiglio)).

matrice_confusione :-
	alb(Albero),
	findall(Classe/Oggetto,s(Classe,Oggetto),TestSet),
	length(TestSet,N),
	valuta(Albero,TestSet,VN,0,VP,0,FN,0,FP,0,NC,0),!,
	A is (VP + VN) / (N - NC), % Accuratezza
	E is 1 - A,		   % Errore
	write('Test effettuati :'),  writeln(N),
	write('Test non classificati :'),  writeln(NC),
	write('Veri Negativi  '), write(VN), write('   Falsi Positivi '), writeln(FP),
	write('Falsi Negativi '), write(FN), write('   Veri Positivi  '), writeln(VP),
	write('Accuratezza: '), writeln(A),
	write('Errore: '), writeln(E).

valuta(_,[],VN,VN,VP,VP,FN,FN,FP,FP,NC,NC).
valuta(Albero,[n/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-
	classifica(Oggetto,n,Albero), !,
	VNA1 is VNA + 1,
	valuta(Albero,Coda,VN,VNA1,VP,VPA,FN,FNA,FP,FPA,NC,NCA).
valuta(Albero,[y/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-
	classifica(Oggetto,y,Albero), !,
	VPA1 is VPA + 1,
	valuta(Albero,Coda,VN,VNA,VP,VPA1,FN,FNA,FP,FPA,NC,NCA).
valuta(Albero,[y/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-
	classifica(Oggetto,n,Albero), !,
	FNA1 is FNA + 1,
	valuta(Albero,Coda,VN,VNA,VP,VPA,FN,FNA1,FP,FPA,NC,NCA).
valuta(Albero,[n/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-
	classifica(Oggetto,y,Albero), !,
	FPA1 is FPA + 1,
	valuta(Albero,Coda,VN,VNA,VP,VPA,FN,FNA,FP,FPA1,NC,NCA).

valuta(Albero,[_/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-
	classifica(Oggetto,nc,Albero), !,
	NCA1 is NCA + 1,
	valuta(Albero,Coda,VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA1).





