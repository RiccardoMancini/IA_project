:- use_module(library(pita)).
:- pita.

:- begin_lpad.

numero_persone(N) :-
    findall(1, e(_,_), Campioni),
    length(Campioni, N).
persone_malate(N):-
    findall(1, e(y,_), Malati),
    length(Malati, N).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Probabilità semplici %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

eta(Val,N):- %esempio: prob(prob_eta("Seconda"),P).
    findall(1, e(_,[age = Val|_]),Lista),
    length(Lista,N).

prob_eta(Val):AN/N:-
    eta(Val,AN),
    numero_persone(N).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sesso(Val,N):- %esempio: prob(prob_sesso("M"),P).
    findall(1, e(_,[_,sex = Val|_]),Lista),
    length(Lista,N).

prob_sesso(Val):SEX/N:-
    sesso(Val,SEX),
    numero_persone(N).

verifica_sesso: Ptot :-
    prob(prob_sesso("M"),PM),
    prob(prob_sesso("F"),PF),
    Ptot = PM + PF.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chest_pain(Val,N):- %esempio: prob(prob_chest_pain("ATA"),P).
    findall(1, e(_,[_,_,chest_pain_type = Val|_]),Lista),
    length(Lista,N).

prob_chest_pain(Val):CP/N:-
    chest_pain(Val,CP),
    numero_persone(N).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
restingBP(Val,N):- %esempio: prob(prob_restingBP("High"),P).
    findall(1, e(_,[_,_,_,restingBP = Val|_]),Lista),
    length(Lista,N).

prob_resting_BP(Val):RBP/N:-
    restingBP(Val,RBP),
    numero_persone(N).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colesterolo(Val,N):- %esempio: prob(prob_col("Extremely high"),P).
    findall(1, e(_,[_,_,_,_,cholesterol = Val|_]),Lista),
    length(Lista,N).

prob_col(Val):COL/N:-
    colesterolo(Val,COL),
    numero_persone(N).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fastingBS(Val,N):- %esempio: prob(prob_fastingBS(0),P).
    findall(1, e(_,[_,_,_,_,_,fastingBS = Val|_]),Lista),
    length(Lista,N).

prob_fasting_BS(Val):FBS/N:-
    fastingBS(Val,FBS),
    numero_persone(N).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%col_Ex_high(N):-
 %   findall(1, e(_,[_,_,_,_,cholesterol = "Extremely high"|_]),ColAlto),
 %  length(ColAlto,N).

%prob_col_Ex_high:CH/N:-
 %   col_Ex_high(CH),
 %   numero_persone(N).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
restingECG(Val,N):- %Val: ["Normal","ST","LVH"]
    findall(1, e(_,[_,_,_,_,_,_,restingECG = Val|_]),Lista),
    length(Lista,N).

prob_restingECG(Val):RECG/N :-
    restingECG(Val,RECG),
    numero_persone(N).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
maxHR(Val,N):- %Val: [1,2,3,4]
    findall(1, e(_,[_,_,_,_,_,_,_,maxHR = Val|_]),Lista),
    length(Lista,N).

prob_maxHR(Val):MHR/N :-
    maxHR(Val,MHR),
    numero_persone(N).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ex_angina(Val,N):- %Val: ["N","Y"]
    findall(1, e(_,[_,_,_,_,_,_,_,_,exercise_angina = Val|_]),Lista),
    length(Lista,N).

prob_ex_angina(Val):EX/N :-
    ex_angina(Val,EX),
    numero_persone(N).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
oldpeak(Val,N):- %Val: ["Low risk","Normal risk","High risk"]
    findall(1, e(_,[_,_,_,_,_,_,_,_,_,oldpeak = Val|_]),Lista),
    length(Lista,N).

prob_oldpeak(Val):OP/N :-
    oldpeak(Val,OP),
    numero_persone(N).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
st_slope(Val,N):- %Val: ["Up","Flat","Down"]
    findall(1, e(_,[_,_,_,_,_,_,_,_,_,_,st_slope = Val]),Lista),
    length(Lista,N).

prob_st_slope(Val):ST/N :-
    st_slope(Val,ST),
    numero_persone(N).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prob_malato:PM/N:-
    persone_malate(PM),
    numero_persone(N).

prob_sano:1-PM:-
    prob(prob_malato,PM).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Probabilità Congiunte %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%prob_malato_colesterolo(+Col) ["Desiderable","Moderately high","Extremely high"]
