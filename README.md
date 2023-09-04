# Valutazioni probabilistiche e tecniche di apprendimento automatico (progetto IA in Prolog-cplint)
## Descrizione generale
Il progetto svolto tratta un approfondimento nell’ambito
probabilistico e nell’apprendimento automatico in Prolog, considerando un dataset sui disturbi cardiaci.
 La prima fase del progetto studia l’aspetto probabilistico
che permette di dare un'indicazione sulle relazioni fra i valori
presenti nel dataset. Con l’utilizzo del Cplint vengono
calcolate delle probabilità rilevanti (semplici, congiunte e
condizionate), che consentono di studiare i legami fra i singoli
attributi e la classe che caratterizzano i casi presenti nel
dataset. Questo studio affianca il risultato dell'apprendimento,
effettuato sul medesimo dataset, per valutarne la coerenza.
Sull’apprendimento sviluppato oltre la valutazione
dell’accuratezza di classificazione e di conseguenza il suo
errore, viene svolto un confronto fra i due criteri di scelta
dell’attributo (Shannon e Gini) per l’induzione dell’albero
decisionale.
 Inoltre, si è studiato un modo per rendere gli algoritmi
meno onerosi in termini di complessità computazionale. 
[Leggi di più](./paper-progetto.pdf)

### Alcuni link utili:

_Link algoritmo id3: https://github.com/ignaciomosca/id3-prolog_

_Link dataset heart issues: https://www.kaggle.com/fedesoriano/heart-failure-prediction_

_Documentazione cplint: http://friguzzi.github.io/cplint/_build/latex/cplint.pdf_

_Appunti vari: https://docs.google.com/document/d/15ddOQqzEjZuvyDJ0g_bkPUN5V49Tc9Y1/edit_ 

_Link paper cplint on SWISH: https://ml.unife.it/wp-content/uploads/Papers/RigBelLam-SPE16.pdf_

*Esempio previsione:* previsione([age = "Second", sex = "M", chest_pain_type = "ATA", restingBP = "Normal/high", cholesterol = "Extremely high", fastingBS = 0, restingECG = "Normal", maxHR = 3, exercise_angina = "N", oldpeak = "Low risk", st_slope = "Up"],Classe).
