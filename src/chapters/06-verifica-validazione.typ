#import "shared.typ": *

#let screenshot(path, caption: none, pull-left: 1cm, pull-right: 1.5cm) = {
  figure(
    pad(left: -pull-left, right: -pull-right)[
      #block(
        fill: rgb("f7f7f9"),
        stroke: 0.75pt + rgb("b8b8bd"),
        radius: 6pt,
        inset: 10pt,
        width: 100%,
        breakable: false,
      )[#image(path, width: 100%)]
    ],
    caption: caption,
  )
}

#pagebreak()
= Verifica e validazione <verifica-validazione>

La verifica del prototipo si è incentrata su una revisione non solo dal punto di vista funzionale, ma anche sul controllo normativo degli standard richiesti dalla checklist di requisiti. In primo piano la correttezza dei singoli meccanismi previsti dalla normativa come il principio dell'idempotenza, la catena delle impronte e il vincolo append-only è verificata con test automatici realizzati per ogni classe del livello `App\Fiscal\Support`. L'altra operazione di validazione riguarda invece la conformità dei tracciati prodotti al formato richiesto dall'Agenzia delle Entrate, verificata confrontando l'output del prototipo con il DTD del provvedimento 223774/2019.

== Metodologia e verifica dei meccanismi

I test riprendono la matrice dei requisiti in cui ad ogni condizione corrisponde una classe del livello `Support` affiancata dal nome del test che ne verifica il comportamento. Nei casi in cui il requisito attraversa più classi in sequenza, come l'emissione di un titolo che passa da `TitleIssuer` a `FiscalWriter` e successivamente alla macchina a stati, il test corrispondente non isola le singole classi, ma esercita la sequenza per intero in modo da far emergere un qualsiasi difetto o errore.

I test sono scritti con Pest ed eseguiti contro il database di sviluppo reale, secondo la convenzione già in uso nel resto del progetto RelAi dove ogni test crea i dati di cui ha bisogno e li rimuove alla fine con `afterEach()`, senza toccare lo stato lasciato da altri test.

Alcuni test verificano il comportamento del sistema quando più operazioni vengono eseguite contemporaneamente, e non soltanto una dopo l’altra. La distinzione è importante perché un controllo può impedire un’operazione non valida, ma non è detto che gestisca correttamente due richieste che agiscono nello stesso momento sugli stessi dati. Tra i casi considerati rientrano l’annullamento simultaneo dello stesso titolo, due emissioni sul medesimo segmento del log e un cambio nominativo avviato durante la chiusura della giornata.

Per evitare conflitti, durante la scrittura il sistema blocca il segmento interessato tramite `lockForUpdate()`. In assenza di questo blocco, due richieste potrebbero leggere lo stesso stato e registrare modifiche incompatibili, causando un'incoerenza nel log. Nel caso del log, ad esempio, entrambe potrebbero basarsi sulla stessa impronta precedente, compromettendo la continuità della catena. Il test verifica quindi non solo che il risultato finale sia coerente, ma anche che la seconda richiesta attenda il completamento della prima in modo da accertarsi che il blocco venga applicato davvero.

== Validazione dei tracciati ed esiti

I tracciati ASCII e XML prodotti sono stati validati seguendo direttive recepite dalla documentazione ufficiale:
- Il tracciato ASCII, a larghezza fissa, è controllato riga per riga contro la lunghezza e l'allineamento, numerico e alfanumerico, che il provvedimento assegna a ciascun campo.
- Il tracciato XML è validato contro il DTD del 2019 con gli strumenti standard di validazione di uno schema e se un elemento è mancante, fuori ordine o con un attributo non previsto fa fallire la validazione nello stesso punto in cui la fallirebbe in fase di trasmissione reale. La figura seguente riporta un esempio di tracciato XML prodotto dal prototipo in fase di emissione di un titolo:

#figure(
  image("../../img/screenshots/esempio-xml.png", width: 120%),
  caption: [Figura 11: Esempio di tracciato XML dell'emissione di un titolo],
) <fig-esempio-xml>

#pagebreak()

Questa validazione copre la forma del tracciato, non tanto il suo contenuto perché un record strutturalmente valido ma con un importo o una causale sbagliati supera la validazione contro il DTD ma viene intercettato dai vari test del meccanismo che lo ha prodotto.

Complessivamente tutti i test, in totale 221, risultano superati pur muovendosi in un contesto in parte simulato, il prototipo si è integrato correttamente nell'architettura di RelAi e ha retto l'intera suite di test, che hanno avuto così anche una funzione dimostrativa oltre che di verifica. Ad ogni modo, questo risultato attesta la coerenza del prototipo con le regole di codifica, non la conformità certificata del sistema definitivo perché naturalmente richiederebbe il processo normativo e l'ambiente di certificazione AdE.