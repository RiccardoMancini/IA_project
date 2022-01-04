% programma per apprendere inducendo Alberi di Decisione testandone
% l' efficacia
:- ensure_loaded(titanic_dataset).
:- ensure_loaded(titanic_test_set).

:- dynamic alb/1.

a(age,[28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77]).
a(sex,["M","F"]).
a(chest_pain_type,["ATA","NAP","ASY","TA"]).
a(restingBP,[0,80,92,94,95,96,98,100,101,102,104,105,106,108,110,112,113,114,115,116,117,118,120,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,148,150,152,154,155,156,158,160,164,165,170,172,174,178,180,185,190,192,200]).
a(cholesterol,[0,85,100,110,113,117,123,126,129,131,132,139,141,142,147,149,152,153,156,157,159,160,161,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,190,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,297,298,299,300,302,303,304,305,306,307,308,309,310,311,312,313,315,316,318,319,320,321,322,325,326,327,328,329,330,331,333,335,336,337,338,339,340,341,342,344,347,349,353,354,355,358,360,365,369,384,385,388,392,393,394,404,407,409,412,417,458,466,468,491,518,529,564,603]).
a(fastingBP,[0,1]).
a(restingECG,["Normal","ST","LVH"]).
a(maxHR,[60,63,67,69,70,71,72,73,77,78,80,82,83,84,86,87,88,90,91,92,93,94,95,96,97,98,99,100,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,184,185,186,187,188,190,192,194,195,202]).
a(exercise_angina,["N","Y"]).
a(oldpeak,[-2.6,-2.0,-1.5,-1.1,-1.0,-0.9,-0.8,-0.7,-0.5,-0.1,0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,2.0,2.1,2.2,2.3,2.4,2.5,2.6,2.8,2.9,3.0,3.1,3.2,3.4,3.5,3.6,3.7,3.8,4.0,4.2,4.4,5.0,5.6,6.2]).
a(st_slope,["Up","Flat","Down"]).
e(n,[age = 40, sex = "M", chest_pain_type = "ATA", restingBP = 140, cholesterol = 289, fastingBS = 0, restingECG = "Normal", maxHR = 172, exercise_angina = "N", oldpeak = 0, st_slope = "Up"]).
e(y,[age = 49, sex = "F", chest_pain_type = "NAP", restingBP = 160, cholesterol = 180, fastingBS = 0, restingECG = "Normal", maxHR = 156, exercise_angina = "N", oldpeak = 1, st_slope = "Flat"]).
e(n,[age = 37, sex = "M", chest_pain_type = "ATA", restingBP = 130, cholesterol = 283, fastingBS = 0, restingECG = "ST", maxHR = 98, exercise_angina = "N", oldpeak = 0, st_slope = "Up"]).
e(y,[age = 48, sex = "F", chest_pain_type = "ASY", restingBP = 138, cholesterol = 214, fastingBS = 0, restingECG = "Normal", maxHR = 108, exercise_angina = "Y", oldpeak = 1.5, st_slope = "Flat"]).
e(n,[age = 54, sex = "M", chest_pain_type = "NAP", restingBP = 150, cholesterol = 195, fastingBS = 0, restingECG = "Normal", maxHR = 122, exercise_angina = "N", oldpeak = 0, st_slope = "Up"]).
e(n,[age = 39, sex = "M", chest_pain_type = "NAP", restingBP = 120, cholesterol = 339, fastingBS = 0, restingECG = "Normal", maxHR = 170, exercise_angina = "N", oldpeak = 0, st_slope = "Up"]).
e(n,[age = 45, sex = "F", chest_pain_type = "ATA", restingBP = 130, cholesterol = 237, fastingBS = 0, restingECG = "Normal", maxHR = 170, exercise_angina = "N", oldpeak = 0, st_slope = "Up"]).
e(n,[age = 54, sex = "M", chest_pain_type = "ATA", restingBP = 110, cholesterol = 208, fastingBS = 0, restingECG = "Normal", maxHR = 142, exercise_angina = "N", oldpeak = 0, st_slope = "Up"]).
e(y,[age = 37, sex = "M", chest_pain_type = "ASY", restingBP = 140, cholesterol = 207, fastingBS = 0, restingECG = "Normal", maxHR = 130, exercise_angina = "Y", oldpeak = 1.5, st_slope = "Flat"]).
e(n,[age = 48, sex = "F", chest_pain_type = "ATA", restingBP = 120, cholesterol = 284, fastingBS = 0, restingECG = "Normal", maxHR = 120, exercise_angina = "N", oldpeak = 0, st_slope = "Up"]).


induce_albero( Albero ) :-
	findall( e(Classe,Oggetto), e(Classe,Oggetto), Esempi),
        findall( Att,a(Att,_), Attributi),
        induce_albero( Attributi, Esempi, Albero),
	mostra( Albero ),
	assert(alb(Albero)).

