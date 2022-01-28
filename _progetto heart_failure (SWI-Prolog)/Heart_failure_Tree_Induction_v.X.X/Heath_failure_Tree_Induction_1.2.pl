:- dynamic alb/1.
:- consult(db_hearth_attributes).
:- consult(db_hearth_training).
:- consult(db_hearth_test).

induce_albero( Albero ) :-
	findall( e(Classe,Oggetto), e(Classe,Oggetto), Esempi),
        findall( Att,a(Att,_), Attributi),
        induce_albero( Attributi, Esempi, Albero),
	mostra( Albero ),
	assert(alb(Albero)).

induce_albero( _, [], null ) :- !.
induce_albero( _, [e(Classe,_)|Esempi], l(Classe)) :-
	\+ ( member(e(ClassX,_),Esempi), ClassX \== Classe ),!.
induce_albero( Attributi, Esempi, t(Attributo,SAlberi) ) :-
	minore_attributo( Attributi, Esempi, Attributo), !,
	del( Attributo, Attributi, Rimanenti ),
	a( Attributo, Valori ),
	induce_alberi( Attributo, Valori, Rimanenti, Esempi, SAlberi).
induce_albero( _, Esempi, l(X)) :-
	findall( Classe, member(e(Classe,_),Esempi), Classi),
	length(Classi,N),
	findall(1, member(n,Classi), Negativi),
	length(Negativi, NN),
	conta_classi(N,NN,X).

minore_attributo( Attributi, Esempi, MigliorAttributo )  :-
	setof( Sum/A,
	      (member(A,Attributi) , somma_attributo( Esempi,A,Sum)),
	      [MinorDisuguaglianza/MigliorAttributo|_] ).


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

% Sottoinsieme � il sottoinsieme di esempi che soddisfa la condizione
% attributo=valore
attval_subset(AttributoValore,Esempi,Sottoinsieme) :-
	findall(e(C,O),(member(e(C,O),Esempi),soddisfa(O,[AttributoValore])),Sottoinsieme).

soddisfa(Oggetto,Congiunzione)  :-
	\+ (member(Att=Val,Congiunzione),
	    member(Att=ValX,Oggetto),
	    ValX \== Val).

del(T,[T|C],C) :- !.
del(A,[T|C],[T|C1]) :-
	del(A,C,C1).

mostra(T) :-
	mostra(T,0).
mostra(null,_) :- writeln(' ==> ???').
mostra(l(X),_) :- write(' ==> '),writeln(X).
mostra(t(A,L),I) :-
	nl,tab(I),write(A),nl,I1 is I+2,
	mostratutto(L,I1).
mostratutto([],_).
mostratutto([V:T|C],I) :-
	tab(I),write(V), I1 is I+2,
	mostra(T,I1),
	mostratutto(C,I).

classifica(Oggetto,nc,t(Att,Valori)) :- % dato t(+Att,+Valori), Oggetto è della Classe
	member(Att=Val,Oggetto),  % se Att=Val è elemento della lista Oggetto
        member(Val:null,Valori). % e Val:null è in Valori

classifica(Oggetto,Classe,t(Att,Valori)) :- % dato t(+Att,+Valori), Oggetto è della Classe
	member(Att=Val,Oggetto),  % se Att=Val è elemento della lista Oggetto
        member(Val:l(Classe),Valori). % e Val:l(Classe) è in Valori

classifica(Oggetto,Classe,t(Att,Valori)) :-
	member(Att=Val,Oggetto),  % se Att=Val è elemento della lista Oggetto
	delete(Oggetto,Att=Val,Resto),
	member(Val:t(AttFiglio,ValoriFiglio),Valori),
	classifica(Resto,Classe,t(AttFiglio,ValoriFiglio)).

conta_classi(N,NN,y) :-
	NN < N/2.

conta_classi(N,NN,n) :-
	NN > N/2.

conta_classi(N,NN,nc) :-
	NN =:= N/2.

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

valuta(_,[],VN,VN,VP,VP,FN,FN,FP,FP,NC,NC).            % testset vuoto -> valutazioni finali
valuta(Albero,[n/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-
	classifica(Oggetto,n,Albero), !,      % prevede correttamente non sopravvivenza
	VNA1 is VNA + 1,
	valuta(Albero,Coda,VN,VNA1,VP,VPA,FN,FNA,FP,FPA,NC,NCA).
valuta(Albero,[y/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-
	classifica(Oggetto,y,Albero), !, % prevede correttamente sopravvivenza
	VPA1 is VPA + 1,
	valuta(Albero,Coda,VN,VNA,VP,VPA1,FN,FNA,FP,FPA,NC,NCA).
valuta(Albero,[y/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-
	classifica(Oggetto,n,Albero), !,      % prevede erroneamente non sopravvivenza
	FNA1 is FNA + 1,
	valuta(Albero,Coda,VN,VNA,VP,VPA,FN,FNA1,FP,FPA,NC,NCA).
valuta(Albero,[n/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-
	classifica(Oggetto,y,Albero), !, % prevede erroneamente sopravvivenza
	FPA1 is FPA + 1,
	valuta(Albero,Coda,VN,VNA,VP,VPA,FN,FNA,FP,FPA1,NC,NCA).

valuta(Albero,[_/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :- % non classifica
	classifica(Oggetto,nc,Albero), !, % non classificato
	NCA1 is NCA + 1,
	valuta(Albero,Coda,VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA1).

stampa_albero:-
    alb(Albero),
    open('output.txt',write,Out),
    write(Out,Albero),
    close(Out).
