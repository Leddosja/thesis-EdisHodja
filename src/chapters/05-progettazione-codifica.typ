#import "shared.typ": *

#pagebreak()
= Progettazione e codifica <progettazione-codifica>

Questo capitolo descrive come il prototipo è stato costruito: lo stack tecnologico adottato, il ciclo di vita seguito nello sviluppo, l'organizzazione del codice e i design pattern applicati.

== Tecnologie e strumenti <tecnologie-strumenti>

Di seguito viene data una panoramica delle tecnologie e degli strumenti utilizzati per la realizzazione del prototipo. Lo stack è quello già adottato da RelAi, l'applicazione ospitante con piattaforma CRM e loyalty multi-tenant di #azienda, in modo da integrare il modulo fiscale senza introdurre dipendenze aggiuntive né un ambiente di sviluppo separato da quello del resto del team.

#tech-heading("PHP", "../../img/logos/php.svg") <tec-php>

Linguaggio di programmazione lato server su cui è costruita l'intera applicazione. La scelta non nasce da una necessità specifica del prototipo, ma dalla decisione aziendale di sviluppare la biglietteria fiscale all'interno del codebase già esistente di RelAi, per riutilizzarne l'infrastruttura (autenticazione, multi-tenant, pipeline di test e di integrazione continua). Tra le caratteristiche del linguaggio sfruttate nel prototipo:

- enum nativi con metodi propri, usati per codificare i tipi di titolo e le causali di annullamento secondo le tabelle del tracciato AdE/SIAE;
- promozione delle proprietà nel costruttore, per ridurre il codice ripetitivo nei model e nei servizi di dominio;
- dichiarazione esplicita dei tipi di ritorno e dei parametri, utile a individuare in anticipo un valore incoerente con il dato fiscale atteso;
- classi `final` per i servizi di dominio, per impedirne l'estensione incontrollata e mantenere univoco il punto in cui un'operazione fiscale viene eseguita.

#tech-heading("Laravel", "../../img/logos/laravel.svg") <tec-laravel>

Framework PHP full-stack che fornisce l'ORM (`Eloquent`), il sistema di migrazioni, la gestione delle code e la validazione. Nel modulo fiscale è stato impiegato soprattutto per: le migrazioni che definiscono lo schema _append-only_ delle tabelle fiscali, con trigger a livello di database che impediscono operazioni di `UPDATE` e `DELETE`; i model `Eloquent` di titoli, abbonamenti, transazioni e stato del sistema certificato; l'integrazione con lo _scheduler_ dei task per le chiusure di giornata.

#tech-heading("Filament", "../../img/logos/filament.svg") <tec-filament>

Framework per la costruzione di pannelli amministrativi reattivi sopra Laravel. È lo strato con cui l'operatore di back-office interagisce: la pagina `EmissioneTitolo` (emissione e annullo dei titoli), l'interfaccia per gli abbonamenti e quella dei riepiloghi giornalieri sono tutte pagine Filament, costruite riusando i componenti già presenti nel pannello di RelAi per restare coerenti con il resto dell'applicazione.

#tech-heading("Livewire", "../../img/logos/livewire.svg") <tec-livewire>

Libreria che permette a Filament di aggiornare l'interfaccia via AJAX senza scrivere JavaScript dedicato in cui ogni pagina fiscale è di fatto un componente Livewire, con lo stato del form gestito lato server e sincronizzato nel browser.

#tech-heading("MariaDB", "../../img/logos/mariadb.svg") <tec-mariadb>

Sistema di gestione di basi di dati relazionali, adottato come unico storage del prototipo e già in uso in azienda con differenti tabelle riutilizzabili.
\ Le tabelle fiscali sono progettate per essere _append-only_ — solo inserimento, mai modifica né cancellazione — tramite trigger SQL, per rispecchiare il vincolo di immodificabilità richiesto ad un sistema di emissione certificato.

#tech-heading("DDEV", "../../img/logos/ddev.svg") <tec-ddev>