% induce_albero( +Attributi, +Esempi, -Albero):
% l'Albero indotto dipende da questi tre casi:
% (1) Albero = null: l'insieme degli esempi è vuoto
% (2) Albero = l(Classe): tutti gli esempi sono della stessa classe
% (3) Albero = t(Attributo, [Val1:SubAlb1, Val2:SubAlb2, ...]):
%     gli esempi appartengono a più di una classe
%     Attributo è la radice dell'albero
%     Val1, Val2, ... sono i possibili valori di Attributo
%     SubAlb1, SubAlb2,... sono i corrispondenti sottoalberi di
%     decisione.
% (4) Albero = l(Classi): non abbiamo Attributi utili per
%     discriminare ulteriormente
induce_albero( _, [], null ) :- !.			         % (1)
induce_albero( _, [e(Classe,_)|Esempi], l(Classe)) :-	         % (2)
	\+ ( member(e(ClassX,_),Esempi), ClassX \== Classe ),!.  % no esempi di altre classi (OK!!)
induce_albero( Attributi, Esempi, t(Attributo,SAlberi) ) :-	 % (3)
	sceglie_attributo( Attributi, Esempi, Attributo), !,     % implementa la politica di scelta
	del( Attributo, Attributi, Rimanenti ),			 % elimina Attributo scelto
	a( Attributo, Valori ),					 % ne preleva i valori
	induce_alberi( Attributo, Valori, Rimanenti, Esempi, SAlberi).
induce_albero( _, Esempi, l(Classi)) :-                          % finiti gli attributi utili (KO!!)
	findall( Classe, member(e(Classe,_),Esempi), Classi).

% sceglie_attributo( +Attributi, +Esempi, -MigliorAttributo):
% seleziona l'Attributo che meglio discrimina le classi; si basa sul
% concetto della "Gini-disuguaglianza"; utilizza il setof per ordinare
% gli attributi in base al valore crescente della loro disuguaglianza
% usare il setof per far questo è dispendioso e si può fare di meglio ..
sceglie_attributo( Attributi, Esempi, MigliorAttributo )  :-
	setof( Sum/A,
	      (member(A,Attributi) , disuguaglianza(Esempi,A,Sum)),
	      [MinorDisuguaglianza/MigliorAttributo|_] ).

% disuguaglianza(+Esempi, +Attributo, -Dis):
% Dis è la disuguaglianza combinata dei sottoinsiemi degli esempi
% partizionati dai valori dell'Attributo
disuguaglianza( Esempi, Attributo, Sum) :-
	a( Attributo, AttVals),
	somma( Esempi, Attributo, AttVals, 0, Sum),!.

somma(_,_,[],Pbase,Pbase).
somma( Esempi, Att, [Val|Valori], SommaParziale, Somma) :-                      % quanti sono gli esempi
        length(Esempi, N),
	findall( C,						     % EsempiSoddisfatti: lista delle classi ..
		 (member(e(C,Desc),Esempi) , soddisfa(Desc,[Att=Val])), % .. degli esempi (con ripetizioni)..
		 EsempiSoddisfatti ),				     % .. per cui Att=Val
	length(EsempiSoddisfatti, NVal),			     % quanti sono questi esempi
	NVal > 0, !,                                                 % almeno uno!
	findall(P,			           % trova tutte le P robabilit�
                (bagof(1,		           %
                       member(y,EsempiSoddisfatti),
                       L),
                 length(L,NVC),
                 P is NVC/NVal),
                Pp),
        %appendi(Pbase,Pp,Newbase),
        entropy(Pp,E),
        NuovaSommaParziale is SommaParziale + E*NVal/N,
        somma(Esempi,Att,Valori,NuovaSommaParziale,Somma)
        ;
        somma(Esempi,Att,Valori,SommaParziale,Somma).  %nessun esempio soddisfa Att = Val

entropy([],0).
entropy([1],0).
entropy([P],E):-
        log(P,L1),
        log((1-P),L2),
        E is -1*(P*L1+(1-P)*L2).


% somma_pesata( +Esempi, +Attributo, +AttVals, +SommaParziale, -Somma)
% restituisce la Somma pesata delle disuguaglianze
% Gini = sum from{v} P(v) * sum from{i <> j} P(i|v)*P(j|v)
somma_pesata( _, _, [], Somma, Somma).
somma_pesata( Esempi, Att, [Val|Valori], SommaParziale, Somma) :-
	length(Esempi,N),                                            % quanti sono gli esempi
	findall( C,						     % EsempiSoddisfatti: lista delle classi ..
		 (member(e(C,Desc),Esempi) , soddisfa(Desc,[Att=Val])), % .. degli esempi (con ripetizioni)..
		 EsempiSoddisfatti ),				     % .. per cui Att=Val
	length(EsempiSoddisfatti, NVal),			     % quanti sono questi esempi
	NVal > 0, !,                                                 % almeno uno!
	findall(P,			           % trova tutte le P robabilità
                (bagof(1,		           %
                       member(_,EsempiSoddisfatti),
                       L),
                 length(L,NVC),
                 P is NVC/NVal),
                ClDst),
        gini(ClDst,Gini), %q*log.....
	NuovaSommaParziale is SommaParziale + Gini*NVal/N, %gain
	somma_pesata(Esempi,Att,Valori,NuovaSommaParziale,Somma)
	;
	somma_pesata(Esempi,Att,Valori,SommaParziale,Somma). % nessun esempio soddisfa Att = Val

