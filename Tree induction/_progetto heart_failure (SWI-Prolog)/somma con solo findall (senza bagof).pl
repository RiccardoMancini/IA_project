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
	rimuovi( Attributo, Attributi, Rimanenti ),
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

%descrizione generale
%prendi_minimo(....)
prendi_minimo([L|Ls], Min) :-
    min_lista(Ls, L, Min).

min_lista([], Min, Min).
min_lista([L|Ls], Min0, Min) :-
    Min1 is min(L, Min0),
    min_lista(Ls, Min1, Min).

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
	findall(1,
              member(y,EsempiSoddisfatti),
              L),
      length(L,NVC),
      P is NVC/NVal,
      entropia(P,E),
      NuovaSommaParziale is SommaParziale + E*NVal/N,
      somma(Esempi,Att,Valori,NuovaSommaParziale,Somma)
      ;
      somma(Esempi,Att,Valori,SommaParziale,Somma).

entropia(0,0).
entropia(1,0).
entropia(P,E):-
        log(P,L1),
        log((1-P),L2),
        E is -1*(P*L1+(1-P)*L2).


induce_alberi(_,[],_,_,[]).
induce_alberi(Att,[Val1|Valori],AttRimasti,Esempi,[Val1:Alb1|Alberi])  :-
	esempi_AttVal(Att=Val1,Esempi,SottoinsiemeEsempi),
	induce_albero(AttRimasti,SottoinsiemeEsempi,Alb1),
	induce_alberi(Att,Valori,AttRimasti,Esempi,Alberi).

esempi_AttVal(AttributoValore,Esempi,Sottoinsieme) :-
	findall(e(C,O),(member(e(C,O),Esempi),soddisfa(O,[AttributoValore])),Sottoinsieme).

soddisfa(Oggetto,Congiunzione)  :-
	\+ (member(Att=Val,Congiunzione),
	    member(Att=ValX,Oggetto),
	    ValX \== Val).

rimuovi(T,[T|C],C) :- !.
rimuovi(A,[T|C],[T|C1]) :-
	rimuovi(A,C,C1).



% classifica(+Oggetto, -Classe, t(+Att,+Valori)), verifica se l'Oggetto passato, costituito da una lista di
% coppie Attributo=Valore, è della Classe a cui potrebbe appartenere.
% ovviamente la classificazione viene effettuata dopo avere indotto l'albero, infatti verra poi richiamato
% nel seguente modo: t(-Att,-Valori)

classifica(Oggetto,nc,t(Att,Valori)) :-		% Oggetto è della classe "nc"
	member(Att=Val,Oggetto),		% se Att=Val è un elemento della lista Oggetto
	member(Val:null,Valori).		% e Val:null è un elemento della lista Valori

classifica(Oggetto,Classe,t(Att,Valori)) :-	% Oggetto è della Classe
	member(Att=Val,Oggetto),			% se Att=Val è un elemento della lista Oggetto
      member(Val:l(Classe):_,Valori).		% e Val:l(Classe):_ è un elemento della lista Valori,
								% ossia si è in presenza di una foglia dell'albero
								% senza considerare la probabilità a cui è associata alla Classe

classifica(Oggetto,Classe,t(Att,Valori)) :-				% Oggetto è della Classe
	member(Att=Val,Oggetto),						% se Att=Val è un elemento della lista Oggetto
	delete(Oggetto,Att=Val,Resto),					% se si può ottenere la lista Resto rimuovendo tale coppia da Oggetto
	member(Val:t(AttFiglio,ValoriFiglio),Valori),			% se Val:t(-AttFiglio,-ValoriFiglio) è un elemento di Valori
	classifica(Resto,Classe,t(AttFiglio,ValoriFiglio)).		% e si ricorre con la lista Resto
											% e con il sottoalbero di coppie AttFiglio=ValoriFiglio


matrice_confusione :-
	alb(Albero),
	findall(Classe/Oggetto,s(Classe,Oggetto),TestSet),
	length(TestSet,N),
	valuta(Albero,TestSet,VN,0,VP,0,FN,0,FP,0,NC,0),!,
	A is (VP + VN) / (N - NC), % Accuratezza
	E is 1 - A,		   % Errore
	writeln(''),
	write('Test effettuati:\t'),  writeln(N),
	write('Test non classificati:\t'),  writeln(NC),
	writeln(''),
	writeln('\t\t   +----------------------------+'),
	writeln('\t\t   |\t   CLASSE STIMATA\t|'),
	writeln('\t\t   +------------+---------------+'),
	writeln('\t\t   |  Negativo\t|  Positivo\t|'),
	writeln('+-------+----------+------------+---------------+'),
	write('|CLASSE\t| Negativo |\t '),write(VN),write('\t|\t'),write(FP),writeln('\t|'),
	writeln('|\t+----------+------------+---------------+'),
	write('|REALE\t| Positivo |\t '),write(FN),write('\t|\t'),write(VP),writeln('\t|'),
	writeln('+-------+----------+------------+---------------+'),
	writeln(''),
	write('Accuratezza:\t'), writeln(A),
	write('Errore:\t\t'), writeln(E),
	writeln('').




