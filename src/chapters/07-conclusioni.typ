#import "shared.typ": *

#pagebreak()
= Conclusioni <conclusioni>

Lo stage, svolto presso #azienda dal 28 settembre al 20 novembre 2026 per un totale di circa 300 ore, ha prodotto un prototipo di biglietteria automatizzata per la vendita di titoli di accesso, organizzato nel namespace `App\Fiscal` all'interno del codebase di RelAi e copre l'intero ciclo di un titolo che va dalla configurazione di organizzatori, locali ed eventi, all'emissione e all'annullamento, fino alla chiusura giornaliera del log fiscale e alla generazione dei riepiloghi.

Il backend applica i meccanismi richiesti dalla normativa fornita già in documentazione aziendale (sigillo fiscale, chiave di idempotenza, catena delle impronte, vincolo append-only, locking ottimistico sullo stato del sistema certificato). Per quanto riguarda invece le due interfacce, il pannello di back-office costruito su Filament e lo storefront pubblico costruito su Livewire, si appoggiano agli stessi servizi di dominio, così che la logica fiscale resti in un unico punto verificabile indipendentemente da quale delle due la invochi.

La verifica e il testing ha riprodotto sia il caso in cui ogni meccanismo funziona sia il caso in cui dovrebbe intervenire, includendo i test di concorrenza sui vincoli critici e la validazione dei tracciati ASCII e XML contro il DTD del provvedimento 223774/2019. Nonostante ciò, come dichiarato il prototipo resta in parte simulato ma una base tecnica da sottoporre al processo di certificazione AdE.

#pagebreak()
== Raggiungimento degli obiettivi

Di seguito viene riportata una tabella riassuntiva dello stato di raggiungimento degli obiettivi del piano di lavoro al termine dello stage.

#figure(
  table(
    columns: (2.7cm, 1fr, 2.7cm),
    inset: 7pt,
    stroke: 0.5pt + rgb("b8b8bd"),
    fill: (_, row) => if calc.odd(row) { rgb("f5f5f7") } else { white },
    table.header([*Obiettivo*], [*Descrizione*], [*Raggiunto*]),
    [O1], [Analizzare i requisiti normativi e l'architettura di riferimento.], [Sì],
    [O2], [Definire il modello dei dati e simulare la carta di attivazione.], [Sì],
    [O3], [Realizzare emissione, annullamento e registrazione dei movimenti.], [Sì],
    [O4], [Generare riepiloghi e funzioni di consultazione], [Sì],
    [O5], [Verificare il prototipo con test funzionali e di concorrenza e documentarne risultati e limiti.], [Sì],

    [D1], [Vendita online in modalità white-label.], [Sì],
    [D2], [Gestione dei titoli nominativi e dei cambi nominativo.], [Sì],
    [D3], [Rimessa in vendita di un titolo.], [Sì],
    [D4], [Controllo degli accessi al varco.], [Sì],

    [F1], [Emissione del wallet pass.], [Sì],
    [F2], [Gestione delle procedure in caso di guasto.], [Sì],
    [F3], [Integrazione con RelAi.], [Parziale],
  ),
  caption: [Stato di raggiungimento degli obiettivi del piano di lavoro],
) <tab-obiettivi>

Come evidenziato dalla tabella, tutti gli obiettivi del piano sono stati raggiunti o parzialmente coperti entro il termine dello stage. L'unico che merita una precisazione riguarda l'integrazione con RelAi che non è stata realizzata come un'attività a sé stante, ma è di fatto il presupposto dell'intero prototipo, dato che il modulo fiscale non comunica con RelAi tramite un'interfaccia esterna, bensì vive nello stesso codebase e ne riusa l'autenticazione, il pannello amministrativo e l'infrastruttura multi-tenant presente.

#pagebreak()
== Conoscenze acquisite

Lo stage ha richiesto di muoversi su due piani paralleli: la comprensione di un dominio normativo specifico, quello della biglietteria fiscale AdE/SIAE, e l'uso dello stack tecnologico già in produzione in azienda. Tradurre un provvedimento amministrativo in un vincolo di codice verificabile da un test è stato l'esercizio più ricorrente dello stage che ha richiesto di leggere la normativa non come un testo da riassumere ma come una specifica da cui derivare la struttura del dato e il comportamento del sistema.

