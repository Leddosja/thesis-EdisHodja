#import "shared.typ": *

/*

#pagebreak()

= Processi e metodologie <processi-metodologie>

Questo capitolo descrive come è stato organizzato il lavoro di stage. Il piano concordato con il tutor aziendale #tutor fissa l’ordine delle attività, la durata delle settimane e i punti di controllo. Le scelte di dettaglio, come la forma dei test o l’ordine con cui affrontare i requisiti di una stessa area, sono state prese durante lo sviluppo.

== Organizzazione del lavoro <organizzazione-lavoro>

Il lavoro si svolge in otto settimane: sette da quaranta ore e una da venti. Ogni settimana corrisponde ad un blocco funzionale del sistema. Si parte dall’analisi normativa e dall’ambiente di sviluppo, si passa al modello dei dati e alla carta simulata, poi a emissione e annullo, log e riepiloghi. Le ultime settimane sono dedicate a vendita online, nominatività, controllo accessi e test. L’ordine non è casuale: il log registra i movimenti prodotti dall’emissione, quindi conviene costruire prima l’emissione, e il controllo accessi legge titoli che devono già esistere nel sistema.

Ogni settimana segue lo stesso schema. Il primo incontro con il tutor, all’inizio della settimana, serve a fissare le task: quali requisiti coprire, quali flussi realizzare e quali risorse servono, come documentazione normativa, ambienti e dati di prova. A metà settimana si tiene un incontro intermedio, riservato ai problemi emersi durante lo sviluppo. Le parti che richiedono più discussione sono la scrittura serializzata dei movimenti, i tracciati del log e dei riepiloghi e i vincoli di concorrenza. L’ultimo incontro, a fine settimana, prevede una dimostrazione diretta dei flussi sul prototipo, seguita da un riscontro del tutor.

== Revisione del codice e supporto <revisione-codice>

Il codice viene rivisto periodicamente dal tutor aziendale #tutor tramite un sistema di versionamento fornito da Gitea. La revisione controlla tre aspetti: che il codice sia leggibile e coerente con l’architettura di riferimento, che le funzioni rispettino i requisiti normativi a cui dovrebbero corrispondere e che la logica sia corretta nei casi limite. Quando un punto non è chiaro, il tutor è raggiungibile per messaggio tramite il canale di comunicazione Telegram, anche fuori dagli incontri programmati. Questo canale serve soprattutto per le interpretazioni dei requisiti: una norma scritta in modo generico può essere letta in più modi, e la lettura va condivisa prima di diventare codice.

== Dai requisiti alle evidenze <matrice-requisiti>

Il punto di partenza sono i requisiti che l’azienda ha raccolto in gruppi tematici, dalla A alla N, insieme alle checklist e al testo del D.M. 13 luglio 2000 e dei provvedimenti dell’Agenzia delle Entrate. Non tutti i requisiti rientrano nel perimetro dello stage e quelli selezionati vengono tradotti in una riga della matrice requisito → componente → test → evidenza redatta durante la prima settimana ed aggiornata nel corso delle settimane successive. La riga indica quale parte del sistema implementa il requisito, quale test lo verifica e quale evidenza ne mostra il risultato, per esempio un tracciato generato o l’esito di un test di concorrenza.

== Strategia di verifica <strategia-verifica>

La verifica si divide in due gruppi di test. I test funzionali seguono i flussi end-to-end: configurazione dell’evento, vendita, emissione, controllo accessi, chiusura giornaliera e riepilogo. Ogni flusso viene percorso dall’inizio alla fine sul prototipo, controllando sia ciò che vede l’utente sia ciò che viene registrato.

I test di concorrenza riproducono richieste simultanee sui vincoli che non devono cedere: una sola stampa per titolo, limite di dieci titoli per evento e utente, unicità del cellulare a livello di sistema e scansioni contemporanee al varco. Un vincolo di questo tipo si verifica solo quando più richieste arrivano nello stesso momento, quindi un test sequenziale non basta a dimostrarlo.
*/