% valuta(+Albero, +TestSet, -VeriNegativi, +VeriNegativiAppoggio, -VeriPositivi, +VeriPositiviAppoggio,
% -FalsiNegativi, +FalsiNegativiAppoggio, -FalsiPositivi, +FalsiPositiviAppoggio, -NonClassificabili, +NonClassificabiliAppoggio),
% permette di valutare i casi presenti nella lista TestSet restituendo per ognuno di essi la classificazione sulla base
% dell'Albero indotto in precedenza.

valuta(_,[],VN,VN,VP,VP,FN,FN,FP,FP,NC,NC).						% TestSet vuoto

valuta(Albero,[n/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-		% si valuta un caso con classe "n",
	classifica(Oggetto,n,Albero), !,							% se viene previsto correttamente con la classificazione
	VNA1 is VNA + 1,										% viene incrementato di 1 il contatore di appoggio dei VeriNegativi
	valuta(Albero,Coda,VN,VNA1,VP,VPA,FN,FNA,FP,FPA,NC,NCA).			% per poi ricorrere con la Coda del TestSet contenente il resto dei casi

valuta(Albero,[y/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-		% si valuta un caso con classe "y",
	classifica(Oggetto,y,Albero), !,							% se viene previsto correttamente con la classificazione
	VPA1 is VPA + 1,										% viene incrementato di 1 il contatore di appoggio dei VeriPositivi
	valuta(Albero,Coda,VN,VNA,VP,VPA1,FN,FNA,FP,FPA,NC,NCA).			% per poi ricorrere con la Coda del TestSet contenente il resto dei casi

valuta(Albero,[y/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-		% si valuta un caso con classe "y",
	classifica(Oggetto,n,Albero), !,							% se viene prevista la classe "n" con la classificazione
	FNA1 is FNA + 1,										% viene incrementato di 1 il contatore di appoggio dei FalsiNegativi
	valuta(Albero,Coda,VN,VNA,VP,VPA,FN,FNA1,FP,FPA,NC,NCA).			% per poi ricorrere con la Coda del TestSet contenente il resto dei casi

valuta(Albero,[n/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-		% si valuta un caso con classe "n",
	classifica(Oggetto,y,Albero), !,							% se viene prevista la classe "y" con la classificazione
	FPA1 is FPA + 1,										% viene incrementato di 1 il contatore di appoggio dei FalsiPositivi
	valuta(Albero,Coda,VN,VNA,VP,VPA,FN,FNA,FP,FPA1,NC,NCA).			% per poi ricorrere con la Coda del TestSet contenente il resto dei casi


valuta(Albero,[_/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-		% si valuta un caso con una qualsiasi classe,
	classifica(Oggetto,nc,Albero), !,							% se viene prevista la classe "nc" con la classificazione (si è in presenza di un caso non classificabile)
	NCA1 is NCA + 1,										% viene incrementato di 1 il contatore di appoggio dei NonClassificabili
	valuta(Albero,Coda,VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA1).			% per poi ricorrere con la Coda del TestSet contenente il resto dei casi




% prevedi(+Oggetto, t(+Att,+Valori), -Classe, -P),  ha lo stesso scopo
% del predicato precedente classifica(+Oggetto, -Classe, t(+Att,+Valori)), con la sola differenza
% che in più viene restituita la probabilità P per cui una foglia è associata ad una determinata classe

prevedi(Oggetto,t(Att,Valori),nc,0) :-
	member(Att=Val,Oggetto),
	member(Val:null,Valori).

prevedi(Oggetto,t(Att,Valori),Classe,P) :-
	member(Att=Val,Oggetto),
        member(Val:l(Classe):P,Valori).

prevedi(Oggetto,t(Att,Valori),Classe,P) :-
	member(Att=Val,Oggetto),
	delete(Oggetto,Att=Val,Resto),
	member(Val:t(AttFiglio,ValoriFiglio),Valori),
	prevedi(Resto,t(AttFiglio,ValoriFiglio),Classe,P).



% previsione(+Oggetto, -Classe), ha l'obiettivo di prevedere la Classe di un Oggetto,
% definito da una lista di coppie Attributo=Valori che rappresentano la diagnosi di un solo paziente

previsione(Oggetto,Classe) :-
	alb(Albero),
	prevedi(Oggetto,Albero,Classe,P),!,
	risultato(Classe,P).

risultato(y,P):-
	Prob is P*100,
	write('Il paziente ha il '), write(Prob), write('% di probabilità di essere malato!').
risultato(n,P):-
	Prob is P*100,
	write('Il paziente ha il '), write(Prob), write('% di probabilità di non essere malato!').

risultato(nc,0):-
	write('Non è possibile definire lo stato di salute rimuovi paziente!').

