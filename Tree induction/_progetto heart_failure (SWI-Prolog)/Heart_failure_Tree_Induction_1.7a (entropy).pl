:- dynamic alb/1.
:- consult(db_heart_attributes).
:- consult(db_heart_training).
:- consult(db_heart_test).

% induce_albero(-Albero) ha lo scopo di inizializzare una ricerca
% di un albero ecisionale e di apprenderlo al termine
induce_albero( Albero ) :-                                         % chiamata della funzione alla quale serve una Variabile sulla quale porre l'albero
	findall( e(Classe,Oggetto), e(Classe,Oggetto), Esempi),	   % cerca tutti gli esempi con formato Classe|Oggetto e li colloca nella lista Esempi
        findall( Att,a(Att,_), Attributi),			   % cerca tutti gli attributi, ignorando i loro valori e li colloca nella lista Attributi
	induce_albero( Attributi, Esempi, Albero),!,               % richiama la funzione stessa passando le liste appena create e la variabile della testa, se fallisce
	assert(alb(Albero)).                                       % apprendimento dell'albero nell'omonima variabile
% induce_albero(+Attributi,+Esempi,-Albero), ha lo scopo di ricercare
% l'albero decisionale date la lista degli Attributi e quella degli
% esempi
induce_albero( _, [], null ) :- !.			      % caso in cui l'insieme degli esempi è vuoto: albero  null

induce_albero( _, [e(Classe,_)|Esempi], l(Classe):1) :-	      % caso in cui si ha un insieme di esempi tutti della stessa classe: viene creata una foglia alla quale è assegnata una probabilità pari ad 1
	\+ ( member(e(ClassX,_),Esempi), ClassX \== Classe ),!.    % non deve esistere nessun esempio nell'insieme che sia di classe diversa dagli altri

induce_albero( Attributi, Esempi, t(Attributo,SottoAlberi) ) :-   % caso in cui ci gli esempi sono di classi differenti: viene creato un nodo al quale sono associati un attributo e dei sottoalberi che si genereerà da questo
	min_attr( Attributi, Esempi, Attributo), !,                % viene scelto l'attirbuto che minimizza l'entropia con min_attr(+Attributi,+Esempi,-Attributo), il cut garantisce un risultato deterministico
	rimuovi( Attributo, Attributi, Rimanenti ),                % si rimuove l'attributo scelto dalla lista Attributi ottenendo la lista Rimanenti con rimuovi(+Attributo,+Attributi,-Rimanenti)
	a( Attributo, Valori ),                                    % si collocano i valori dell'attributo scelto nella variabile Valori
	induce_alberi( Attributo, Valori, Rimanenti, Esempi, SottoAlberi).% si utilizza induce_alberi(+Attributo,+Valori,+Rimanenti,+Esempi,-SottoAlberi) per formare i vari sotto alberi generati a seguito della scelta dell'attributo

induce_albero( _, Esempi, l(C):P) :-		% caso in cui non vi sono più attributi utili alla classificazione: si forma una folgia assrgnando una calsse C con probabilità P
	findall( Classe, member(e(Classe,_),Esempi), Classi),      % si prendono le varie classi presenti negli esempi e le si mettono nella lista Classi
	length(Classi,N),					   % si calcola la lunghezza N della lista Classi
	findall(1, member(n,Classi), Negativi),                    % si cercano le classi "n" nella lista Classi e si pongono nella lista Negativi
	length(Negativi, NN),                                      % si calcola la lunghezza NN della lista Negativi
	conta_classi(N,NN,C,P).                                    % con conta classi si ricava la classe C più numerosa e la sua probabilità P

% conta_classi(+Numero_totale,+Numero_egativi,-Classe_dominante,-Probabilità),
%  basandosi sul numero totale di esempi e il numero dei quali hanno
%  classe negativa, valuta la classe dominante e la sua probabilità
conta_classi(N,NN,y,P) :-	% caso in cui la classe dominante è "y"
	NN < N/2,                         % le classi negative sono meno della metà del numero di esempi
	P is 1-(NN/N).                    % la probabilità della classe positiva è il reciproco della porbabilità di avere un negativo

conta_classi(N,NN,n,P) :-      % caso in cui la classe dominante è "n"
	NN > N/2,			  % le classi negative sono più della metà del numero di esempi
	P is NN/N.			  % la probabilità di avere un negativo è in numero di negativi sul numero totale di esempi considerati

conta_classi(N,NN,nc,0) :-     % caso in cui non è possibile una classificazione: classe "nc" (non classificata) e probabilità 0
	NN =:= N/2.                       % il unmero di negativi è esattamente la metà degli esempi considerati

% min_attr(+Attributi,+Esempi,-AttributoMinimizzante), ha lo scopo di
% scelgliere fra la lista Attributi quello che minimizza il contenuto di
% entropia nel sotto insieme generato dalla lista Esempi
min_attr(Attributi, Esempi, AttrMinimizz) :-
	findall( Somma/A,						  % si cercano tutte le coppie Somma/A tali che:
		(member(A,Attributi) , somma_attributo( Esempi,A,Somma)), % ...A sia parte di Attributi e Somma sia il risultato di somma_attributo
		 L),							  % ...i risultati vengono posizionati nella Lista L
	findall(Somma, (member(Somma/A,L)), ListaValori),		  % si cercano tutte le somme che siano parte delle coppie Somma/A e si mettono in ListaValori
	prendi_minimo(ListaValori, Min),				  % si seleziona il valore minimo contenuto in ListaValori
	member(Min/AttrMinimizz,L).                                       % si controlla che la coppia formata dal valore minimo e l'attributo minimizzante faccia parte della lista L

% prendi_minimo(+Lista,-ElemMinimo), data una lista ne cerca l'elemento
% minore in valore sfruttando min_lista(+Lista,+Valore1,+Valore2)
prendi_minimo([Testa|Coda], Minimo) :-
    min_lista(Coda, Testa, Minimo).       % utilizzando il predicato min_lista si ottiene l'elemento minimo della lista passata in argomento

% min_lista(+Lista,+Valore1,+Valore2), serve ad estrarre il valore
% minimo contenuto in una lista
min_lista([], Min, Min).           % tappo della ricorsione: se la lista è vuota vuol dire che il minimo è stato trovato e si trova al secondo argomento, perciò lo si restituisce come terzo argomento

min_lista([Testa|Coda], TestaPrec, Min) :-  % a Min0 è passata la testa della precedente lista
	Min1 is min(Testa, TestaPrec),          % si prende il valore minimo fra la vecchia e la nuova testa e lo si mette in Min1
	min_lista(Coda, Min1, Min).		% si effettua una ricorsione passando il minimo aggiornato e la coda della lista

% somma_attributo(+Esempi,+Attributo,-Somma) va a calcolare, per ogni
% valore dell'attributo passato per argomento, l'entropia generata ed
% effettua la somma di questi valori
somma_attributo( Esempi, Attributo, Somma) :-
	a( Attributo, ValoriAttributo),                             % si prende la lista di valori appartenenti all'attributo esaminato
	somma( Esempi, Attributo, ValoriAttributo, 0, Somma),!.	    % si va a calcolare la sommatoria dell'entropia generata da ogni valore dell'attributo passato per argomento. Dopo il calcolo il predicato termina

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
        entropia(Pp,E),
        NuovaSommaParziale is SommaParziale + E*NVal/N,
        somma(Esempi,Att,Valori,NuovaSommaParziale,Somma)
        ;
        somma(Esempi,Att,Valori,SommaParziale,Somma).

entropia([],0).
entropia([1],0).
entropia([P],E):-
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

