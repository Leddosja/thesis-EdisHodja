#import "shared.typ": *

#let status-table(rows, caption: none) = {
  let body = table(
    columns: (2cm, 7cm, 3cm, 3cm),
    inset: 6pt,
    stroke: 0.5pt + rgb("b8b8bd"),
    fill: (_, row) => if calc.odd(row) { rgb("f5f5f7") } else { white },
    table.header([*ID*], [*Requisito*], [*Stato*], [*Use Case*]),
    ..rows.flatten(),
  )
  if caption != none {
    figure(body, caption: caption, kind: table, supplement: [Tabella])
  } else {
    body
  }
}

#pagebreak()

= Analisi dei requisiti <analisi-requisiti>

Questo capitolo raccoglie i requisiti del prototipo e li collega ai casi d’uso che li realizzano. La fonte principale è il documento di requisiti costruito dall’azienda a partire dalla normativa, organizzato in gruppi tematici (A-N).

== Fonti normative e perimetro <fonti-perimetro>

Il riferimento normativo è il D.M. 13 luglio 2000, con i provvedimenti dell’Agenzia delle Entrate del 23 luglio 2001, del 22 ottobre 2002, del 4 marzo 2008, n. 223774 del 2019 e n. 356768 del 2025. Si aggiunge la checklist dell’Agenzia del 2 dicembre 2002 per la certificazione dei sistemi di emissione.

Il perimetro è il sistema di emissione dei titoli di accesso previsto dall’art. 2, comma 1, lettera b), del D.M. 2000, con vendita online e controllo accessi. Il prototipo non è certificato, quindi la carta di attivazione, il sigillo fiscale, la firma e il supporto immodificabile sono simulati. Ogni requisito riceve uno stato secondo questi criteri:

- *Nel prototipo*: il requisito è realizzato e verificabile con un test.
- *Desiderabile* e *Facoltativo*: priorità del piano di lavoro (D e F).
- *Fuori perimetro*: il requisito resta documentato ma non entra nel perimetro dello stage.

La tabella seguente collega gli obiettivi ai gruppi di requisiti e ai casi d’uso.

#figure(table(
  columns: (2.5cm, 6.5cm, 3.5cm, 3cm),
  inset: 7pt,
  stroke: 0.5pt + rgb("b8b8bd"),
  fill: (_, row) => if calc.odd(row) { rgb("f5f5f7") } else { white },
  table.header([*Obiettivo*], [*Oggetto*], [*Gruppi*], [*Use case*]),
  [O01], [Analisi e matrice dei requisiti normativi], [Nessun gruppo normativo], [-],
  [O02], [Modello dati, carta simulata, stato del sistema], [A, B, C], [UC1–UC3],
  [O03], [Emissione, annullo, log e chiusura giornaliera], [C, D, E], [UC4–UC6],
  [O04], [Riepiloghi e funzioni di servizio], [F, G], [UC7],
  [O05], [Test funzionali e relazione finale], [Nessun gruppo normativo], [-],
  [D01], [Vendita online white-label], [I], [UC9],
  [D02], [Nominatività, cambio nominativo, rimessa in vendita], [J], [UC10, UC11],
  [D03], [Render del titolo e stampa unica], [C11, L1, L2], [UC9],
  [D04], [Controllo accessi], [K], [UC12, UC13],
  [F01], [Wallet pass], [Vincolo N], [UC14],
  [F02], [Mancato funzionamento], [H], [UC8],
  [F03], [Integrazione con il CRM RelAi], [Nessun gruppo normativo], [-],
), caption: [Obiettivi collegati a gruppi di requisiti e casi d’uso.], kind: table, supplement: [Tabella]) <tab-obiettivi>

== Attori <attori>

Un attore è una persona o un sistema esterno che interagisce con il sistema. Ciò che il progetto può controllare e realizzare fa parte del sistema e non è un attore. Per questo la carta di attivazione, il pagamento e lo SPID, che il prototipo simula internamente, non sono attori: compaiono nelle precondizioni e nelle descrizioni, e le loro interfacce restano compatibili con una futura sostituzione con i componenti reali. #v(0.3cm)

*Attori principali*

- *Operatore di back-office*: la persona dell’organizzatore o dell’azienda che usa il sistema da dietro le quinte. Configura organizzatori, locali, eventi e prezzi, gestisce la carta simulata, emette e annulla titoli, chiude la giornata e consulta i riepiloghi.
- *Cliente*: la persona che compra un biglietto sullo storefront online. All’inizio è solo un visitatore e può soltanto registrarsi o accedere con SPID simulato; da quel momento è lo stesso attore, ora identificato, e può acquistare, cambiare il nominativo di un titolo, rimetterlo in vendita e stamparlo. Non è diviso in due attori distinti: l’unica differenza è se ha già completato l’identificazione, ed è questa la precondizione che distingue i casi d’uso riservati all’acquisto da quelli aperti a chiunque visiti lo storefront.
- *Addetto al varco*: la persona all’ingresso dell’evento che legge il codice del titolo e fa passare il cliente.

#pagebreak()
== Casi d’uso <casi-uso>

Il diagramma dei casi d’uso (_Use Case Diagram_) è un diagramma UML che descrive le funzioni offerte da un sistema così come le vedono gli attori che lo usano. Ogni caso d’uso ha un identificativo, e quelli di dettaglio lo estendono in modo gerarchico.