prob_malato_col(Val): P/N :-
    findall(1, e(y,[_,_,_,_,cholesterol = Val|_]),Lista),
    length(Lista,P),
	numero_persone(N).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Probabilità Condizionate %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%prob(Malato|colesterolo)
prob_malato_per_col(Col): P :-
    prob(prob_malato_col(Col),PAB),
    prob(prob_col(Col),PB),
    P is PAB/PB.
    

:- end_lpad.

verifica_sesso(Ptot):-
    prob(prob_sesso("M"),PM),
    prob(prob_sesso("F"),PF),
    Ptot = PM + PF.

a(age,["First","Second","Third"]).
a(sex,["M","F"]).
a(chest_pain_type,["ATA","NAP","ASY","TA"]).
a(restingBP,["Optimal","Normal/high","High","Very high"]).
a(cholesterol,["Desiderable","Moderately high","Extremely high"]).
a(fastingBS,[0,1]).
a(restingECG,["Normal","ST","LVH"]).
a(maxHR,[1,2,3,4]).
a(exercise_angina,["N","Y"]).
a(oldpeak,["Low risk","Normal risk","High risk"]).
a(st_slope,["Up","Flat","Down"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Very high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 1, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 1, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "TA", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 1, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 1, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Very high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 1, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 1, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Very high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Very high", cholesterol = "Desiderable", fastingBS = 1, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "TA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "High risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Very high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Very high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "ST", maxHR = 1, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Very high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "TA", restingBP = "Very high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "TA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Very high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "TA", restingBP = "Very high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Very high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 1, restingECG = "LVH", maxHR = 1, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 1, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 1, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 1, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Down"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 1, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "TA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "High risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 1, restingECG = "ST", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "TA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "ST", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 1, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Down"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "ST", maxHR = 1, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "TA", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Desiderable", fastingBS = 1, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 1, restingECG = "ST", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "N", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "ST", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "TA", restingBP = "High", cholesterol = "Moderately high", fastingBS = 1, restingECG = "ST", maxHR = 2, exercise_angina = "N", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "TA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 1, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 1, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "TA", restingBP = "High", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Desiderable", fastingBS = 1, restingECG = "ST", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "ST", maxHR = 4, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Desiderable", fastingBS = 1, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Desiderable", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 1, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "LVH", maxHR = 1, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "ST", maxHR = 2, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 1, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 1, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 1, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 1, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "TA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "ST", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 1, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "TA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "TA", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 1, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Moderately high", fastingBS = 1, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ATA", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 1, restingECG = "Normal", maxHR = 1, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Desiderable", fastingBS = 1, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "TA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "TA", restingBP = "High", cholesterol = "Moderately high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Down"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 2, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "TA", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "NAP", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Down"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Very high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 4, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 1, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "High risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Down"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "High risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 4, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Down"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "TA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "TA", restingBP = "Very high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Down"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "High risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "TA", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "High risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 1, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "TA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Down"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "High risk", st_slope = "Down"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Optimal", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "ATA", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Extremely high", fastingBS = 1, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "High risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Optimal", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Down"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Very high", cholesterol = "Desiderable", fastingBS = 1, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 2, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(n,[age = "Third", sex = "M", chest_pain_type = "TA", restingBP = "Very high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Third", sex = "F", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "ST", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Moderately high", fastingBS = 1, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Down"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "NAP", restingBP = "High", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Down"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Desiderable", fastingBS = 0, restingECG = "LVH", maxHR = 3, exercise_angina = "Y", oldpeak = "High risk", st_slope = "Up"]).
e(y,[age = "Third", sex = "F", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Very high", cholesterol = "Desiderable", fastingBS = 1, restingECG = "LVH", maxHR = 1, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Low risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "TA", restingBP = "Optimal", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Third", sex = "M", chest_pain_type = "ASY", restingBP = "High", cholesterol = "Desiderable", fastingBS = 1, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "High risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "M", chest_pain_type = "ASY", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 2, exercise_angina = "Y", oldpeak = "Normal risk", st_slope = "Flat"]).
e(y,[age = "Second", sex = "F", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Moderately high", fastingBS = 0, restingECG = "LVH", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Flat"]).
e(n,[age = "Second", sex = "M", chest_pain_type = "NAP", restingBP = "Normal/high", cholesterol = "Desiderable", fastingBS = 0, restingECG = "Normal", maxHR = 4, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"]).