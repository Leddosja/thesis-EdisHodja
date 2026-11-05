#import "shared.typ": *

#pagebreak()
= Verifica e validazione <verifica-validazione>

La verifica del prototipo si è incentrata su una revisione non solo dal punto di vista funzionale, ma anche sul controllo normativo degli standard richiesti dalla checklist di requisiti. In primo piano la correttezza dei singoli meccanismi previsti dalla normativa come il principio dell'idempotenza, la catena delle impronte e il vincolo append-only è verificata con test automatici realizzati per ogni classe del livello `App\Fiscal\Support`. L'altra operazione di validazione riguarda invece la conformità dei tracciati prodotti al formato richiesto dall'Agenzia delle Entrate, verificata confrontando l'output del prototipo con il DTD del provvedimento 223774/2019.

== Metodologia e verifica dei meccanismi

I test riprendono la matrice dei requisiti in cui ad ogni condizione corrisponde una classe del livello `Support` affiancata dal nome del test che ne verifica il comportamento. Nei casi in cui il requisito attraversa più classi in sequenza, come l'emissione di un titolo che passa da `TitleIssuer` a `FiscalWriter` e successivamente alla macchina a stati, il test corrispondente non isola le singole classi, ma esercita la sequenza per intero in modo da far emergere un qualsiasi difetto di composizione.

I test sono scritti con Pest ed eseguiti contro il database di sviluppo reale, secondo la convenzione già in uso nel resto del progetto RelAi dove ogni test crea i dati di cui ha bisogno e li rimuove alla fine con `afterEach()`, senza toccare lo stato lasciato da altri test.

Per ciascuno dei meccanismi descritti nella #link(<meccanismi-implementativi>)[sezione 4.2.1], il test riproduce la condizione che il meccanismo deve riconoscere, non solo il caso in cui tutto funziona: una chiave di idempotenza inviata due volte, un record alterato dopo la scrittura, un tentativo di modifica o cancellazione su una riga già registrata, una transizione di stato non ammessa. Lo stesso approccio vale per i vincoli più strettamente normativi, come le causali di annullo ammesse o il termine entro cui l'annullo resta possibile: anche questi vengono verificati riproducendo il caso che dovrebbero impedire, non solo quello in cui l'operazione è lecita.

Una parte dei test riproduce inoltre la concorrenza e non solo la sequenza, perché i meccanismi di controllo proteggono da un difetto logico ma non necessariamente da due richieste che arrivano simultaneamente come due annulli dello stesso titolo lanciati in parallelo, due emissioni che scrivono sullo stesso segmento di log, un cambio nominativo che corre contro la chiusura di giornata.\  Il punto critico è il blocco applicato al segmento durante la scrittura, tramite `lockForUpdate()`, e senza di esso, due richieste simultanee potrebbero leggere lo stesso stato e produrre due righe in conflitto, rompendo la catena delle impronte in un punto che nessun controllo successivo potrebbe più ripristinare. Anche in questo caso il test non si limita a verificare che il risultato finale sia coerente, bensì controlla che la seconda richiesta sia stata davvero messa in attesa della prima, perché altrimenti non distinguerebbe un blocco che funziona da uno assente.

== Validazione dei tracciati ed esiti

I tracciati ASCII e XML prodotti sono stati validati seguendo direttive recepite dalla documentazione ufficiale:
- Il tracciato ASCII, a larghezza fissa, è controllato riga per riga contro la lunghezza e l'allineamento, numerico e alfanumerico, che il provvedimento assegna a ciascun campo.
- Il tracciato XML è validato contro il DTD del 2019 con gli strumenti standard di validazione di uno schema e se un elemento è mancante, fuori ordine o con un attributo non previsto fa fallire la validazione nello stesso punto in cui la fallirebbe in fase di trasmissione reale.

Questa validazione copre la forma del tracciato, non tanto il suo contenuto perché un record strutturalmente valido ma con un importo o una causale sbagliati supera la validazione contro il DTD ma viene intercettato dai vari test del meccanismo che lo ha prodotto.

Complessivamente, tutti i test risultano superati pur muovendosi in un contesto in parte simulato, il prototipo si è integrato correttamente nell'architettura di RelAi e ha retto l'intera suite di test, che hanno avuto così anche una funzione dimostrativa oltre che di verifica. Ad ogni modo, questo risultato attesta la coerenza del prototipo con le regole di codifica, non la conformità certificata del sistema definitivo perché naturalmente richiederebbe il processo normativo e l'ambiente di certificazione AdE.