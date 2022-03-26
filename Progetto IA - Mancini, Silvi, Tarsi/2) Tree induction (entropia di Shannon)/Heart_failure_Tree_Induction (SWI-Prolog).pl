:- dynamic alb/1.
:- consult(db_heart_attributes).
:- consult(db_heart_training).
:- consult(db_heart_test).

% induce_albero(-Albero), ha lo scopo di inizializzare una ricerca
% di un albero decisionale e di asserirlo al termine
induce_albero( Albero ) :-                                         % chiamata del predicato il quale restituisce Albero
	findall( e(Classe,Oggetto), e(Classe,Oggetto), Esempi),	   % cerca tutti gli esempi con formato Classe|Oggetto e li colloca nella lista Esempi
        findall( Att,a(Att,_), Attributi),			   % cerca tutti gli attributi, ignorando i loro valori e li colloca nella lista Attributi
	induce_albero( Attributi, Esempi, Albero),!,               % ricorsione passando le liste appena create e la variabile della testa
	assert(alb(Albero)).                                       % apprendimento dell'albero nell'omonima variabile

% induce_albero(+Attributi,+Esempi,-Albero), ha lo scopo di ricercare
% l'albero decisionale date la lista degli Attributi e quella degli
% esempi
induce_albero( _, [], null ) :- !.			      % caso in cui l'insieme degli esempi � vuoto: albero  null

induce_albero( _, [e(Classe,_)|Esempi], l(Classe):1) :-	      % caso in cui si ha un insieme di Esempi tutti della stessa Classe: viene creata una foglia alla quale � assegnata una probabilit� pari a 1
	\+ ( member(e(ClassX,_),Esempi), ClassX \== Classe ),!.    % non deve esistere nessun esempio nell'insieme che sia di classe diversa dagli altri

induce_albero( Attributi, Esempi, t(Attributo,SottoAlberi) ) :-   % caso in cui gli esempi sono di classi differenti: viene creato un nodo al quale sono associati un attributo e dei sottoalberi che si genera da questo
	min_attr( Attributi, Esempi, Attributo), !,                % viene scelto l'Attributo, tra gli Attributi presenti, che minimizza l'entropia presente negli Esempi
	rimuovi( Attributo, Attributi, Rimanenti ),                % si rimuove l'Attributo scelto dalla lista Attributi ottenendo la lista Rimanenti
	a( Attributo, Valori ),                                    % si collocano i valori dell'Attributo scelto nella variabile Valori
	induce_alberi( Attributo, Valori, Rimanenti, Esempi, SottoAlberi).% vengono restituiti i SottoAlberi generati a seguito della scelta dell'attributo

induce_albero( _, Esempi, l(C):P) :-		% caso in cui non vi sono pi� attributi utili alla classificazione: si forma una foglia assegnando una classe C con probabilit� P
	findall( Classe, member(e(Classe,_),Esempi), Classi),      % si prendono le varie classi presenti negli Esempi e le si mettono nella lista Classi
	length(Classi,N),					   % si calcola la lunghezza N della lista Classi
	findall(1, member(n,Classi), Negativi),                    % si cercano le classi "n" nella lista Classi e si pongono nella lista Negativi
	length(Negativi, NN),                                      % si calcola la lunghezza NN della lista Negativi
	conta_classi(N,NN,C,P).                                    % si ricava la classe C pi� numerosa e la sua probabilit� P

% conta_classi(+Numero_totale,+Numero_negativi,-Classe_dominante,-Probabilit�),
% basandosi sul numero totale di esempi e il numero dei quali hanno
% classe negativa, valuta la classe dominante e la sua probabilit�
conta_classi(N,NN,y,P) :-	% caso in cui la classe dominante � "y"
	NN < N/2,                         % le classi negative sono meno della met� del numero di esempi
	P is 1-(NN/N).                    % la probabilit� della classe positiva � il reciproco della porbabilit� di avere un negativo

conta_classi(N,NN,n,P) :-      % caso in cui la classe dominante � "n"
	NN > N/2,			  % le classi negative sono pi� della met� del numero di esempi
	P is NN/N.			  % la probabilit� di avere un negativo � il rapporto tra il numero di negativi sul numero totale di esempi considerati

