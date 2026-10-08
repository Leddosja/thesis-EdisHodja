#import "shared.typ": *

#pagebreak()

= Descrizione dello stage <descrizione-stage>

Questo capitolo descrive come è stato organizzato il lavoro di stage. Il piano concordato con il tutor aziendale #tutor fissa l’ordine delle attività, la durata delle settimane e i punti di controllo. Le scelte di dettaglio, come la forma dei test o l’ordine con cui affrontare i requisiti di una stessa area, sono state prese durante lo sviluppo.

== Rapporto con l’azienda <rapporto-azienda>

Lo stage si svolge prevalentemente in presenza presso la sede di #azienda a Tombolo (PD). Le attività di sviluppo possono essere svolte anche da remoto quando concordato di volta in volta con il tutor aziendale #tutor, mentre le fasi di analisi, le revisioni e i test restano normalmente condotte in presenza.

Il piano di lavoro individua due prodotti attesi al termine dello stage, con pari importanza nella valutazione finale: una relazione scritta, articolata in un blocco di analisi dei requisiti normativi e dell’architettura della soluzione, in un blocco di descrizione dell’implementazione del prototipo e in un blocco di risultati dei test con l’elenco esplicito delle parti simulate; e il prototipo stesso.

== Organizzazione del lavoro <organizzazione-lavoro>

Il lavoro si svolge in otto settimane: sette da quaranta ore e una da venti in cui ciascuna corrisponde ad un blocco funzionale del sistema. Si parte dall’analisi normativa e dall’ambiente di sviluppo, si passa al modello dei dati e alla carta simulata, poi a emissione e annullo, log e riepiloghi. Le ultime settimane sono dedicate a vendita online, nominatività, controllo accessi e test. 
\ L’ordine non è casuale: il log registra i movimenti prodotti dall’emissione, quindi conviene costruire prima l’emissione, e il controllo accessi legge titoli che devono già esistere nel sistema.

Ogni settimana segue lo stesso schema in cui il primo incontro con il tutor, all’inizio della settimana, serve a fissare le task: quali requisiti coprire, quali flussi realizzare e quali risorse servono, come documentazione normativa, ambienti e dati di prova. A metà settimana si tiene un incontro intermedio, riservato ai problemi emersi durante lo sviluppo. L’ultimo incontro, a fine settimana, prevede una dimostrazione dei flussi sul prototipo.

== Revisione del codice e supporto <revisione-codice>

Il codice viene rivisto periodicamente dal tutor aziendale #tutor tramite un sistema di versionamento fornito da Gitea. Lo sviluppo si appoggia a un branch dedicato alla parte di prototipo di competenza dello stage, sul quale vengono caricati i commit via via che le attività della settimana procedono.

La revisione controlla tre aspetti: che il codice sia leggibile e coerente con l’architettura di riferimento, che le funzioni rispettino i requisiti normativi a cui dovrebbero corrispondere e che la logica sia corretta nei casi limite.

== Dai requisiti alle evidenze <matrice-requisiti>

Il punto di partenza sono i requisiti che l’azienda ha raccolto in gruppi tematici, dalla A alla N, insieme alle checklist e al testo del D.M. 13 luglio 2000 e dei provvedimenti dell’Agenzia delle Entrate. \ Non tutti i requisiti rientrano nel perimetro dello stage e quelli selezionati vengono tradotti in una riga della matrice requisito → componente → test → evidenza redatta, sfruttando Google Sheets, durante la prima settimana ed aggiornata nel corso delle settimane successive. \ La riga indica quale parte del sistema implementa il requisito, quale test lo verifica e quale evidenza ne mostra il risultato, per esempio un tracciato generato o l’esito di un test di concorrenza.

== Strategia di verifica <strategia-verifica>

La verifica si divide in due gruppi di test. I test funzionali seguono i flussi end-to-end: configurazione dell’evento, vendita, emissione, controllo accessi, chiusura giornaliera e riepilogo. Ogni flusso viene percorso dall’inizio alla fine sul prototipo, controllando sia ciò che vede l’utente sia ciò che viene registrato.

I test di concorrenza riproducono richieste simultanee sui vincoli che non devono cedere: una sola stampa per titolo, limite di dieci titoli per evento e utente, unicità del cellulare a livello di sistema e scansioni contemporanee al varco. Un vincolo di questo tipo si verifica solo quando più richieste arrivano nello stesso momento, quindi un test sequenziale non basta a dimostrarlo.

#pagebreak()

== Analisi preventiva dei rischi <analisi-rischi>

Durante la fase di analisi iniziale sono stati individuati alcuni rischi legati alla natura normativa e tecnica del progetto. Per ciascuno è stata individuata una strategia di mitigazione.

#risk(1, [Carta di attivazione e specifiche SIAE non disponibili], [le specifiche di interazione con la carta di attivazione sono fornite da SIAE solo su richiesta e non sono quindi disponibili durante lo stage; la carta, il sigillo fiscale e il supporto immodificabile devono perciò essere simulati], [simulare i componenti mancanti dichiarandoli esplicitamente come tali nella relazione, mantenendo le interfacce compatibili con una futura sostituzione con i componenti reali]) <risk-carta-simulata>

#risk(2, [Interpretazione della normativa], [i testi del D.M. 13 luglio 2000 e dei provvedimenti dell’Agenzia delle Entrate sono scritti in modo generico su alcuni punti e possono essere letti in più modi], [condividere ogni interpretazione dubbia con il tutor aziendale #tutor prima di tradurla in codice, tramite gli incontri settimanali o il canale Telegram]) <risk-interpretazione-normativa>

#risk(3, [Difetti di concorrenza sui vincoli critici], [vincoli come la singola stampa per titolo, il limite di dieci titoli per evento e utente e l’unicità del cellulare devono reggere a richieste simultanee, e un errore di progettazione emergerebbe solo sotto carico concorrente], [dedicare una settimana del piano a test di concorrenza mirati sui vincoli critici, oltre ai test funzionali sequenziali descritti nella sezione precedente]) <risk-concorrenza>


#risk(4, [Dipendenze tra le settimane del piano], [alcune funzionalità dipendono da quelle delle settimane precedenti, per esempio il log registra i movimenti prodotti dall’emissione e il controllo accessi legge titoli che devono già esistere, quindi un ritardo in una settimana si propaga alle successive], [seguire l’ordine di sviluppo stabilito nel piano e verificare l’avanzamento negli incontri di inizio e fine settimana con il tutor, in modo da intercettare presto eventuali ritardi]) <risk-dipendenze-settimane>

#risk(5, [Tempo insufficiente per gli obiettivi non obbligatori], [le 300 ore disponibili sono ripartite tra obiettivi obbligatori, desiderabili e facoltativi, e un rallentamento sui primi riduce il tempo per gli altri], [dare priorità ai requisiti obbligatori O01–O05, poi ai desiderabili D01–D04 e infine ai facoltativi F01–F03, dichiarando nella relazione finale la copertura effettivamente raggiunta]) <risk-priorita-obiettivi>