% gini(ListaProbabilità, IndiceGini)
%    IndiceGini = SOMMATORIA Pi*Pj per tutti i,j tali per cui i\=j
%    E' equivalente a 1 - SOMMATORIA Pi*Pi su tutti gli i
gini(ListaProbabilità,Gini) :-
	somma_quadrati(ListaProbabilità,0,SommaQuadrati),
	Gini is 1-SommaQuadrati.
somma_quadrati([],S,S).
somma_quadrati([P|Ps],PartS,S)  :-
	NewPartS is PartS + P*P,
	somma_quadrati(Ps,NewPartS,S).

% induce_alberi(Attributi, Valori, AttRimasti, Esempi, SAlberi):
% induce decisioni SAlberi per sottoinsiemi di Esempi secondo i Valori
% degli Attributi
induce_alberi(_,[],_,_,[]).     % nessun valore, nessun sottoalbero
induce_alberi(Att,[Val1|Valori],AttRimasti,Esempi,[Val1:Alb1|Alberi])  :-
	attval_subset(Att=Val1,Esempi,SottoinsiemeEsempi),
	induce_albero(AttRimasti,SottoinsiemeEsempi,Alb1),
	induce_alberi(Att,Valori,AttRimasti,Esempi,Alberi).

% attval_subset( Attributo = Valore, Esempi, Subset):
%   Subset è il sottoinsieme di Examples che soddisfa la condizione
%   Attributo = Valore
attval_subset(AttributoValore,Esempi,Sottoinsieme) :-
	findall(e(C,O),(member(e(C,O),Esempi),soddisfa(O,[AttributoValore])),Sottoinsieme).

% soddisfa(Oggetto, Descrizione):
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


% ================================================================================
% classifica( +Oggetto, -Classe, t(+Att,+Valori))
%  Oggetto: [Attributo1=Valore1, .. , AttributoN=ValoreN]
%  Classe: classe a cui potrebbe appartenere un oggetto caratterizzato da quelle coppie
%  Attributo=Valore
%  t(-Att,-Valori): Albero di Decisione
% presuppone sia stata effettuata l'induzione dell'Albero di Decisione

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


stampa_matrice_di_confusione :-
	alb(Albero),
	findall(Classe/Oggetto,s(Classe,Oggetto),TestSet),
	length(TestSet,N),
	valuta(Albero,TestSet,VN,0,VP,0,FN,0,FP,0,NC,0),
	A is (VP + VN) / (N - NC), % Accuratezza
	E is 1 - A,		   % Errore
	write('Test effettuati :'),  writeln(N),
	write('Test non classificati :'),  writeln(NC),
	write('Veri Negativi  '), write(VN), write('   Falsi Positivi '), writeln(FP),
	write('Falsi Negativi '), write(FN), write('   Veri Positivi  '), writeln(VP),
	write('Accuratezza: '), writeln(A),
	write('Errore: '), writeln(E).

valuta(_,[],VN,VN,VP,VP,FN,FN,FP,FP,NC,NC).            % testset vuoto -> valutazioni finali
valuta(Albero,[deceduto/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-
	classifica(Oggetto,deceduto,Albero), !,      % prevede correttamente non sopravvivenza
	VNA1 is VNA + 1,
	valuta(Albero,Coda,VN,VNA1,VP,VPA,FN,FNA,FP,FPA,NC,NCA).
valuta(Albero,[sopravvissuto/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-
	classifica(Oggetto,sopravvissuto,Albero), !, % prevede correttamente sopravvivenza
	VPA1 is VPA + 1,
	valuta(Albero,Coda,VN,VNA,VP,VPA1,FN,FNA,FP,FPA,NC,NCA).
valuta(Albero,[sopravvissuto/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-
	classifica(Oggetto,deceduto,Albero), !,      % prevede erroneamente non sopravvivenza
	FNA1 is FNA + 1,
	valuta(Albero,Coda,VN,VNA,VP,VPA,FN,FNA1,FP,FPA,NC,NCA).
valuta(Albero,[deceduto/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :-
	classifica(Oggetto,sopravvissuto,Albero), !, % prevede erroneamente sopravvivenza
	FPA1 is FPA + 1,
	valuta(Albero,Coda,VN,VNA,VP,VPA,FN,FNA,FP,FPA1,NC,NCA).
valuta(Albero,[_/Oggetto|Coda],VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA) :- % non classifica
	classifica(Oggetto,nc,Albero), !, % non classificato
	NCA1 is NCA + 1,
	valuta(Albero,Coda,VN,VNA,VP,VPA,FN,FNA,FP,FPA,NC,NCA1).