conta_classi(N,NN,nc,0) :-     % caso in cui non � possibile una classificazione: classe "nc" (non classificata) e probabilit� 0
	NN =:= N/2.                       % il numero di negativi � esattamente la met� degli esempi considerati

% min_attr(+Attributi,+Esempi,-AttributoMinimizzante), ha lo scopo di
% scelgliere fra la lista Attributi quello che minimizza il contenuto di
% entropia nel sotto insieme generato dalla lista Esempi
min_attr(Attributi, Esempi, AttrMinimizz) :-
	findall( Somma/A,						  % si cercano tutte le coppie Somma/A tali che:
		(member(A,Attributi) , somma_attributo( Esempi,A,Somma)), % ...A sia parte di Attributi e Somma sia il risultato di somma_attributo
		 L),							  % ...i risultati vengono posizionati nella Lista L
	findall(Somma, (member(Somma/A,L)), ListaValori),		  % si cercano tutte le somme che siano parte delle coppie Somma/A e si mettono in ListaValori
	prendi_minimo(ListaValori, Min),				  % si seleziona il valore minimo Min contenuto in ListaValori
	member(Min/AttrMinimizz,L).                                       % si controlla che la coppia Min/AttrMinimizz faccia parte della lista L

% prendi_minimo(+Lista,-ElemMinimo), data una lista cerca l'elemento
% con valore numerico minore
prendi_minimo([Testa|Coda], Minimo) :-
    min_lista(Coda, Testa, Minimo).       % si ottiene l'elemento Minimo della lista passata come argomento

% min_lista(+Lista,+Valore1,+Valore2), serve ad estrarre il valore
% minimo contenuto in una lista di valori numerici
min_lista([], Min, Min).           % se la lista � vuota vuol dire che il minimo Min � stato trovato

min_lista([Testa|Coda], TestaPrec, Min) :-  % a TestaPrec � passata la testa della precedente lista
	Min1 is min(Testa, TestaPrec),          % si prende il valore minimo fra la vecchia e la nuova testa e lo si mette in Min1
	min_lista(Coda, Min1, Min).		% si effettua una ricorsione passando Min1 e la Coda della lista

% somma_attributo(+Esempi,+Attributo,-Somma) va a calcolare, per ogni
% valore dell'Attributo, l'entropia generata ed effettua la Somma di
% questi valori
somma_attributo( Esempi, Attributo, Somma) :-
	a( Attributo, ValoriAttributo),                             % si prende la lista di valori appartenenti all'Attributo esaminato
	somma( Esempi, Attributo, ValoriAttributo, 0, Somma),!.	    % si va a calcolare la sommatoria dell'entropia generata da ogni valore dell'attributo passato per argomento.


% somma(+Esempi, +Attributo, +Valori, +ListaAppoggio, -Somma)
% restituisce l'entropia pesata dell'Attributo usata per la scelta
% dell'attributo nell'induzione dell'albero.
somma(_,_,[],Pbase,Pbase).						   % caso in cui non ci sono pi� valori
somma( Esempi, Att, [Val|Valori], SommaParziale, Somma) :-
        length(Esempi, N),                                                 % calcola il numero N di Esempi
	findall( C,                                                        % mette nella lista EsempiSoddisfatti le classi C
		 (member(e(C,Desc),Esempi) , soddisfa(Desc,[Att=Val])),    % che appartengono alla lista Esempi e che soddisfano
		 EsempiSoddisfatti ),					   % la coppia Att = Val
	length(EsempiSoddisfatti, NVal),                                   % calcola il numero NVal di esempi soddisfatti
	NVal > 0, !,                                                       % se c'� almeno un esempio soddisfatto
	findall(1,                                                         % aggiunge un 1 alla lista L per ogni esempio soddisfatto
              member(y,EsempiSoddisfatti),				   % della classe y
              L),
	length(L,NVC),							   % calcola il numero NVC di esempi soddisfatti con classe y
	P is NVC/NVal,							   % calcola la probabilit� P di avere una classe y  tra gli esempi soddisfatti
	entropia(P,E),							   % restituisce in E il contributo dell'entropia del valore Val passando come argomento P
        NuovaSommaParziale is SommaParziale + E*NVal/N,                    % moltiplica E per la probabilit� NVal/N e lo somma agli altri contributi in NuovaSommaParziale
        somma(Esempi,Att,Valori,NuovaSommaParziale,Somma)                  % ricorsione con NuovaSommaParziale
        ;
        somma(Esempi,Att,Valori,SommaParziale,Somma).                      % caso in cui nessun esempio soddisfa Att = Val

