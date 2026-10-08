#import "shared.typ": *

/*
#let status-table(rows, caption: none) = {
  table(
    columns: (1.5cm, 1fr, 3cm, 2cm),
    inset: 5pt,
    stroke: 0.5pt + rgb("b8b8bd"),
    fill: (_, row) => if calc.odd(row) { rgb("f5f5f7") } else { white },
    table.header([*ID*], [*Requisito*], [*Stato*], [*Use case*]),
    ..rows.flatten(),
  )
  if caption != none {
    align(center)[#emph(caption)]
  }
}

// BOZZA. Fonti: "12 - Requisiti (per gruppi)" e "Matrice dei requisiti - Biglietteria SIAE".
// Da verificare: la checklist dichiara 88 requisiti, ma i gruppi A–L ne contengono 71.
// I 17 mancanti sono nel file "11 - Requisiti (checklist 88)", che non è ancora stato letto.
// Da fare: la matrice usa codici diversi (CA-01, MF-01, TA-01…). Va riportata sui codici della checklist.
// Gli stati della colonna "Stato" sono una proposta mia: vanno confermati con il tutor.

#pagebreak()

= Analisi dei requisiti <analisi-requisiti>

Questo capitolo raccoglie i requisiti del prototipo e li collega ai casi d’uso che li realizzano. La fonte principale è il documento di requisiti costruito dall’azienda a partire dalla normativa, organizzato in gruppi tematici. Ogni requisito conserva il codice della checklist aziendale, così che la matrice requisito → componente → test → evidenza del capitolo 5 usi gli stessi identificativi.

== Fonti normative e perimetro <fonti-perimetro>

Il riferimento normativo è il D.M. 13 luglio 2000, con i provvedimenti dell’Agenzia delle Entrate del 23 luglio 2001, del 22 ottobre 2002, del 4 marzo 2008, n. 223774 del 2019 e n. 356768 del 2025. Si aggiunge la checklist dell’Agenzia del 2 dicembre 2002 per la certificazione dei sistemi di emissione.

Il perimetro è il sistema di emissione dei titoli di accesso previsto dall’art. 2, comma 1, lettera b), del D.M. 2000, con vendita online e controllo accessi. Il prototipo non è certificato, quindi la carta di attivazione, il sigillo fiscale, la firma e il supporto immodificabile sono simulati. Ogni requisito riceve uno stato secondo questi criteri:

- *Nel prototipo*: il requisito è realizzato e verificabile con un test.
- *Simulato*: il requisito è realizzato con una componente dichiarata simulata: carta, sigillo, firma, supporto, SPID o pagamento.
- *Desiderabile* e *Facoltativo*: priorità del piano di lavoro (D e F), realizzate solo se il tempo lo consente.
- *Da valutare*: il requisito dipende da un’informazione che non è ancora disponibile, come i layout dei tracciati.
- *Fuori perimetro*: il requisito resta documentato ma non entra nello stage. La motivazione è nella tabella del gruppo o nella sezione sulle lacune.

La tabella seguente collega gli obiettivi del piano di lavoro ai gruppi di requisiti e ai casi d’uso.

#table(
  columns: (2cm, 4.2cm, 3.5cm, 3.2cm),
  inset: 5pt,
  stroke: 0.5pt + rgb("b8b8bd"),
  fill: (_, row) => if calc.odd(row) { rgb("f5f5f7") } else { white },
  table.header([*Obiettivo*], [*Oggetto*], [*Gruppi*], [*Use case*]),
  [O02], [Modello dati, carta simulata, stato del sistema], [A, B, C], [UC1–UC3],
  [O03], [Emissione, annullo, log e chiusura giornaliera], [C, D, E], [UC4–UC6],
  [O04], [Riepiloghi e funzioni di servizio], [F, G], [UC7],
  [D01], [Vendita online white-label], [I], [UC8],
  [D02], [Nominatività, cambio nominativo, rimessa in vendita], [J], [UC9, UC10],
  [D03], [Render del titolo e stampa unica], [C11, L1, L2], [UC11],
  [D04], [Controllo accessi], [K], [UC12, UC13],
  [F02], [Mancato funzionamento], [H], [UC15],
  [F01], [Wallet pass], [Vincolo N], [UC14],
  [F03], [Integrazione con il CRM RelAi], [Nessun gruppo normativo], [UC16],
) <tab-obiettivi>

== Attori <attori>

Il sistema ha quattro attori esterni e un attore di supporto.

- *Operatore di back-office*: configura organizzatori, locali, eventi e prezzi, gestisce la carta simulata, emette e annulla titoli, chiude la giornata e consulta i riepiloghi.
- *Utente acquirente*: un utente identificato che acquista titoli dallo storefront di un organizzatore, cambia il nominativo o rimette in vendita un titolo.
- *Addetto al varco*: legge il codice del titolo all’ingresso e registra l’accesso.
- *CRM RelAi*: sistema esterno con cui il prototipo scambia organizzatori, eventi, vendite e presenze. Il collegamento è facoltativo (F03).
- *Carta di attivazione simulata*: attore di supporto che rappresenta la carta con PIN, contatori, progressivo e sigillo. Non è un utente, ma senza di essa il sistema non emette né annulla titoli (A1).

// FIGURA 1 (attori): non serve un diagramma dedicato. Gli attori compaiono nel diagramma generale qui sotto.

== Casi d’uso <casi-uso>

Il diagramma dei casi d’uso (_Use Case Diagram_) è un diagramma UML che descrive le funzioni offerte da un sistema così come le vedono gli attori che lo usano. Qui il diagramma serve a mostrare il perimetro complessivo prima di entrare nei dettagli di ciascuna area.

// FIGURA 2: diagramma generale dei casi d’uso, con i quattro attori e UC1–UC16 raggruppati per area
// (configurazione, fiscale, vendita online, controllo accessi, opzionali). Va in questa posizione,
// prima dei sottoparagrafi.

=== Configurazione: organizzatori, locali, eventi e prezzi <uc-configurazione>

Prima di emettere un titolo, il sistema deve conoscere l’organizzatore, il locale e l’evento. I prezzi e le tabelle di sistema sono configurati nella stessa fase.

// FIGURA 3: diagramma dei casi d’uso UC1–UC2 (solo operatore di back-office, con il sistema di carta come attore di supporto).

#usecase(1, [Configurazione dell’evento], [Operatore di back-office.], [L’operatore è autenticato e l’organizzatore è registrato.], [L’operatore crea un evento associato a un locale e a un organizzatore, con date e tipologie di titolo.], [L’evento è disponibile per la vendita e per il controllo accessi.]) <uc-configurazione-evento>

#usecase(2, [Gestione di locali e prezzi], [Operatore di back-office.], [Il locale ha un codice locale univoco, assegnato da SIAE.], [L’operatore definisce i locali e i listini, separando prevendita e prestazioni accessorie dal titolo principale.], [Listini e locali sono usati dalle operazioni di emissione.], alternative: [Se il codice locale è già in uso, il sistema rifiuta il salvataggio e segnala il conflitto.]) <uc-locali-prezzi>

=== Area fiscale: carta, emissione, annullo, log e riepiloghi <uc-fiscale>

Quest’area è il nucleo del prototipo. Ogni operazione richiede una carta valida e viene scritta nel log in modo serializzato.

// FIGURA 4: diagramma dei casi d’uso UC3–UC7 (operatore di back-office, con la carta simulata come attore di supporto).

#usecase(3, [Gestione della carta simulata], [Operatore di back-office, carta di attivazione simulata.], [È inserita una carta simulata con PIN corretto.], [Il sistema legge contatori, progressivo e sigillo simulati e porta lo stato a pronto. Con la carta assente o non valida tutte le funzioni restano bloccate.], [Lo stato del sistema riflette la carta presente.], alternative: [Se il sistema è in blocco per guasto, le operazioni fiscali restano sospese fino alla risoluzione.]) <uc-carta>

#usecase(4, [Emissione del titolo], [Operatore di back-office.], [La carta è valida e l’evento è configurato.], [L’operatore emette un titolo con i dati obbligatori dell’art. 3 del D.M. 13/7/2000. Sono gestiti i titoli gratuiti e ridotti con causale, gli abbonamenti a turno fisso e libero e i titoli open.], [Il titolo è registrato e il movimento è scritto nel log.], alternative: [Se un dato obbligatorio manca, l’emissione non viene completata.]) <uc-emissione>

#usecase(5, [Annullo del titolo], [Operatore di back-office.], [Il titolo esiste ed è stato emesso nel sistema.], [L’operatore annulla il titolo indicando una causale. Il sistema verifica i termini previsti e genera il record ANNULLATO con i dati del titolo originario.], [Il titolo risulta annullato e i due movimenti sono correlati nel log.], alternative: [Se il termine di annullo è scaduto, l’operazione viene rifiutata con il motivo.]) <uc-annullo>

#usecase(6, [Chiusura giornaliera e log], [Operatore di back-office.], [Sono presenti movimenti non ancora chiusi nella giornata fiscale.], [Il sistema genera i record del log in formato ASCII a campi fissi e XML, aggiorna la catena di impronte e chiude la giornata con firma simulata.], [La giornata è chiusa e il supporto simulato contiene il digest verificato.]) <uc-chiusura>

#usecase(7, [Riepiloghi e ricerca], [Operatore di back-office.], [Esistono movimenti registrati nel periodo richiesto.], [L’operatore consulta i riepiloghi giornalieri e mensili, cerca un titolo per carta e progressivo o per sigillo, e lo esporta. Le viste sono organizzate per giornata di emissione e per evento.], [I dati esportati corrispondono ai movimenti del log.]) <uc-riepiloghi>

=== Vendita online white-label <uc-vendita-online>

Lo storefront è un’unica applicazione, ma ogni organizzatore lo vede sul proprio dominio, con il proprio tema. Le regole di limite e di unicità valgono tra tutti i tenant.

// FIGURA 5: diagramma dei casi d’uso UC8–UC11 (utente acquirente, con SPID e pagamento simulati come attori di supporto).

#usecase(8, [Acquisto online], [Utente acquirente.], [Lo storefront dell’organizzatore è attivo e l’utente ha superato la registrazione con doppio riscontro.], [L’utente supera il CAPTCHA, compone il carrello, paga con un metodo tracciato simulato e riceve il titolo al termine della sessione. Il limite di dieci titoli per evento e utente vale tra tutti i tenant.], [Il titolo è emesso nel sistema e l’acquisto è tracciato.], alternative: [Se il limite di dieci titoli è raggiunto, il carrello viene bloccato prima del pagamento.]) <uc-acquisto>

#usecase(9, [Cambio nominativo], [Utente acquirente.], [Il titolo è nominativo ed è di proprietà dell’utente.], [L’utente indica il nuovo nome e cognome. Il sistema annulla il titolo originario e ne emette uno nuovo, in un’unica operazione correlata.], [Il titolo originario è annullato, quello nuovo è valido e i due movimenti sono collegati.]) <uc-cambio-nominativo>

#usecase(10, [Rimessa in vendita], [Utente acquirente.], [Il titolo è stato acquistato sul sito primario e non è ancora stato usato.], [L’utente rimette in vendita il titolo. Il titolo compare nella sezione del sito primario con le sole informazioni della vendita primaria, insieme a modalità, tempi e costi.], [Il titolo è disponibile per un nuovo acquirente, con annullo e nuova emissione correlati.]) <uc-rimessa>

#usecase(11, [Stampa del titolo a casa], [Utente acquirente.], [Il titolo è nominativo e la vendita è conclusa.], [L’utente stampa il render centrale del titolo, che riporta i dati minimi previsti. Il diritto di stampa viene consumato in modo atomico.], [Il diritto di stampa è esaurito: una seconda stampa non è possibile.], alternative: [Se due richieste di stampa arrivano insieme, una sola viene accettata.]) <uc-stampa>

// FIGURA 6: diagramma dei casi d’uso UC12–UC13 (addetto al varco e operatore).

=== Controllo accessi <uc-accessi>

Il varco lavora su una lista unica per evento. Un titolo già usato non può essere riutilizzato, e la lista si aggiorna in tempo reale dopo annullo, cambio nominativo o rimessa in vendita.

#usecase(12, [Controllo accesso al varco], [Addetto al varco.], [L’evento è attivo e la lista dei titoli validi è caricata.], [L’addetto legge il codice del titolo. Il sistema registra l’accesso e blocca ogni lettura successiva dello stesso titolo.], [L’accesso è registrato e il titolo non è più utilizzabile.], alternative: [Se il titolo non è nella lista, il varco mostra un esito negativo senza registrare l’accesso.]) <uc-varco>

#usecase(13, [Invalidazione manuale], [Operatore di back-office.], [Il titolo esiste nella lista dell’evento.], [L’operatore invalida un titolo, per esempio in caso di smarrimento o frode. Il titolo esce dalla lista valida.], [Il titolo non può più essere usato al varco.]) <uc-invalidazione>

=== Funzioni facoltative <uc-opzionali>

Le funzioni che seguono sono previste dal piano solo se il tempo lo consente. Compaiono qui per fissare i confini del prototipo.

// FIGURA 7: diagramma dei casi d’uso UC14–UC16, da inserire solo se le attività facoltative entrano nel perimetro finale.

#usecase(14, [Emissione del wallet pass], [Utente acquirente, Operatore di back-office.], [Il titolo è valido e il titolare ha chiesto il pass.], [Il sistema genera un pass per Apple Wallet o Google Wallet con una credenziale opaca, priva di dati personali. Il pass viene aggiornato o revocato dopo annullo, cambio nominativo o rimessa in vendita.], [Il pass riflette lo stato del titolo.]) <uc-wallet>

#usecase(15, [Gestione del mancato funzionamento], [Operatore di back-office.], [Il sistema è in funzione.], [L’operatore blocca il sistema e apre una voce nel registro dei guasti, con inizio e fine. Durante il blocco si registrano i biglietti manuali per evento e tipologia. Il contatore dei giorni di fermo genera un allarme al trentesimo giorno dell’anno solare.], [Il guasto è registrato e il contatore è aggiornato.]) <uc-guasto>

#usecase(16, [Sincronizzazione con il CRM RelAi], [CRM RelAi, Operatore di back-office.], [Il collegamento con il CRM è configurato.], [Il sistema riceve organizzatori ed eventi dal CRM e restituisce i dati di vendita e di presenza, così che i pannelli di RelAi riflettano i titoli emessi e gli accessi registrati.], [I dati nel CRM sono allineati con il prototipo.]) <uc-crm>

== Requisiti per gruppo <requisiti>

Le tabelle seguono l’ordine della checklist. Ogni riga riporta il codice, una sintesi del requisito, lo stato e il caso d’uso che lo realizza. Il testo completo di ogni requisito resta nel documento aziendale.

=== Gruppo A: vincoli architetturali <gruppo-a>

#status-table((
  ([A1], [Il sistema non funziona senza la carta di attivazione: anagrafiche, emissione, log e riepiloghi sono bloccati], [Simulato], [UC3]),
  ([A2], [PIN richiesto all’accensione e a ogni rimozione della carta], [Simulato], [UC3]),
  ([A3], [Prima attivazione: memorizzazione di titolare, codice sistema e codice carta, controllo della firma, visualizzazione dei contatori], [Simulato], [UC3]),
  ([A4], [Nessuna funzione, palese o nascosta, aggira la carta o modifica log e titoli al di fuori del percorso previsto], [Nel prototipo], [Tutti]),
  ([A5], [Software fiscale, log e carte su componenti in Italia, in locali dichiarati, con custodi nominati], [Fuori perimetro], [–]),
  ([A6], [Associazione univoca tra carta e sistema; i movimenti sigillati da una carta si registrano nel sistema che la ospita], [Simulato], [UC3]),
), caption: [Requisiti del gruppo A.]) <tab-gruppo-a>

=== Gruppo B: anagrafiche e configurazione <gruppo-b>

#status-table((
  ([B1], [Gestione di eventi, locali, organizzatori, tabelle di sistema e tabella dei prezzi], [Nel prototipo], [UC1, UC2]),
  ([B2], [Più organizzatori ed eventi in parallelo, anche per manifestazioni che attraversano la mezzanotte], [Nel prototipo], [UC1]),
  ([B3], [Codice locale assegnato da SIAE: acquisito e usato, non generato], [Nel prototipo], [UC2]),
  ([B4], [Comunicazione a SIAE degli organizzatori serviti, prima dell’inizio del servizio (§1.7.5 Allegato A del Provv. 2002)], [Fuori perimetro], [–]),
), caption: [Requisiti del gruppo B. B4 non compare nel piano di lavoro: la sua esclusione va confermata con il tutor.]) <tab-gruppo-b>

=== Gruppo C: emissione del titolo <gruppo-c>

#status-table((
  ([C1], [Emissione completa quando il titolo è definito e registrato nel log, anche se non è stato stampato], [Nel prototipo], [UC4]),
  ([C2], [Dati obbligatori dell’art. 3 del D.M. 2000: natura, data e ora, luogo, posto, corrispettivo, gratuità o riduzione con causale, prevendita e prestazioni accessorie separate, sigillo], [Nel prototipo], [UC4]),
  ([C3], [Diciture per la vendita per conto di terzi e per la vendita da parte dell’organizzatore], [Nel prototipo], [UC4]),
  ([C4], [Abbonamenti con dicitura, numero di prestazioni, turno libero e ratei per turno fisso], [Nel prototipo], [UC4]),
  ([C5], [Titoli open registrati come abbonamenti con codice proprio, un evento abilitato e turno libero], [Nel prototipo], [UC4]),
  ([C6], [Gratuità e riduzioni evidenziate per la lettura immediata], [Nel prototipo], [UC4]),
  ([C7], [Sigillo di 16 caratteri calcolato dalla carta su codice carta, data, ora, importo e progressivo], [Simulato], [UC4]),
  ([C8], [Il numero della carta sostituisce il logotipo fiscale sul titolo], [Nel prototipo], [UC4]),
  ([C9], [Incremento dei contatori a bordo della carta a ogni emissione], [Simulato], [UC3, UC4]),
  ([C10], [Registrazione in banca dati, memorie temporanee e log, corretta anche sotto carico], [Nel prototipo], [UC4]),
  ([C11], [Una sola stampa per titolo: ristampa e stampa multipla inibite, diritto consumato lato server], [Nel prototipo], [UC11]),
  ([C12], [Titoli nominativi con nome e cognome, senza altri dati personali nella lista unica], [Nel prototipo], [UC4, UC12]),
  ([C13], [Importi in euro con due cifre decimali, coerenti con il tracciato], [Nel prototipo], [UC4]),
), caption: [Requisiti del gruppo C.]) <tab-gruppo-c>

=== Gruppo D: annullamento <gruppo-d>

#status-table((
  ([D1], [Annullo con causale entro il quinto giorno lavorativo successivo all’evento], [Nel prototipo], [UC5]),
  ([D2], [Titoli digitali annullabili fino all’inizio dell’evento], [Nel prototipo], [UC5]),
  ([D3], [Evento non effettuato: annullo entro i termini di versamento delle imposte], [Nel prototipo], [UC5]),
  ([D4], [Annulli e rimborsi di titoli digitali solo con pagamenti tracciabili], [Simulato], [UC5, UC8]),
  ([D5], [Annullo con record ANNULLATO completo dei dati del titolo originario, identificato da progressivo e sigillo], [Nel prototipo], [UC5]),
  ([D6], [Conservazione del titolo annullato, anche in forma informatica], [Nel prototipo], [UC5]),
), caption: [Requisiti del gruppo D.]) <tab-gruppo-d>

=== Gruppo E: log delle transazioni <gruppo-e>

#status-table((
  ([E1], [Log con tutti i movimenti: emissioni, annullamenti e abbonamenti], [Nel prototipo], [UC6]),
  ([E2], [Formato ASCII a campi fissi o XML; XML obbligatorio per i flussi dei Capi II e III del Provv. 2019], [Da valutare], [UC6]),
  ([E3], [Registrazione su supporto immodificabile], [Simulato], [UC6]),
  ([E4], [Certificato a inizio registrazione e firma digitale a fine giornata con chiave a bordo della carta], [Simulato], [UC6]),
  ([E5], [Conservazione per 24 mesi dall’ultimo titolo, con funzioni di verifica e copia per il controllo], [Nel prototipo], [UC6]),
), caption: [Requisiti del gruppo E.]) <tab-gruppo-e>

=== Gruppo F: riepiloghi e trasmissione <gruppo-f>

#status-table((
  ([F1], [Riepilogo giornaliero: proventi per evento e ordine di posto, abbonamenti per organizzatore, ingressi per tipologia, sigillo], [Nel prototipo], [UC6, UC7]),
  ([F2], [Riepilogo mensile dei titoli: proventi per evento anche se incassati nei mesi precedenti, ratei per turno fisso], [Nel prototipo], [UC7]),
  ([F3], [Riepilogo mensile degli altri proventi (record 8 e 9), se la funzione è dichiarata], [Da valutare], [UC7]),
  ([F4], [Tracciati FLAT e XML, firma digitale, crittografia, codice di autenticazione, sequenza corretta dei record], [Simulato], [UC6, UC7]),
  ([F5], [Termini di trasmissione a SIAE per riepiloghi mensili e per evento], [Fuori perimetro], [–]),
  ([F6], [Stampa cartacea su A3 o A4 secondo i modelli C.1 e C.2], [Fuori perimetro], [–]),
  ([F7], [Gestione e comunicazione dei periodi di inattività], [Nel prototipo], [UC7]),
), caption: [Requisiti del gruppo F. La trasmissione telematica non è nel piano di lavoro: la generazione dei record è coperta, l’invio no.]) <tab-gruppo-f>

=== Gruppo G: funzioni di servizio e conservazione <gruppo-g>

#status-table((
  ([G1], [Consultazione a video e su carta, o esportazione, di dettagli e riepiloghi aggiornati], [Nel prototipo], [UC7]),
  ([G2], [Ricerca per numero di carta e progressivo, o per sigillo], [Nel prototipo], [UC7]),
  ([G3], [Viste per giornata di emissione e per evento, con ordine di posto e tipologia], [Nel prototipo], [UC7]),
  ([G4], [Cancellazione dei titoli consentita solo dopo 60 giorni dall’evento], [Nel prototipo], [UC7]),
  ([G5], [Cancellazione dei riepiloghi consentita solo dopo due anni dalla trasmissione], [Da valutare], [UC7]),
), caption: [Requisiti del gruppo G.]) <tab-gruppo-g>

=== Gruppo H: mancato funzionamento <gruppo-h>

#status-table((
  ([H1], [Blocco immediato, richiesta di manutenzione, annotazione sul libretto fiscale], [Facoltativo (F02)], [UC15]),
  ([H2], [Registro di inizio e fine del guasto, totale dei biglietti manuali per evento e tipologia], [Facoltativo (F02)], [UC15]),
  ([H3], [Contatore dei giorni di fermo con allarme al trentesimo giorno per anno solare], [Facoltativo (F02)], [UC15]),
), caption: [Requisiti del gruppo H.]) <tab-gruppo-h>

=== Gruppo I: vendita online <gruppo-i>

#status-table((
  ([I1], [CAPTCHA prima della composizione del carrello], [Nel prototipo], [UC8]),
  ([I2], [Acquisto concluso solo da utente identificato], [Nel prototipo], [UC8]),
  ([I3], [Registrazione con dati anagrafici, email, cellulare e mezzo per il riscontro; cellulare associato a un solo utente nel sistema], [Nel prototipo], [UC8]),
  ([I4], [SPID come alternativa alla registrazione], [Simulato], [UC8]),
  ([I5], [Massimo dieci titoli per evento e utente, valido a livello di sistema su tutti i front-end], [Nel prototipo], [UC8]),
  ([I6], [Titolo non rilasciato a fine sessione, ma inviato con il mezzo scelto], [Nel prototipo], [UC8]),
  ([I7], [Tracciamento delle operazioni dell’utente identificato], [Nel prototipo], [UC8]),
  ([I8], [Connessione HTTPS con almeno TLS 1.2], [Da valutare], [–]),
  ([I9], [Deroga per eventi con vendita online fino a 1.000 titoli: bastano il CAPTCHA e le misure di sicurezza], [Da valutare], [UC8]),
), caption: [Requisiti del gruppo I.]) <tab-gruppo-i>

=== Gruppo J: nominatività, cambio e rimessa in vendita <gruppo-j>

#status-table((
  ([J1], [Titoli nominativi per impianti con capienza superiore a 5.000 posti, con esclusioni per tipologia di spettacolo], [Da valutare], [UC8, UC9]),
  ([J2], [Accesso subordinato al riconoscimento personale: il titolo non vale per l’ingresso se il fruitore non coincide con il nominativo], [Nel prototipo], [UC12]),
  ([J3], [Cambio nominativo con annullo, nuovo titolo nominativo e correlazione tracciata], [Nel prototipo], [UC9]),
  ([J4], [Rimessa in vendita con le sole informazioni della vendita primaria, nella sezione del sito primario], [Nel prototipo], [UC10]),
  ([J5], [Informativa chiara su modalità, tempi e costi delle due operazioni], [Nel prototipo], [UC9, UC10]),
), caption: [Requisiti del gruppo J.]) <tab-gruppo-j>

=== Gruppo K: controllo accessi <gruppo-k>

#status-table((
  ([K1], [Lista unica dei titoli validi per evento, anche emessi da più sistemi], [Desiderabile (D04)], [UC12]),
  ([K2], [Registrazione in tempo reale di ogni accesso], [Desiderabile (D04)], [UC12]),
  ([K3], [Inibizione del riutilizzo dello stesso titolo], [Desiderabile (D04)], [UC12]),
  ([K4], [Nella lista unica solo nome e cognome degli intestatari], [Desiderabile (D04)], [UC12]),
  ([K5], [Il varco è componente del sistema certificato: va descritto nell’istanza e verificato in certificazione], [Fuori perimetro], [UC12]),
), caption: [Requisiti del gruppo K.]) <tab-gruppo-k>

=== Gruppo L: output e supporti <gruppo-l>

#status-table((
  ([L1], [Sul titolo stampato: numero di carta, progressivo, prezzo, data e ora di emissione, sigillo e nome dell’intestatario, se nominativo], [Nel prototipo], [UC11]),
  ([L2], [Render del titolo generato centralmente; stampanti come terminali senza capacità di elaborazione], [Nel prototipo], [UC11]),
  ([L3], [Nessun modello di stampante prescritto], [Fuori perimetro], [–]),
), caption: [Requisiti del gruppo L.]) <tab-gruppo-l>

== Vincoli e lacune <lacune>

Alcuni punti limitano il prototipo e vanno dichiarati nella relazione finale.

+ *Layout dei tracciati.* I campi degli Allegati A, B e C del Provv. 23 luglio 2001 sono pubblicati come immagini, quindi il testo non si può estrarre. Il recupero passa dalla Gazzetta Ufficiale n. 212 del 12 settembre 2001 o da una richiesta a SIAE. Senza questi layout i requisiti E2, F3 e G5 restano da valutare.
+ *Specifiche della carta.* Le modalità di interazione con la carta sono fornite da SIAE su richiesta (Provv. 2001, §3.2). Senza di esse non si calcola il sigillo reale né si firmano i riepiloghi: nel prototipo queste operazioni sono simulate.
+ *Codice locale e trasmissione.* Il codice locale per ogni impianto e le modalità di trasmissione telematica vanno richiesti a SIAE. Queste informazioni vanno dichiarate già nella domanda di carta di attivazione.
+ *Varianti dopo l’istanza.* Ogni variante che incide sul funzionamento fiscale richiede un’autorizzazione preventiva. Wallet pass, controllo accessi e canali di vendita vanno quindi inclusi nella prima istanza. Se restano fuori dalla domanda, il prototipo può mostrarli ma non può presentarli come conformi.
+ *Termini dell’istanza.* L’istanza completa va presentata circa cinque settimane prima di una seduta della Commissione e in ogni caso almeno sessanta giorni prima dell’avvio in esercizio. Un esemplare del sistema deve restare disponibile all’Agenzia per i controlli.
*/