Ambiente di sviluppo containerizzato (Docker) che fornisce web server, PHP, MariaDB e i servizi di supporto in locale, identico a quello usato dal resto del team di RelAi, così da poter eseguire la suite di test e il linting con gli stessi strumenti già in uso nel progetto ospitante.

#heading(level: 3, numbering: none, outlined: false)[
  #box(baseline: 15%, image("../../img/logos/pest.svg", height: 0.60cm)) #h(0.2em) #text(size: 0.5cm, weight: "bold")[Pest]
] <tec-pest>

Framework di testing, costruito sopra PHPUnit, con cui è stata scritta la suite di test del modulo fiscale ed ogni funzionalità è stata accompagnata da almeno un test automatico, secondo la convenzione già in uso nel progetto RelAi.

#tech-heading("Git", "../../img/logos/git.svg") <tec-git>

Sistema di controllo di versione utilizzato per tracciare lo sviluppo incrementale del prototipo: il lavoro di stage è confluito in un unico ramo dedicato, con commit atomici e descrittivi per ogni singola funzionalità. Il ramo è integrato nella pipeline di integrazione continua già attiva sul progetto ospitante, che esegue formattazione del codice, analisi statica e suite di test ad ogni operazione di push.

== Ciclo di vita del software <ciclo-vita-software>

Lo sviluppo del prototipo ha seguito un modello iterativo e incrementale scandito dagli obiettivi dello stage. Ogni obiettivo è stato scomposto in funzionalità più piccole, implementate una alla volta e integrate immediatamente nel ramo di lavoro, ciascuna accompagnata dal relativo test automatico prima di passare alla successiva.

L'ordine seguito è stato il seguente: prima il modello dati e la simulazione della carta di attivazione (#link(<uc-carta>)[UC-3]); poi il motore di emissione dei titoli (#link(<uc-emissione>)[UC-4]); poi la catena di hash per l'integrità delle transazioni; poi la chiusura di giornata (#link(<uc-chiusura>)[UC-6]); poi i tracciati di esportazione, nei due formati ASCII a campi fissi e XML; infine i riepiloghi e le funzioni di servizio, come la ricerca per sigillo o per carta e progressivo (#link(<uc-riepiloghi>)[UC-7]). L'ordine non è arbitrario: ricalca la stessa dipendenza funzionale già individuata nella pianificazione settimanale (sezione #link(<organizzazione-lavoro>)[3.2]), per cui il log registra i movimenti prodotti dall'emissione e i riepiloghi leggono movimenti che devono già esistere nel log.

Questo approccio ha permesso di validare ogni blocco con un riscontro concreto — il test che passa, la pagina che si apre nel pannello — prima di costruirvi sopra il blocco successivo, riducendo il rischio di dover tornare indietro su assunzioni sbagliate quando il dominio normativo presentava ambiguità o dettagli scoperti solo durante l'implementazione, come nel caso discusso a proposito del #link(<risk-interpretazione-normativa>)[rischio 2] del Capitolo 3.

== Progettazione <progettazione>

Il modulo fiscale è organizzato in un namespace dedicato, `App\Fiscal`, separato dal resto dell'applicazione RelAi, con una struttura a sotto-namespace per responsabilità, riassunta nella tabella seguente e descritta nelle sezioni successive.

#table(
  columns: (4.75cm, 1fr),
  inset: 7pt,
  stroke: 0.5pt + rgb("b8b8bd"),
  fill: (_, row) => if calc.odd(row) { rgb("f5f5f7") } else { white },
  table.header([*Namespace*], [*Responsabilità*]),
  [`App\Fiscal\Models`], [Stato persistente del sistema: sistema certificato, carta di attivazione, titoli, abbonamenti, transazioni, annullamenti.],
  [`App\Fiscal\Support`], [Servizi di dominio: emissione, annullo, macchina a stati del sistema certificato, scrittura idempotente, chiusura di segmento di log.],
  [`App\Fiscal\Support\ Tracciato`], [Costruttori dei tracciati di esportazione ASCII e XML e relativa validazione contro il DTD 2019.],
  [`App\Fiscal\Enums`], [Tabelle normative codificate come enum tipizzati.],
) <tab-namespace-fiscal>