% entropia(+Probabilit�,-Entropia) restituisce l'Entropia data la
% probabilit� P
entropia(0,0).                   % caso in cui la probabilit� � 0: l'entropia � 0
entropia(1,0).                   % caso in cui la probabilit� � 1: l'entropia � 0
entropia(P,E):-		         % caso in cui la probabilit� � diversa da 0 e 1
        log(P,L1),
        log((1-P),L2),
        E is -1*(P*L1+(1-P)*L2).

% induce_alberi(+Att, +Val, +AttRimasti, +Esempi, -SottoAlberi)
% induce i sottoalberi dopo la scelta dell'attributo Att per ogni valore
% Val di Att
induce_alberi(_,[],_,_,[]).                                                %caso in cui la lista dei valori � vuota, non induce alcun sottoalbero
induce_alberi(Att,[Val1|Valori],AttRimasti,Esempi,[Val1:Alb1|Alberi])  :-
	esempi_AttVal(Att=Val1,Esempi,SottoinsiemeEsempi),                 % crea la lista SottoinsiemeEsempi di esempi presi dalla lista Esempi che soddisfano la coppia Att = Val1
	induce_albero(AttRimasti,SottoinsiemeEsempi,Alb1),		   % induce il sottoalbero Alb1 per il valore Val1 dell'attributo Att. Usa gli attributi non ancora utilizzati AttRimasti nel caso in cui il sottoalbero non sia una foglia.
	induce_alberi(Att,Valori,AttRimasti,Esempi,Alberi).                % ricorsione per indurre i sottoalberi dei Valori rimanenti di Att

% esempi_AttVal(+Att = Val, +Esempi, -Sottoinsieme) restituisce la lista
% Sottoinsieme che contiene gli esempi che soddisfano la coppia
% AttributoValore
esempi_AttVal(AttributoValore,Esempi,Sottoinsieme) :-
	findall(e(C,O),(member(e(C,O),Esempi),soddisfa(O,[AttributoValore])),Sottoinsieme).

% soddisfa(+Oggetto, [+Att=Val]) fallisce nel caso in cui
% in Oggetto non � presente la coppia Att=Val
soddisfa(Oggetto,AttributoValore)  :-
	\+ (member(Att=Val,AttributoValore), % unifica Att e Val con la coppia AttributoValore
	    member(Att=ValX,Oggetto),	     % unifica ValX con il valore dell'attributo Att di Oggetto
	    ValX \== Val).                   % fallisce se ValX e Val sono diversi grazie alla negazione \+

% rimuovi(+Attributo,+Attributi,-Rimanenti)
% rimuove l'Attributo dalla lista Attributi restituendo la lista
% Rimanenti
rimuovi(T,[T|C],C) :- !.    % caso in cui l'attributo da rimuovere � in testa
rimuovi(A,[T|C],[T|C1]) :-  % caso in cui l'attributo non � in testa
	rimuovi(A,C,C1).    % ricorre sulla coda della lista Atributi



% classifica(+Oggetto, -Classe, t(+Att,+Valori)), verifica se Oggetto, costituito da una lista di
% coppie Attributo=Valore, � della Classe a cui potrebbe appartenere;
% la classificazione viene effettuata dopo avere indotto
% l'albero, richiamandolo nel seguente modo: t(-Att,-Valori)
classifica(Oggetto,nc,t(Att,Valori)) :-		% Oggetto � della classe "nc"
	member(Att=Val,Oggetto),		% se Att=Val � un elemento della lista Oggetto
	member(Val:null,Valori).		% e Val:null � un elemento della lista Valori