#show heading.where(level: 3): it => text(size: 0.5cm, weight: "bold")[
  #if it.numbering != none [#counter(heading).display(it.numbering) ]#it.body
]
#show heading.where(level: 4): it => text(size: 0.5cm, weight: "bold")[
  #if it.numbering != none [#counter(heading).display(it.numbering) ]#it.body
]

#usecase(1, [Inserimento dell’evento], [Operatore],
  [L’operatore è autenticato, la carta simulata è valida e il sistema è pronto. L’organizzatore è registrato e il locale è già definito.],
  [
    + L’operatore apre la creazione di un nuovo evento.
    + Sceglie l’organizzatore e il locale, già registrati nel sistema.
    + Indica date e orari dell’evento, anche a cavallo di mezzanotte, e le tipologie di titolo previste.
    + Conferma: l’evento è salvato e resta disponibile insieme a quelli degli altri organizzatori già attivi nello stesso periodo.
  ],
  [L’evento è disponibile per l’emissione (#link(<uc-emissione>)[UC-4]), per la vendita online (#link(<uc-acquisto>)[UC-9]) e per il controllo accessi (#link(<uc-varco>)[UC-12]).],
  alternative: [Se il locale o l’organizzatore non esistono, il sistema rifiuta il salvataggio e indica il motivo (#link(<uc-configurazione-evento-locale>)[UC-1.1]). Se le date sono incoerenti, il sistema rifiuta il salvataggio e segnala l’incongruenza (#link(<uc-configurazione-evento-date>)[UC-1.2]).],
  diagram: "../../img/diagrams/uc-1.png") <uc-configurazione-evento>

#usecase("1.1", [Validazione locale e organizzatore fallita], [Operatore],
  [Il sistema sta eseguendo la configurazione dell’evento e l’operatore ha indicato un locale o un organizzatore non registrato.],
  [Il sistema rifiuta il salvataggio e indica quale dei due dati non è stato trovato.],
  [Nessun evento viene creato. L’operatore può correggere il dato o registrarlo.]) <uc-configurazione-evento-locale>

#usecase("1.2", [Validazione date evento fallita], [Operatore],
  [Il sistema sta eseguendo la configurazione dell’evento e l’operatore ha indicato date non coerenti, per esempio una data e ora di fine precedente a quella di inizio.],
  [Il sistema rifiuta il salvataggio e segnala l’incongruenza.],
  [Nessun evento viene creato. L’operatore può correggere le date e ripetere la configurazione.]) <uc-configurazione-evento-date>

#pagebreak()
#usecase(2, [Configurazione delle anagrafiche], [Operatore],
  [L’operatore è autenticato, la carta simulata è valida e il sistema è pronto. L’operatore dispone del codice locale assegnato da SIAE.],
  [
    + L’operatore registra un nuovo organizzatore, cliente dell’azienda che venderà titoli sul proprio dominio white-label.
    + Per ogni locale usato dall’organizzatore, inserisce il codice locale assegnato da SIAE.
    + Definisce il listino dell’evento, tenendo separati il prezzo del titolo, la prevendita e le eventuali prestazioni accessorie.
    + Conferma e salva i dati che sono pronti per essere usati in un evento.
  ],
  [Organizzatori, locali e listini sono disponibili per la configurazione degli eventi (#link(<uc-configurazione-evento>)[UC-1]), per l’emissione (#link(<uc-emissione>)[UC-4]) e per la vendita online (#link(<uc-acquisto>)[UC-9]).],
  alternative: [Se il codice locale è già in uso, il sistema rifiuta il salvataggio e segnala il conflitto (#link(<uc-locali-prezzi-codice>)[UC-2.1]).],
  diagram: "../../img/diagrams/uc-2.png") <uc-locali-prezzi> 

#pagebreak()
#usecase("2.1", [Codice locale non valido], [Operatore],
  [Il sistema sta eseguendo la gestione di organizzatori, locali e prezzi e l’operatore ha indicato un codice locale già assegnato a un altro locale.],
  [Il sistema rifiuta il salvataggio e segnala il conflitto, indicando il locale che usa già quel codice.],
  [Nessun locale viene creato o modificato. L’operatore può correggere il codice e ripetere l’operazione.]) <uc-locali-prezzi-codice>

#usecase(3, [Inizializzazione della carta simulata], [Operatore],
  [La carta simulata è inserita nel sistema e l’operatore conosce il PIN.],
  [
    + Il sistema si accende, o la carta viene rimossa e reinserita: in entrambi i casi chiede il PIN.
    + L’operatore inserisce il PIN.
    + Se è la prima attivazione della carta, il sistema registra titolare, codice sistema e codice carta, e controlla la firma.
    + Il sistema legge contatori, progressivo e sigillo simulati sulla carta, verifica che sia associata a questo sistema e mostra i contatori a schermo.
    + Lo stato passa a pronto: tutte le funzioni che richiedono la carta diventano utilizzabili.
  ],
  [Lo stato del sistema riflette la carta presente.],
  alternative: [Se il PIN è errato, il sistema resta bloccato (#link(<uc-carta-pin>)[UC-3.1]). Se la carta è assente o non è associata a questo sistema, il sistema resta bloccato (#link(<uc-carta-assente>)[UC-3.2]).], diagram: "../../img/diagrams/uc-3.png") <uc-carta>

#usecase("3.1", [Inserimento PIN non valido], [Operatore],
  [Il sistema sta eseguendo la gestione della carta simulata e l’operatore ha inserito un PIN non corretto.],
  [Il sistema rifiuta il PIN, segnala l’errore e non legge i dati della carta.],
  [Lo stato del sistema resta bloccato.]) <uc-carta-pin>

#usecase("3.2", [Verifica carta fallita], [Operatore],
  [Il sistema sta eseguendo la gestione della carta simulata e la carta è assente, non valida o associata ad un altro sistema.],
  [Il sistema rileva l’anomalia e segnala il motivo. Un movimento sigillato da una carta si registra solo nel sistema che la ospita.],
  [Lo stato del sistema resta bloccato e nessuna funzione di anagrafica, emissione, annullo, log e riepilogo è utilizzabile.]) <uc-carta-assente>

#pagebreak()
#usecase(4, [Emissione del titolo], [Operatore],
  [La carta simulata è valida, il sistema è pronto e l’evento è configurato.],
  [
    + L’operatore sceglie l’evento, l’ordine di posto e la tipologia di titolo (intero, ridotto o gratuito con causale).
    + Il sistema emette il titolo al momento del pagamento, salvo i casi in cui la norma ammette un’emissione anticipata, e vi scrive tutti i dati obbligatori previsti.
    + La carta simulata calcola il sigillo del titolo e incrementa i propri contatori.
    + Il titolo viene registrato con il proprio progressivo e importo in euro, con due cifre decimali stando allo standard richiesto dalla normativa.
  ],
  [Il titolo è registrato con progressivo e sigillo e il movimento è scritto nel log, anche se il titolo non è stato stampato. Il titolo può essere annullato (#link(<uc-annullo>)[UC-5]) e rientra nella chiusura giornaliera (#link(<uc-chiusura>)[UC-6]).],
  alternative: [Se un dato obbligatorio manca, l’emissione non viene completata (#link(<uc-emissione-dato>)[UC-4.1]).], diagram: "../../img/diagrams/uc-4.png") <uc-emissione>

#pagebreak()
#usecase("4.1", [Dati del titolo incompleti], [Operatore],
  [L'operatore sta eseguendo l’emissione del titolo e non ha indicato uno dei dati obbligatori previsti.],
  [Il sistema rifiuta l’emissione e indica quale dato manca.],
  [Nessun titolo viene registrato, nessun movimento viene scritto nel log e i contatori della carta non avanzano. L’operatore può completare i dati e ripetere l’emissione.]) <uc-emissione-dato>

#usecase(5, [Annullamento del titolo], [Operatore],
  [La carta simulata è valida e il sistema è pronto. Il titolo esiste ed è stato emesso nel sistema e compare all'interno della tabella.],
  [
    + L’operatore seleziona il titolo da annullare e indica la causale dell’annullo, scelta tra i dieci codici della tabella specificata dalla normativa.
    + Il sistema verifica che il termine previsto per quella causale non sia scaduto.
    + Genera un nuovo record ANNULLATO, con il proprio progressivo e sigillo, che riporta i dati del titolo originario.
  ],
  [Il titolo risulta annullato e viene conservato. I due movimenti sono correlati nel log e rientrano nella chiusura giornaliera (#link(<uc-chiusura>)[UC-6]). La lista di ingresso si aggiorna (#link(<uc-varco>)[UC-12]) e il wallet pass viene revocato (#link(<uc-wallet>)[UC-14]).],
  alternative: [Se il termine di annullo è scaduto (#link(<uc-annullo-termine>)[UC-5.1]) o il titolo è già annullato (#link(<uc-annullo-gia>)[UC-5.2]), l’operazione viene rifiutata.],
  diagram: "../../img/diagrams/uc-5.png") <uc-annullo>

#usecase("5.1", [Annullamento fuori termine], [Operatore],
  [L'operatore sta eseguendo l’annullo del titolo e il termine previsto per la causale indicata è scaduto.],
  [Il sistema rifiuta l’annullo e indica il termine non rispettato.],
  [Il titolo resta valido, nessun record ANNULLATO viene creato e nessun movimento viene scritto nel log.]) <uc-annullo-termine>

#usecase("5.2", [Titolo non annullabile], [Operatore],
  [L'operatore sta eseguendo l’annullo del titolo e il titolo risulta già annullato.],
  [Il sistema rifiuta l’operazione e segnala che il titolo è già annullato.],
  [Nessun nuovo record ANNULLATO viene creato e il log non cambia.]) <uc-annullo-gia>

#pagebreak()
#usecase(6, [Generazione del log giornaliero], [Operatore],
  [La carta simulata è valida e il sistema è pronto. Sono presenti movimenti non ancora chiusi nella giornata fiscale, prodotti da emissioni e annulli.],
  [
    + L’operatore avvia la chiusura della giornata fiscale, a fine servizio.
    + Il sistema genera i record del log del giorno, nei due formati (ASCII a campi fissi e XML), e aggiorna la catena di impronte che li collega.
    + Firma digitalmente la giornata con la chiave della carta simulata e scrive il risultato su un supporto simulato non riscrivibile.
    + Produce il riepilogo giornaliero e lo rende disponibile insieme al log, conservato per i successivi 24 mesi.
  ],
  [La giornata è chiusa, il supporto simulato contiene il digest verificato e i movimenti chiusi sono consultabili tramite i riepiloghi giornalieri.],
  alternative: [Se la verifica del digest sul supporto simulato fallisce, la giornata non risulta chiusa (#link(<uc-chiusura-digest>)[UC-6.1]). Se non ci sono movimenti da chiudere, il sistema non genera alcun record (#link(<uc-chiusura-vuota>)[UC-6.2]).],
  diagram: "../../img/diagrams/uc-6.png") <uc-chiusura>

#pagebreak()
#usecase("6.1", [Digest non corrispondente], [Operatore],
  [L'operatore sta eseguendo la chiusura giornaliera e il digest letto dal supporto simulato non coincide con quello calcolato.],
  [Il sistema interrompe la chiusura e segnala l’errore di verifica.],
  [La giornata non risulta chiusa e i movimenti registrati restano invariati.]) <uc-chiusura-digest>

#usecase("6.2", [Giornata senza movimenti], [Operatore],
  [Il sistema sta eseguendo la chiusura giornaliera e nella giornata fiscale non risultano movimenti non ancora chiusi.],
  [Il sistema non genera alcun record e segnala che non ci sono movimenti da chiudere.],
  [Nessuna firma viene calcolata e il log non cambia.]) <uc-chiusura-vuota>

#pagebreak()
#usecase(7, [Consultazione dei riepiloghi], [Operatore],
  [La carta simulata è valida e il sistema è pronto. Esistono movimenti registrati nel periodo richiesto e le relative giornate sono state chiuse (#link(<uc-chiusura>)[UC-6]).],
  [
    + L’operatore apre i riepiloghi giornalieri o mensili, oppure cerca un titolo specifico per numero di carta e progressivo, oppure per sigillo.
    + Può anche filtrare per giorno, evento, ordine di posto o tipologia, con viste organizzate per giornata di emissione e per evento.
    + Il sistema restituisce a video i risultati, incluso il riepilogo mensile con i corrispettivi di ogni evento anche se incassati in mesi precedenti, e l’operatore può esportarli.
    + Il dettaglio dei singoli titoli resta consultabile fino al sessantesimo giorno dopo l’evento.
  ],
  [I dati esportati corrispondono ai movimenti del log.],
  alternative: [Se nel periodo richiesto non esistono movimenti, il sistema mostra un risultato vuoto (#link(<uc-riepiloghi-vuoto>)[UC-7.1]).],
  diagram: "../../img/diagrams/uc-7.png") <uc-riepiloghi>

#pagebreak()
#usecase("7.1", [Ricerca senza risultati], [Operatore],
  [L'operatore sta consultando i riepiloghi e seleziona il periodo senza alcun movimento.],
  [Il sistema segnala che non ci sono dati e non produce alcun riepilogo o file di esportazione.],
  [Il log non cambia e l’operatore può modificare periodo e ripetere la richiesta.]) <uc-riepiloghi-vuoto>

#usecase(8, [Registrazione del periodo di inattività], [Operatore],
  [Il sistema è in funzione (#link(<uc-carta>)[UC-3]).],
  [
    + L’operatore registra l'intervallo di tempo del periodo di inattività durante il quale no verranno inviati i riepiloghi alla SIAE.
    + Apre una voce nel registro delle trasmissioni, con data.
    + Durante il blocco, registra i biglietti venduti manualmente, per evento e tipologia.
  ],
  [Il periodo di inattività è registrato e il contatore dei giorni di fermo è aggiornato.], diagram: "../../img/diagrams/uc-8.png") <uc-guasto>

#usecase(9, [Acquisto dei titoli online], [Cliente],
  [Lo storefront dell’organizzatore è attivo e il sistema è pronto. L’evento è configurato e i listini sono definiti. Il cliente si è già identificato, con la registrazione a doppio riscontro o con l’accesso SPID.],
  [
    + Il cliente supera il CAPTCHA e compone il carrello, scegliendo evento, ordine di posto e quantità, fino al limite di dieci titoli per evento, rispettato a livello di sistema anche tra organizzatori diversi.
    + Paga con un metodo tracciabile, simulato nel prototipo.
    + Al pagamento andato a buon fine, il sistema emette i titoli.
    + I titoli vengono consegnati solo dopo la chiusura della sessione di acquisto.
  ],
  [I titoli sono emessi e registrati nel log, l’acquisto è tracciato e i titoli sono inviati al cliente dopo la chiusura della sessione, pronti per essere stampati dall’area personale.],
  alternative: [Se il limite di dieci titoli è raggiunto, il carrello viene bloccato prima del pagamento (#link(<uc-acquisto-limite>)[UC-9.3]). Se il pagamento non va a buon fine, nessun titolo viene emesso (#link(<uc-acquisto-pagamento>)[UC-9.4]). Se il CAPTCHA non è superato, il cliente non può comporre il carrello (#link(<uc-acquisto-captcha>)[UC-9.5]).],
  diagram: "../../img/diagrams/uc-9.png") <uc-acquisto>

#usecase("9.1", [Creazione dell’account cliente], [Cliente],
  [Lo storefront dell’organizzatore è attivo e il cliente non si è ancora identificato.],
  [
    + Il cliente compila i propri dati anagrafici, l’indirizzo email, il numero di cellulare e il mezzo scelto per ricevere il codice di conferma.
    + Il sistema invia un codice OTP simulato.
    + Il cliente lo inserisce per confermare la registrazione e il sistema verifica che il cellulare non sia già associato ad un altro cliente.
  ],
  [Il cliente è identificato e può procedere all’acquisto.],
  alternative: [Se il cellulare è già associato a un altro cliente, la registrazione è rifiutata (#link(<uc-registrazione-cellulare>)[UC-9.1.1]). Se il codice OTP è errato o scaduto, la registrazione non viene completata (#link(<uc-registrazione-otp>)[UC-9.1.2]).],
  diagram: "../../img/diagrams/uc-9.1.png") <uc-registrazione>

#pagebreak()
#usecase("9.1.1", [Cellulare non disponibile], [Cliente],
  [Il cliente sta effettuando la registrazione e il cellulare indicato è già associato ad un altro cliente.],
  [Il sistema rifiuta la registrazione e segnala che il cellulare è già in uso.],
  [Nessun cliente viene creato e il cliente può indicare un altro numero.]) <uc-registrazione-cellulare>

#usecase("9.1.2", [Verifica OTP fallita], [Cliente],
  [Il cliente sta effettuando la registrazione e ha inserito un codice OTP errato o scaduto.],
  [Il sistema rifiuta il codice e segnala l’errore.],
  [Il cliente non risulta identificato e può richiedere un nuovo codice.]) <uc-registrazione-otp>

#usecase("9.2", [Autenticazione SPID simulata], [Cliente],
  [Lo storefront dell’organizzatore è attivo e il cliente non si è ancora identificato.],
  [Il cliente sceglie l’accesso tramite SPID, simulato nel prototipo, come alternativa alla registrazione.],
  [Il cliente è identificato e può procedere all’acquisto.],
  diagram: none) <uc-spid>

#pagebreak()
#usecase("9.3", [Limite titoli raggiunto], [Cliente],
  [Il cliente sta effettuando l’acquisto online e ha già raggiunto, anche su altri organizzatori, il limite di dieci titoli per quell’evento.],
  [Il sistema blocca il carrello prima del pagamento e segnala il limite.],
  [Nessun pagamento viene richiesto e nessun titolo viene emesso.]) <uc-acquisto-limite>

#usecase("9.4", [Transazione non completata], [Cliente],
  [Il cliente sta effettuando l’acquisto online e il pagamento simulato è rifiutato.],
  [Il sistema segnala l’esito negativo e non procede all’emissione.],
  [Nessun titolo viene emesso e nessun movimento viene scritto nel log.]) <uc-acquisto-pagamento>

#usecase("9.5", [CAPTCHA non valido], [Cliente],
  [Il cliente sta effettuando l’acquisto online e non ha superato il CAPTCHA.],
  [Il sistema non consente la composizione del carrello e propone un nuovo CAPTCHA.],
  [Nessun carrello viene creato e il cliente può ripetere la prova.]) <uc-acquisto-captcha>

#pagebreak()
#usecase(10, [Modifica dell’intestatario], [Cliente],
  [Il titolo è nominativo, di proprietà del cliente, ed è stato acquistato.],
  [
    + Il cliente apre il titolo dalla propria area personale e indica il nuovo nome e cognome dell’intestatario.
    + Il sistema annulla il titolo originario ed emette un nuovo titolo con il nuovo nominativo.
    + Collega i due movimenti nel log, così da poterli ricostruire insieme.
  ],
  [Il titolo originario è annullato, quello nuovo è valido e i due movimenti sono correlati.],
  alternative: [Se l’evento è già iniziato, o il titolo è già stato usato al varco, il cambio nominativo viene rifiutato (#link(<uc-cambio-nominativo-termine>)[UC-10.1]). Se il titolo indicato non risulta di proprietà del cliente che ha fatto la richiesta, l’operazione viene rifiutata (#link(<uc-cambio-nominativo-proprieta>)[UC-10.2]).], diagram: "../../img/diagrams/uc-10.png") <uc-cambio-nominativo>

#pagebreak()
#usecase("10.1", [Cambio nominativo fuori termine], [Cliente],
  [Il cliente sta eseguendo il cambio nominativo e l’evento è già iniziato, oppure il titolo risulta già usato.],
  [Il sistema rifiuta il cambio nominativo e segnala lo stesso limite temporale previsto per l’annullo dei titoli digitali siccome si tratta di un annullo seguito da nuova emissione.],
  [Il titolo originario resta invariato e nessun nuovo titolo viene emesso.]) <uc-cambio-nominativo-termine>

#usecase("10.2", [Proprietà del titolo non verificata], [Cliente],
  [Il cliente sta eseguendo il cambio nominativo e il titolo indicato non risulta di proprietà del cliente che ha fatto la richiesta.],
  [Il sistema rifiuta l’operazione e segnala che il titolo non è disponibile per questa richiesta.],
  [Nessun titolo viene annullato né emesso.]) <uc-cambio-nominativo-proprieta>

#pagebreak()
#usecase(11, [Pubblicazione per la rivendita], [Cliente],
  [Il titolo è stato acquistato sul sito dell’organizzatore (#link(<uc-acquisto>)[UC-9]) e non è ancora stato usato.],
  [
    + Il cliente sceglie di rimettere in vendita un proprio titolo.
    + Il sistema lo pubblica nella sezione del sito primario dedicata alla rivendita, mostrando ai nuovi acquirenti le sole informazioni della vendita primaria, insieme a modalità, tempi e costi dell’operazione.
    + Quando un altro cliente lo acquista, il sistema annulla il titolo del venditore ed emette un nuovo titolo per l’acquirente.
  ],
  [Il titolo è disponibile per un nuovo acquirente, con annullo e nuova emissione correlati.], diagram: "../../img/diagrams/uc-11.png") <uc-rimessa>

#pagebreak()
#usecase(12, [Lettura del titolo al varco], [Addetto al varco],
  [L’evento è attivo e la lista unica dei titoli validi per l’evento è caricata, comprensiva degli eventuali titoli importati da altri sistemi (#link(<uc-configurazione-evento>)[UC-1]).],
  [
    + L’addetto legge il codice del titolo presentato dal cliente.
    + Il sistema verifica che il titolo sia nella lista e non sia già stato usato.
    + Registra l’accesso in tempo reale e blocca ogni lettura successiva dello stesso titolo.
  ],
  [L’accesso è registrato, il titolo non è più utilizzabile e il riepilogo degli accessi si aggiorna.],
  alternative: [Se il titolo non è nella lista, o è già stato usato, il varco mostra un esito negativo e non registra l’accesso.], diagram: "../../img/diagrams/uc-12.png") <uc-varco>

#pagebreak()
#usecase(13, [Disattivazione manuale del titolo], [Operatore],
  [Il titolo esiste nella lista dell’evento (#link(<uc-varco>)[UC-12]).],
  [
    + L’operatore individua il titolo da invalidare, per esempio in caso di smarrimento o frode segnalata.
    + Conferma l’invalidazione manuale.
    + Il sistema toglie il titolo dalla lista valida, con effetto immediato al varco.
  ],
  [Il titolo non può più essere usato al varco.], diagram: "../../img/diagrams/uc-13.png") <uc-invalidazione>

#pagebreak()
#usecase(14, [Generazione del wallet pass], [Cliente],
  [Il titolo è valido (#link(<uc-acquisto>)[UC-9]) e il cliente ha chiesto il pass.],
  [
    + Il cliente chiede, dalla propria area personale, il pass per Apple Wallet o Google Wallet.
    + Il sistema genera un pass con una credenziale opaca, priva di dati personali, e lo consegna al wallet scelto.
    + A ogni annullo, cambio nominativo o rimessa in vendita del titolo, il sistema aggiorna o revoca il pass di conseguenza.
  ],
  [Il pass riflette lo stato corrente del titolo.], diagram: "../../img/diagrams/uc-14.png") <uc-wallet>

/*
== Requisiti per gruppo <requisiti>

#show heading.where(level: 3): set text(size: 16pt)

Le tabelle seguono l’ordine della checklist fornita da #azienda e ogni riga riporta il codice, una sintesi del requisito, lo stato e il caso d’uso che lo realizza.

#heading(level: 3, outlined: false)[Gruppo A: vincoli architetturali] <gruppo-a>

#status-table((
  ([A1], [Il sistema non funziona senza la carta di attivazione: anagrafiche, emissione, log e riepiloghi sono bloccati], [Nel prototipo], [UC3]),
  ([A2], [PIN richiesto all’accensione e a ogni rimozione della carta], [Nel prototipo], [UC3]),
  ([A3], [Prima attivazione: memorizzazione di titolare, codice sistema e codice carta, controllo della firma, visualizzazione dei contatori], [Nel prototipo], [UC3]),
  ([A4], [Nessuna funzione, palese o nascosta, aggira la carta o modifica log e titoli al di fuori del percorso previsto], [Nel prototipo], [Tutti]),
  ([A5], [Software fiscale, log e carte su componenti in Italia, in locali dichiarati, con custodi nominati], [Fuori perimetro], [–]),
  ([A6], [Associazione univoca tra carta e sistema; i movimenti sigillati da una carta si registrano nel sistema che la ospita], [Nel prototipo], [UC3]),
), caption: [Requisiti del gruppo A.]) <tab-gruppo-a>

#heading(level: 3, outlined: false)[Gruppo B: anagrafiche e configurazione] <gruppo-b>

#status-table((
  ([B1], [Gestione di eventi, locali, organizzatori, tabelle di sistema e tabella dei prezzi], [Nel prototipo], [UC1, UC2]),
  ([B2], [Più organizzatori ed eventi in parallelo, anche per manifestazioni che attraversano la mezzanotte], [Nel prototipo], [UC1]),
  ([B3], [Codice locale assegnato da SIAE: acquisito e usato, non generato], [Nel prototipo], [UC2]),
  ([B4], [Comunicazione a SIAE degli organizzatori serviti, prima dell’inizio del servizio (§1.7.5 Allegato A del Provv. 2002)], [Fuori perimetro], [–]),
), caption: [Requisiti del gruppo B.]) <tab-gruppo-b>

#heading(level: 3, outlined: false)[Gruppo C: emissione del titolo] <gruppo-c>

#status-table((
  ([C1], [Emissione completa quando il titolo è definito e registrato nel log, anche se non è stato stampato], [Nel prototipo], [UC4]),
  ([C2], [Dati obbligatori dell’art. 3 del D.M. 2000: natura, data e ora, luogo, posto, corrispettivo, gratuità o riduzione con causale, prevendita e prestazioni accessorie separate, sigillo], [Nel prototipo], [UC4]),
  ([C3], [Diciture per la vendita per conto di terzi e per la vendita da parte dell’organizzatore], [Nel prototipo], [UC4]),
  ([C4], [Abbonamenti con dicitura, numero di prestazioni, turno libero e ratei per turno fisso], [Nel prototipo], [UC4]),
  ([C5], [Titoli open registrati come abbonamenti con codice proprio, un evento abilitato e turno libero], [Nel prototipo], [UC4]),
  ([C6], [Gratuità e riduzioni evidenziate per la lettura immediata], [Nel prototipo], [UC4]),
  ([C7], [Sigillo di 16 caratteri calcolato dalla carta su codice carta, data, ora, importo e progressivo], [Nel prototipo], [UC4]),
  ([C8], [Il numero della carta sostituisce il logotipo fiscale sul titolo], [Nel prototipo], [UC4]),
  ([C9], [Incremento dei contatori a bordo della carta a ogni emissione], [Nel prototipo], [UC3, UC4]),
  ([C10], [Registrazione in banca dati, memorie temporanee e log, corretta anche sotto carico], [Nel prototipo], [UC4]),
  ([C11], [Una sola stampa per titolo: ristampa e stampa multipla inibite, diritto consumato lato server], [Nel prototipo], [UC9]),
  ([C12], [Titoli nominativi con nome e cognome, senza altri dati personali nella lista unica], [Nel prototipo], [UC4, UC12]),
  ([C13], [Importi in euro con due cifre decimali, coerenti con il tracciato], [Nel prototipo], [UC4]),
), caption: [Requisiti del gruppo C.]) <tab-gruppo-c>

#heading(level: 3, outlined: false)[Gruppo D: annullamento] <gruppo-d>

L’annullo richiede sempre una causale, scelta tra i dieci codici definiti dalla documentazione normativa (#link(<tab-causali>)[tabella sottostante]). Il codice scelto determina anche il termine entro cui l’annullo è ammesso (D1–D3).

#figure(table(
  columns: (2cm, 1fr),
  inset: 7pt,
  stroke: 0.5pt + rgb("b8b8bd"),
  fill: (_, row) => if calc.odd(row) { rgb("f5f5f7") } else { white },
  table.header([*Codice*], [*Causale*]),
  [001], [Errata compilazione],
  [002], [Stampa non valida],
  [003], [Transazione non completata],
  [004], [Annullamento su richiesta del cliente],
  [005], [Annullamento per motivi di servizio],
  [006], [Annullamento evento],
  [007], [Annullamento per cambio nominativo],
  [008], [Annullamento per rivendita],
  [009], [Annullamento per furto/smarrimento],
  [010], [Annullamento per sostituzione contestuale con titolo diverso di importo uguale o superiore (upselling)],
), caption: emph[Causali di annullo, da #raw("2019 All.B p.1 lett. i")], kind: table, supplement: [Tabella]) <tab-causali>

#status-table((
  ([D1], [Annullo con causale entro il quinto giorno lavorativo successivo all’evento], [Nel prototipo], [UC5]),
  ([D2], [Titoli digitali annullabili fino all’inizio dell’evento], [Nel prototipo], [UC5]),
  ([D3], [Evento non effettuato: annullo entro i termini di versamento delle imposte], [Nel prototipo], [UC5]),
  ([D4], [Annulli e rimborsi di titoli digitali solo con pagamenti tracciabili], [Nel prototipo], [UC5, UC9]),
  ([D5], [Annullo con record ANNULLATO completo dei dati del titolo originario, identificato da progressivo e sigillo], [Nel prototipo], [UC5]),
  ([D6], [Conservazione del titolo annullato, anche in forma informatica], [Nel prototipo], [UC5]),
), caption: [Requisiti del gruppo D.]) <tab-gruppo-d>

#heading(level: 3, outlined: false)[Gruppo E: log delle transazioni] <gruppo-e>

#status-table((
  ([E1], [Log con tutti i movimenti: emissioni, annullamenti e abbonamenti], [Nel prototipo], [UC6]),
  ([E2], [Formato ASCII a campi fissi o XML; XML obbligatorio per i flussi dei Capi II e III del Provv. 2019], [Fuori perimetro], [UC6]),
  ([E3], [Registrazione su supporto immodificabile], [Nel prototipo], [UC6]),
  ([E4], [Certificato a inizio registrazione e firma digitale a fine giornata con chiave a bordo della carta], [Nel prototipo], [UC6]),
  ([E5], [Conservazione per 24 mesi dall’ultimo titolo, con funzioni di verifica e copia per il controllo], [Nel prototipo], [UC6]),
), caption: [Requisiti del gruppo E.]) <tab-gruppo-e>

#heading(level: 3, outlined: false)[Gruppo F: riepiloghi e trasmissione] <gruppo-f>

#status-table((
  ([F1], [Riepilogo giornaliero: proventi per evento e ordine di posto, abbonamenti per organizzatore, ingressi per tipologia, sigillo], [Nel prototipo], [UC6, UC7]),
  ([F2], [Riepilogo mensile dei titoli: proventi per evento anche se incassati nei mesi precedenti, ratei per turno fisso], [Nel prototipo], [UC7]),
  ([F3], [Riepilogo mensile degli altri proventi (record 8 e 9), se la funzione è dichiarata], [Fuori perimetro], [UC7]),
  ([F4], [Tracciati FLAT e XML, firma digitale, crittografia, codice di autenticazione, sequenza corretta dei record], [Nel prototipo], [UC6, UC7]),
  ([F5], [Termini di trasmissione a SIAE per riepiloghi mensili e per evento], [Fuori perimetro], [–]),
  ([F6], [Stampa cartacea su A3 o A4 secondo i modelli C.1 e C.2], [Fuori perimetro], [–]),
  ([F7], [Gestione e comunicazione dei periodi di inattività], [Nel prototipo], [UC7]),
), caption: [Requisiti del gruppo F.]) <tab-gruppo-f>

#heading(level: 3, outlined: false)[Gruppo G: funzioni di servizio e conservazione] <gruppo-g>

#status-table((
  ([G1], [Consultazione a video e su carta, o esportazione, di dettagli e riepiloghi aggiornati], [Nel prototipo], [UC7]),
  ([G2], [Ricerca per numero di carta e progressivo, o per sigillo], [Nel prototipo], [UC7]),
  ([G3], [Viste per giornata di emissione e per evento, con ordine di posto e tipologia], [Nel prototipo], [UC7]),
  ([G4], [Cancellazione dei titoli consentita solo dopo 60 giorni dall’evento], [Nel prototipo], [UC7]),
  ([G5], [Cancellazione dei riepiloghi consentita solo dopo due anni dalla trasmissione], [Fuori perimetro], [UC7]),
), caption: [Requisiti del gruppo G.]) <tab-gruppo-g>

#heading(level: 3, outlined: false)[Gruppo H: mancato funzionamento] <gruppo-h>

#status-table((
  ([H1], [Blocco immediato, richiesta di manutenzione, annotazione sul libretto fiscale], [Facoltativo (F02)], [UC8]),
  ([H2], [Registro di inizio e fine del guasto, totale dei biglietti manuali per evento e tipologia], [Facoltativo (F02)], [UC8]),
  ([H3], [Contatore dei giorni di fermo con allarme al trentesimo giorno per anno solare], [Facoltativo (F02)], [UC8]),
), caption: [Requisiti del gruppo H.]) <tab-gruppo-h>

#heading(level: 3, outlined: false)[Gruppo I: vendita online] <gruppo-i>

#status-table((
  ([I1], [CAPTCHA prima della composizione del carrello], [Nel prototipo], [UC9]),
  ([I2], [Acquisto concluso solo da utente identificato], [Nel prototipo], [UC9]),
  ([I3], [Registrazione con dati anagrafici, email, cellulare e mezzo per il riscontro; cellulare associato a un solo utente nel sistema], [Nel prototipo], [UC9]),
  ([I4], [SPID come alternativa alla registrazione], [Nel prototipo], [UC9]),
  ([I5], [Massimo dieci titoli per evento e utente, valido a livello di sistema su tutti i front-end], [Nel prototipo], [UC9]),
  ([I6], [Titolo non rilasciato a fine sessione, ma inviato con il mezzo scelto], [Nel prototipo], [UC9]),
  ([I7], [Tracciamento delle operazioni dell’utente identificato], [Nel prototipo], [UC9]),
  ([I8], [Connessione HTTPS con almeno TLS 1.2], [Fuori perimetro], [–]),
  ([I9], [Deroga per eventi con vendita online fino a 1.000 titoli: bastano il CAPTCHA e le misure di sicurezza], [Fuori perimetro], [UC9]),
), caption: [Requisiti del gruppo I.]) <tab-gruppo-i>

#heading(level: 3, outlined: false)[Gruppo J: nominatività, cambio e rimessa in vendita] <gruppo-j>

#status-table((
  ([J1], [Titoli nominativi per impianti con capienza superiore a 5.000 posti, con esclusioni per tipologia di spettacolo], [Fuori perimetro], [UC9, UC10]),
  ([J2], [Accesso subordinato al riconoscimento personale: il titolo non vale per l’ingresso se il fruitore non coincide con il nominativo], [Nel prototipo], [UC12]),
  ([J3], [Cambio nominativo con annullo, nuovo titolo nominativo e correlazione tracciata], [Nel prototipo], [UC10]),
  ([J4], [Rimessa in vendita con le sole informazioni della vendita primaria, nella sezione del sito primario], [Nel prototipo], [UC11]),
  ([J5], [Informativa chiara su modalità, tempi e costi delle due operazioni], [Nel prototipo], [UC10, UC11]),
), caption: [Requisiti del gruppo J.]) <tab-gruppo-j>

#heading(level: 3, outlined: false)[Gruppo K: controllo accessi] <gruppo-k>

#status-table((
  ([K1], [Lista unica dei titoli validi per evento, anche emessi da più sistemi], [Desiderabile (D04)], [UC12]),
  ([K2], [Registrazione in tempo reale di ogni accesso], [Desiderabile (D04)], [UC12]),
  ([K3], [Inibizione del riutilizzo dello stesso titolo], [Desiderabile (D04)], [UC12]),
  ([K4], [Nella lista unica solo nome e cognome degli intestatari], [Desiderabile (D04)], [UC12]),
  ([K5], [Il varco è componente del sistema certificato: va descritto nell’istanza e verificato in certificazione], [Fuori perimetro], [UC12]),
), caption: [Requisiti del gruppo K.]) <tab-gruppo-k>

#heading(level: 3, outlined: false)[Gruppo L: output e supporti] <gruppo-l>

#status-table((
  ([L1], [Sul titolo stampato: numero di carta, progressivo, prezzo, data e ora di emissione, sigillo e nome dell’intestatario, se nominativo], [Nel prototipo], [UC9]),
  ([L2], [Render del titolo generato centralmente; stampanti come terminali senza capacità di elaborazione], [Nel prototipo], [UC9]),
  ([L3], [Nessun modello di stampante prescritto], [Fuori perimetro], [–]),
), caption: [Requisiti del gruppo L.]) <tab-gruppo-l>
*/