#import "shared.typ": *

#pagebreak()
= Conclusioni <conclusioni>

Lo stage, svolto presso #azienda dal 28 settembre al 20 novembre 2026 per un totale di circa 300 ore, ha portato alla realizzazione di un prototipo per la gestione automatizzata della biglietteria fiscale. Il modulo, sviluppato nel namespace `App\Fiscal` all'interno del codebase di RelAi, copre le principali fasi del ciclo di vita di un titolo: dalla configurazione di organizzatori, locali ed eventi, all'emissione e all'annullamento, fino alla chiusura giornaliera del log fiscale e alla generazione dei riepiloghi.

Il backend implementa i meccanismi individuati nella documentazione normativa e aziendale come il sigillo fiscale, la chiave di idempotenza, la catena delle impronte, il vincolo append-only e locking ottimistico sullo stato del sistema certificato. Il pannello di back-office, realizzato con Filament, e lo storefront pubblico, realizzato con Livewire, utilizzano gli stessi servizi di dominio così che la logica fiscale resti in un unico punto verificabile indipendentemente da quale delle due la invochi.

La verifica ha riguardato sia il corretto funzionamento dei meccanismi implementati sia i casi in cui questi devono intervenire. Sono stati inclusi test di concorrenza sui vincoli più critici e la validazione dei tracciati ASCII e XML rispetto al DTD previsto dal provvedimento del 2019.

#pagebreak()
== Raggiungimento degli obiettivi

Di seguito viene riportata una tabella riassuntiva dello stato di raggiungimento degli obiettivi al termine dello stage.

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

Lo stage mi ha permesso di confrontarmi con l'applicazione di requisiti normativi in un contesto software già strutturato. Il lavoro ha richiesto di interpretare le disposizioni relative alla biglietteria fiscale e di ricondurle a regole applicative verificabili, considerando sia i riferimenti di Agenzia delle Entrate e SIAE sia le tecnologie adottate in azienda. La normativa ha così guidato la definizione dei dati e dei comportamenti del sistema, mentre i test automatici hanno permesso di verificare che l'implementazione rispettasse i requisiti individuati.

Un ulteriore ambito di apprendimento è stato quello della concorrenza. Ho verificato che un vincolo rispettato durante l'esecuzione sequenziale non garantisce necessariamente lo stesso risultato quando più operazioni accedono contemporaneamente alle risorse condivisee per individuare questi casi ho predisposto test specifici, affiancandoli alle verifiche funzionali. 
Il lavoro sul progetto mi ha inoltre consentito di acquisire familiarità con il codebase di RelAi e con le pratiche adottate dal team, dalla revisione del codice alla gestione delle modifiche tramite Git.

== Valutazione personale

Ritengo che lo stage abbia raggiunto l'obiettivo imposto inizialmente, ovvero dimostrare i flussi end-to-end di una biglietteria fiscale, pur con i componenti dichiaratamente simulati, e costituire una base tecnica solida per lo sviluppo successivo. La parte che ho trovato più formativa è stata l'analisi dei requisiti normativi, proprio perché meno vicina a un problema puramente tecnico in cui interpretare un provvedimento scritto per un pubblico non tecnico e tradurlo in una struttura dati o in un test ha richiesto un confronto costante con il tutor aziendale, #tutor, ed i colleghi che si occupavano di RelAi.

Le difficoltà maggiori sono state quelle previste inizialmente, come l'assenza delle specifiche reali della carta di attivazione che ha richiesto di progettare fin da subito componenti compatibili con una futura sostituzione, mentre i vincoli di concorrenza hanno richiesto un tempo di verifica superiore a quello dedicato ai soli test funzionali. Nel complesso, considero lo stage un'occasione utile per misurarmi con un progetto vincolato da una normativa esterna, non da requisiti liberamente negoziabili, e per lavorare all'interno di un codebase già in produzione seguendone le convenzioni esistenti invece di definirle completamente da zero.

#pagebreak()
== Sviluppi futuri e limiti

Sebbene il prototipo sviluppato copra l'intero ciclo di vita del titolo fiscale, dalla configurazione dell'evento fino alla fase conclusiva di riepilogo, la presenza di alcune componenti puramente simulate segna il limite strutturale tra una verifica di logica e una vera conformità normativa. Nello specifico, elementi fondamentali come la carta di attivazione, il sigillo fiscale da essa generato e il supporto immodificabile su cui viene registrata la chiusura dei segmenti non possono essere semplicemente emulati all'interno di un sistema destinato alla certificazione. Per questa ragione, per quanto le prove di concorrenza e la validazione dei tracciati abbiano dimostrato che la logica applicativa risponde correttamente, la validità di questi test riposa sull'assunzione che il dispositivo reale rispetti l'hardware emulato, lasciando ancora aperta la dimostrazione della piena adeguatezza legale del sistema.

Il passaggio successivo più immediato consiste quindi nel sostituire la simulazione con le specifiche reali della scheda, non appena la SIAE le renderà disponibili su richiesta. In questo modo si potrà verificare se la struttura dei tracciati nei formati ASCII e XML rimanga corretta anche quando il sigillo e la firma digitale derivano da un dispositivo fisico vero e non da una funzione di hash eseguita a livello software.

Al di là dell'aspetto puramente tecnico, l'elemento di maggiore rilievo riguarda il seguito che questo lavoro avrà in azienda dopo la consegna dell'elaborato. Il team di sviluppo analizzerà infatti il prototipo per valutare se lo schema di memorizzazione append-only, le strategie per l'idempotenza e la separazione concettuale tra i servizi di dominio e le interfacce possano rappresentare la base su cui edificare l'infrastruttura definitiva. Tale impianto dovrà poi essere sottoposto all'Agenzia delle Entrate per richiedere la capacità di emettere titoli fiscali in totale autonomia. Il percorso condotto durante lo stage non si esaurisce di conseguenza con questa trattazione, ma si propone di anticipare, per quanto consentito dai dati accessibili negli ultimi mesi, le decisioni architetturali indispensabili per il sistema finale in sede di certificazione.

#pagebreak()