=== `App\Fiscal\Models` <namespace-models>

Contiene i model `Eloquent` che rappresentano lo stato persistente del sistema: il sistema certificato (`CertifiedSystem`), la carta di attivazione (`ActivationCard`), lo stato corrente del motore fiscale (`FiscalCoreState`), i comandi e le transazioni fiscali (`FiscalCommand`, `FiscalTransaction`), i titoli e le loro componenti di importo (`Title`, `TitleAmountComponent`), gli abbonamenti (`Subscription`, `SubscriptionEntitlement`) e gli annullamenti (`Cancellation`). Le tabelle sottostanti sono progettate come _append-only_, con trigger di database che impediscono `UPDATE` e `DELETE` una volta scritta una riga, in modo da realizzare il requisito A4 (#link(<tab-gruppo-a>)[gruppo A]).

=== `App\Fiscal\Support` <namespace-support>

Contiene i servizi di dominio che implementano la logica applicativa: `TitleIssuer` (emissione di un titolo, #link(<uc-emissione>)[UC-4]), `SubscriptionIssuer` (emissione di un abbonamento), `CancellationIssuer` (annullamento, #link(<uc-annullo>)[UC-5]), `SystemStateMachine` (transizioni di stato del sistema certificato, #link(<uc-carta>)[UC-3]), `FiscalWriter` (scrittura idempotente delle transazioni fiscali), `FiscalLogSegmentCloser` (chiusura di un segmento di log con firma simulata, #link(<uc-chiusura>)[UC-6]), `CardSimulator` (simulazione della carta di attivazione) e `FiscalEnvironment` (configurazione dell'ambiente fiscale).

=== `App\Fiscal\Support\Tracciato` <namespace-tracciato>

Contiene i costruttori dei formati di esportazione richiesti dalla normativa: i record a campi fissi in formato ASCII (`HeaderRecordBuilder`, `TitleRecordBuilder`, `DailySummaryDocumentBuilder`, `EventRecordBuilder`, `EventDailySummaryBuilder`), il formattatore condiviso dei campi (`FixedWidthFormatter`, si veda il listato più avanti) e il tracciato alternativo in XML con relativa validazione contro il DTD 2019 (`TitleXmlBuilder`, `TitleXmlValidator`).

=== `App\Fiscal\Enums` <namespace-enums>

Contiene gli enum tipizzati che codificano le tabelle normative: `TitleTypeCode` (tipi di titolo, con metodi come `requiresCause()` per sapere se un tipo richiede obbligatoriamente una causale) e `CancellationCauseCode` (causali di annullamento, #link(<tab-causali>)[tabella delle causali]). Rappresentare queste tabelle come enum, invece che come stringhe libere o costanti sparse, fa sì che un valore non previsto dalla normativa sia un errore individuabile già in fase di analisi statica, non solo a runtime.

Lo strato di presentazione — la pagina Filament `App\Filament\Pages\EmissioneTitolo` e le pagine analoghe per abbonamenti e riepiloghi — resta volutamente sottile: raccoglie l'input dell'operatore e lo passa ai servizi di `App\Fiscal\Support`, senza contenere essa stessa la logica fiscale, nella stessa separazione tra backend e frontend già adottata nel resto dell'applicazione RelAi.

== Design Pattern utilizzati <design-pattern>

L'architettura del modulo fiscale fa ricorso a diversi design pattern, scelti per rispondere ai vincoli imposti dalla normativa — immodificabilità dei dati, integrità del log, idempotenza delle scritture — più che per esigenze stilistiche. Di seguito vengono analizzati i principali, con riferimento al punto del codice in cui sono applicati.

=== Domain Service (Service Layer) <pattern-domain-service>

Ogni operazione fiscale rilevante — emettere un titolo, emettere un abbonamento, annullare, chiudere un segmento di log — è incapsulata in una classe `final` dedicata (`TitleIssuer`, `SubscriptionIssuer`, `CancellationIssuer`, `FiscalLogSegmentCloser`) con un unico metodo pubblico che esegue l'intera operazione in modo atomico, piuttosto che distribuire la logica tra model e pagina Filament.

=== State machine con locking ottimistico <pattern-state-machine>

`SystemStateMachine` modella gli stati del sistema certificato (bloccato, pronto, ecc., #link(<uc-carta>)[UC-3]) e ne gestisce le transizioni con un numero di versione: la scrittura della nuova riga di stato avviene con un `UPDATE ... WHERE version = ?`, e se nessuna riga viene aggiornata — perché un'altra richiesta ha già cambiato lo stato — l'operazione fallisce esplicitamente invece di sovrascrivere silenziosamente un cambiamento concorrente. È lo stesso meccanismo richiamato a proposito del #link(<risk-concorrenza>)[rischio 3] nel Capitolo 3, ed è tra i punti coperti dai test di concorrenza.

=== Idempotenza tramite chiave di richiesta <pattern-idempotenza>

`FiscalWriter` accetta una chiave di idempotenza per ogni comando fiscale: se la stessa richiesta viene inviata due volte, per esempio a seguito di un _retry_ di rete, la seconda esecuzione ritrova la transazione già scritta invece di duplicarla. Il pattern è necessario perché le tabelle fiscali sono _append-only_ e non possono essere corrette a posteriori.

=== Catena di hash (tamper-evident log) <pattern-hash-chain>

Le transazioni di un segmento di log sono collegate da un'impronta calcolata anche sull'hash della transazione precedente, così che un'alterazione o una rimozione di una riga rompa la catena per tutte le righe successive. È la tecnica con cui i registratori telematici garantiscono l'integrità del giornale di fondo, e nel prototipo realizza il requisito E3 (#link(<tab-gruppo-e>)[gruppo E]).

=== Builder <pattern-builder>

La generazione dei tracciati di esportazione — record ASCII a campi fissi, documento XML — è delegata a classi builder dedicate per ciascun tipo di record (`HeaderRecordBuilder`, `TitleRecordBuilder`, `DailySummaryDocumentBuilder`, `TitleXmlBuilder`), ciascuna responsabile di assemblare un solo tipo di output a partire dai model di dominio, con la formattazione dei singoli campi centralizzata in `FixedWidthFormatter` (metodi statici `alfa()`, `num()`, `data()`, `ora()` per i quattro formati di campo previsti dal tracciato, si veda il listato più avanti).

=== Enum tipizzato come tabella di lookup <pattern-enum-lookup>

`TitleTypeCode` e `CancellationCauseCode` sostituiscono le tabelle di codici della normativa con enum PHP dotati di metodi propri, per esempio `requiresCause()`, eliminando la necessità di tabelle di database separate per valori che non cambiano a runtime.

=== Validazione a schema esterno <pattern-validazione-schema>

`TitleXmlValidator` convalida l'XML generato contro il DTD ufficiale (versione 2019), separando la responsabilità di costruire il documento (`TitleXmlBuilder`) da quella di verificarne la conformità (`TitleXmlValidator`).

== Codifica <codifica>

Il blocco seguente riporta il formattatore condiviso dei campi a larghezza fissa, usato da tutti i builder del tracciato ASCII per produrre record conformi alle specifiche AdE/SIAE: un valore numerico viene allineato a destra e riempito di zeri fino alla larghezza prevista dal campo, mentre un valore che eccede la larghezza massima genera un'eccezione invece di essere troncato silenziosamente, per evitare che un dato fiscale venga scritto in forma incompleta.

#figure(```php
final class FixedWidthFormatter
{
    // Campo numerico allineato a destra, riempito di zeri
    public static function num(int|string $value, int $width): string
    {
        $valore = (string) $value;

        if (strlen($valore) > $width) {
            throw new InvalidArgumentException(
                "Il valore numerico '$valore' supera la larghezza massima di $width caratteri."
            );
        }

        return str_pad($valore, $width, '0', STR_PAD_LEFT);
    }
}
```, caption: [Formattatore condiviso dei campi a larghezza fissa del tracciato ASCII.], kind: raw) <listing-fixedwidthformatter>