classifica(Oggetto,Classe,t(Att,Valori)) :-	% Oggetto � della Classe
	member(Att=Val,Oggetto),		% se Att=Val � un elemento della lista Oggetto
        member(Val:l(Classe):_,Valori).		% e Val:l(Classe):_ � un elemento della lista Valori,
						% ossia si � in presenza di una foglia dell'albero
						% senza considerare la probabilit� a cui � associata alla Classe

classifica(Oggetto,Classe,t(Att,Valori)) :-				% Oggetto � della Classe
	member(Att=Val,Oggetto),					% se Att=Val � un elemento della lista Oggetto
	delete(Oggetto,Att=Val,Resto),					% se rimuovendo tale coppia da Oggetto viene restituita la lista Resto
	member(Val:t(AttFiglio,ValoriFiglio),Valori),			% se Val:t(-AttFiglio,-ValoriFiglio) � un elemento di Valori
	classifica(Resto,Classe,t(AttFiglio,ValoriFiglio)).		% si ricorre con la lista Resto
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
valuta(_,[],VN,VN,VP,VP,FN,FN,FP,FP,NC,NC).					% caso in cui TestSet vuoto

valuta(Albero,[n/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-		% si valuta un caso con classe "n",
	classifica(Oggetto,n,Albero), !,					% se viene previsto correttamente con la classificazione
	VNA1 is VNA + 1,							% viene incrementato di 1 il contatore di appoggio dei VeriNegativi
	valuta(Albero,Coda,VN,VNA1,VP,VPA,FN,FNA,FP,FPA,NC,NCA).		% per poi ricorrere con la Coda del TestSet contenente il resto dei casi

valuta(Albero,[y/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-		% si valuta un caso con classe "y",
	classifica(Oggetto,y,Albero), !,					% se viene previsto correttamente con la classificazione
	VPA1 is VPA + 1,							% viene incrementato di 1 il contatore di appoggio dei VeriPositivi
	valuta(Albero,Coda,VN,VNA,VP,VPA1,FN,FNA,FP,FPA,NC,NCA).		% per poi ricorrere con la Coda del TestSet contenente il resto dei casi

valuta(Albero,[y/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-		% si valuta un caso con classe "y",
	classifica(Oggetto,n,Albero), !,					% se viene prevista la classe "n" con la classificazione
	FNA1 is FNA + 1,							% viene incrementato di 1 il contatore di appoggio dei FalsiNegativi
	valuta(Albero,Coda,VN,VNA,VP,VPA,FN,FNA1,FP,FPA,NC,NCA).		% per poi ricorrere con la Coda del TestSet contenente il resto dei casi

valuta(Albero,[n/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-		% si valuta un caso con classe "n",
	classifica(Oggetto,y,Albero), !,					% se viene prevista la classe "y" con la classificazione
	FPA1 is FPA + 1,							% viene incrementato di 1 il contatore di appoggio dei FalsiPositivi
	valuta(Albero,Coda,VN,VNA,VP,VPA,FN,FNA,FP,FPA1,NC,NCA).		% per poi ricorrere con la Coda del TestSet contenente il resto dei casi


valuta(Albero,[_/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-		% si valuta un caso con una qualsiasi classe,
	classifica(Oggetto,nc,Albero), !,					% se viene prevista la classe "nc" con la classificazione (si � in presenza di un caso non classificabile)
	NCA1 is NCA + 1,							% viene incrementato di 1 il contatore di appoggio dei NonClassificabili
	valuta(Albero,Coda,VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA1).		% per poi ricorrere con la Coda del TestSet contenente il resto dei casi




% prevedi(+Oggetto, t(+Att,+Valori), -Classe, -P),  ha lo stesso scopo
% del predicato precedente classifica(+Oggetto, -Classe, t(+Att,+Valori)), con la sola differenza
% che in pi� viene restituita la probabilit� P per cui una foglia � associata ad una determinata classe
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
	write('Il paziente ha il '), write(Prob), write('% di probabilit� di essere malato!').
risultato(n,P):-
	Prob is P*100,
	write('Il paziente ha il '), write(Prob), write('% di probabilit� di non essere malato!').

risultato(nc,0):-
	write('Non � possibile definire lo stato di salute del paziente!').