Il lavoro ha anche approfondito la progettazione concorrente: distinguere un vincolo che regge sotto richieste sequenziali da uno che regge anche sotto richieste simultanee, e scrivere test in grado di dimostrare la differenza, è stata una capacità costruita settimana dopo settimana, insieme alla familiarità con il codebase di RelAi, con le sue convenzioni di revisione del codice e con il flusso di lavoro basato su Git già in uso in azienda.

== Valutazione personale

Ritengo che lo stage abbia raggiunto l'obiettivo dichiarato nel piano di lavoro, ovvero dimostrare i flussi end-to-end di una biglietteria fiscale, pur con i componenti dichiaratamente simulati, e costituire una base tecnica solida per lo sviluppo successivo. La parte che ho trovato più formativa è stata l'analisi dei requisiti normativi, proprio perché meno vicina a un problema puramente tecnico in cui interpretare un provvedimento scritto per un pubblico non tecnico e tradurlo in una struttura dati o in un test ha richiesto un confronto costante con il tutor aziendale ed i colleghi che si occupavano di RelAi.

Le difficoltà maggiori sono state quelle previste inizialmente, come l'assenza delle specifiche reali della carta di attivazione che ha richiesto di progettare fin da subito componenti compatibili con una futura sostituzione, mentre i vincoli di concorrenza hanno richiesto un tempo di verifica superiore a quello dedicato ai soli test funzionali. Nel complesso, considero lo stage un'occasione utile per misurarmi con un progetto vincolato da una normativa esterna, non da requisiti liberamente negoziabili, e per lavorare all'interno di un codebase già in produzione seguendone le convenzioni esistenti invece di definirle completamente da zero.

#pagebreak()
== Sviluppi futuri e limiti

Sebbene il prototipo sviluppato copra l'intero ciclo di vita del titolo fiscale, dalla configurazione dell'evento fino alla fase conclusiva di riepilogo, la presenza di alcune componenti puramente simulate segna il limite strutturale tra una verifica di logica e una vera conformità normativa. Nello specifico, elementi fondamentali come la carta di attivazione, il sigillo fiscale da essa generato e il supporto immodificabile su cui viene registrata la chiusura dei segmenti non possono essere semplicemente emulati all'interno di un sistema destinato alla certificazione. Per questa ragione, per quanto le prove di concorrenza e la validazione dei tracciati abbiano dimostrato che la logica applicativa risponde correttamente, la validità di questi test riposa sull'assunzione che il dispositivo reale rispetti l'hardware emulato, lasciando ancora aperta la dimostrazione della piena adeguatezza legale del sistema.

Il passaggio successivo più immediato consiste quindi nel sostituire la simulazione con le specifiche reali della scheda, non appena la SIAE le renderà disponibili su richiesta. In questo modo si potrà verificare se la struttura dei tracciati nei formati ASCII e XML rimanga corretta anche quando il sigillo e la firma digitale derivano da un dispositivo fisico vero e non da una funzione di hash eseguita a livello software.

Al di là dell'aspetto puramente tecnico, l'elemento di maggiore rilievo riguarda il seguito che questo lavoro avrà in azienda dopo la consegna dell'elaborato. Il team di sviluppo analizzerà infatti il prototipo per valutare se lo schema di memorizzazione append-only, le strategie per l'idempotenza e la separazione concettuale tra i servizi di dominio e le interfacce possano rappresentare la base su cui edificare l'infrastruttura definitiva. Tale impianto dovrà poi essere sottoposto all'Agenzia delle Entrate per richiedere la capacità di emettere titoli fiscali in totale autonomia. Il percorso condotto durante lo stage non si esaurisce di conseguenza con questa trattazione, ma si propone di anticipare, per quanto consentito dai dati accessibili negli ultimi mesi, le decisioni architetturali indispensabili per il sistema finale in sede di certificazione.

#pagebreak()