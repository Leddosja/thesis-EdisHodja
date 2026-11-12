#import "shared.typ": *

#set raw(syntaxes: "../php-mini.sublime-syntax")

#let phpcode(body, caption: none) = {
  let listing = align(left, block(
    fill: rgb("f7f7f9"),
    stroke: 0.5pt + rgb("b8b8bd"),
    radius: 4pt,
    width: 100%,
    inset: 10pt,
    breakable: false,
  )[
    #show raw.where(block: true): it => {
      set text(font: "DejaVu Sans Mono", size: 8.5pt)
      set par(justify: false, first-line-indent: 0pt, leading: 1.85em)
      grid(
        columns: (1.4em, 1fr),
        column-gutter: 10pt,
        row-gutter: 4pt,
        ..it.lines.map(line => (
          align(right)[#text(fill: rgb("9a9aa5"), size: 8pt)[#line.number]],
          align(left)[#line.body],
        )).flatten()
      )
    }
    #body
  ])
  figure(listing, caption: caption, kind: raw, supplement: [Listato])
}

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

#let screenshot-frame(path) = block(
  fill: rgb("f7f7f9"),
  stroke: 0.75pt + rgb("b8b8bd"),
  radius: 6pt,
  inset: 10pt,
  width: 100%,
  breakable: false,
)[#image(path, width: 100%)]

#let screenshot-pair(path-left, caption-left, path-right, caption-right, pull-left: 2cm, pull-right: 2cm) = pad(left: -pull-left, right: -pull-right)[
  #grid(
    columns: (0.6fr, 0.6fr),
    column-gutter: 0.4cm,
    align: horizon,
    figure(screenshot-frame(path-left), caption: caption-left),
    figure(screenshot-frame(path-right), caption: caption-right),
  )
]

#pagebreak()
= Progettazione e codifica <progettazione-codifica>
#v(0.2cm)
Questo capitolo descrive come il prototipo è stato costruito: lo stack tecnologico adottato, l'architettura del modulo fiscale e l'ordine in cui è stata realizzata, i design pattern applicati ed un estratto della codifica.

== Tecnologie e strumenti <tecnologie-strumenti>
#v(0.2cm)
Di seguito viene data una panoramica delle tecnologie e degli strumenti utilizzati per la realizzazione del prototipo. Lo stack è quello già adottato da RelAi, l'applicazione ospitante con piattaforma CRM e loyalty #link(<gloss-multi-tenant>)[multi-tenant] di #azienda, in modo da integrare il modulo fiscale senza introdurre dipendenze aggiuntive né un ambiente di sviluppo separato da quello del resto del team.

#tech-heading("PHP", "../../img/logos/php.svg") <tec-php>

#link(<web-php>)[PHP] è il linguaggio di programmazione lato server su cui è costruita l'intera applicazione. La scelta non nasce da una necessità specifica del prototipo, ma dalla decisione aziendale di sviluppare la biglietteria fiscale all'interno del codebase già esistente di RelAi, per riutilizzarne l'infrastruttura (autenticazione, multi-tenant, pipeline di test e di integrazione continua). Tra le caratteristiche del linguaggio sfruttate nel prototipo:

- enum nativi con metodi propri, usati per codificare i tipi di titolo e le causali di annullamento secondo le tabelle del tracciato AdE/SIAE;
- promozione delle proprietà nel costruttore, per ridurre il codice ripetitivo nei model e nei servizi di dominio;
- dichiarazione esplicita dei tipi di ritorno e dei parametri, utile a individuare in anticipo un valore incoerente con il dato fiscale atteso;
- classi `final` per i servizi di dominio, per impedirne l'estensione incontrollata e mantenere univoco il punto in cui un'operazione fiscale viene eseguita.

#pagebreak()

#tech-heading("Laravel", "../../img/logos/laravel.svg") <tec-laravel>

#link(<web-laravel>)[Laravel] è il framework PHP full-stack che fornisce l'ORM (`Eloquent`), il sistema di migrazioni, la gestione delle code e la validazione. Nel modulo fiscale è stato impiegato soprattutto per: le migrazioni che definiscono lo schema _#link(<gloss-append-only>)[append-only]_ delle tabelle fiscali, con il vincolo imposto a livello applicativo contro operazioni di `UPDATE` e `DELETE`; i model `Eloquent` di titoli, abbonamenti, transazioni e stato del sistema certificato; l'integrazione con lo _scheduler_ dei task per le chiusure di giornata.

#tech-heading("Filament", "../../img/logos/filament.svg") <tec-filament>

#link(<web-filament>)[Filament] è il framework per la costruzione di pannelli amministrativi reattivi sopra Laravel. È lo strato con cui l'operatore di back-office interagisce: la pagina `EmissioneTitolo` (emissione e annullo dei titoli), l'interfaccia per gli abbonamenti e quella dei riepiloghi giornalieri sono tutte pagine Filament, costruite riusando i componenti già presenti nel pannello di RelAi per restare coerenti con il resto dell'applicazione.

#tech-heading("Livewire", "../../img/logos/livewire.svg") <tec-livewire>

#link(<web-livewire>)[Livewire] è la libreria che permette a Filament di aggiornare l'interfaccia via AJAX senza scrivere JavaScript dedicato in cui ogni pagina fiscale è di fatto un componente Livewire, con lo stato del form gestito lato server e sincronizzato nel browser.

#tech-heading("MariaDB", "../../img/logos/mariadb.svg") <tec-mariadb>

#link(<web-mariadb>)[MariaDB] è il sistema di gestione di basi di dati relazionali adottato come unico storage del prototipo e già in uso in azienda con differenti tabelle riutilizzabili.
\ Le tabelle fiscali sono progettate per essere _append-only_: ammettono solo l'inserimento di nuove righe, non la modifica né la cancellazione di quelle esistenti, per rispecchiare il vincolo di immodificabilità richiesto a un sistema di emissione certificato.
#pagebreak()
#tech-heading("DDEV", "../../img/logos/ddev.svg") <tec-ddev>

#link(<web-ddev>)[DDEV] è l'ambiente di sviluppo containerizzato (Docker) che fornisce web server, PHP, MariaDB e i servizi di supporto in locale, identico a quello usato dal resto del team di RelAi, così da poter eseguire la suite di test e il linting con gli stessi strumenti già in uso nel progetto ospitante.

#heading(level: 3, numbering: none, outlined: false)[
  #box(baseline: 15%, image("../../img/logos/pest.svg", height: 0.60cm)) #h(0.2em) #text(size: 0.5cm, weight: "bold")[Pest]
] <tec-pest>

#link(<web-pest>)[Pest] è il framework di testing, costruito sopra PHPUnit, con cui è stata scritta la suite di test del modulo fiscale ed ogni funzionalità è stata accompagnata da almeno un test automatico, secondo la convenzione già in uso nel progetto RelAi.

#tech-heading("Git", "../../img/logos/git.svg") <tec-git>

#link(<web-git>)[Git] è il sistema di controllo di versione utilizzato per tracciare lo sviluppo incrementale del prototipo: il lavoro di stage è confluito in un unico ramo dedicato, con commit atomici e descrittivi per ogni singola funzionalità. Il ramo è integrato nella pipeline di integrazione continua già attiva sul progetto ospitante, che esegue formattazione del codice, analisi statica e suite di test ad ogni operazione di push.

#pagebreak()
== Progettazione backend <progettazione-backend>

Il _backend_ riceve una richiesta, controlla se è lecita secondo le regole che il sistema deve rispettare, e solo se lo è la scrive in modo definitivo. È qui che la normativa diventa codice ed ogni articolo del #link(<dm2000>)[D.M. 2000] o dei provvedimenti AdE che impone un dato obbligatorio, un termine, un formato, si traduce in un controllo preciso in questa parte del sistema.

Il backend del prototipo vive in un namespace dedicato, `App\Fiscal` la cui struttura è mostrata di seguito, tenuto separato dal resto dell'applicazione RelAi.
#v(0.6cm)
#table(
  columns: (4.75cm, 1fr),
  inset: 7pt,
  stroke: 0.5pt + rgb("b8b8bd"),
  fill: (_, row) => if calc.odd(row) { rgb("f5f5f7") } else { white },
  table.header([*Namespace*], [*Responsabilità*]),
  [`App\Fiscal\Models`], [Stato persistente del sistema: sistema certificato, carta di attivazione, titoli, abbonamenti, transazioni, annullamenti.],
  [`App\Fiscal\Support`], [Servizi di dominio: emissione, annullo, macchina a stati del sistema certificato, scrittura idempotente, chiusura di segmento di log.],
  [`App\Fiscal\Support\ Tracciato`], [Costruttori dei tracciati di esportazione ASCII e XML e relativa validazione contro il #link(<gloss-dtd>)[DTD] 2019.],
  [`App\Fiscal\Enums`], [Tabelle normative codificate come enum tipizzati.],
) <tab-namespace-fiscal>
#v(0.6cm)
I sotto-namespace sono stati implementati seguendo un modello iterativo e incrementale: ogni blocco è stato realizzato, accompagnato dal relativo test automatico prima di passare al successivo.

Il log registra infatti i movimenti prodotti dall'emissione, e i riepiloghi leggono movimenti che devono già esistere nel log e costruire i blocchi in quest'ordine ha permesso di validare ciascuno con un riscontro concreto prima di costruire sopra il successivo, riducendo il rischio di dover tornare indietro su assunzioni sbagliate quando il dominio normativo presentava ambiguità scoperte solo durante l'implementazione.

/*=== Modello dei dati <modello-dati>
#v(1cm)
#figure(
  image("../../img/diagrams/er.png", width: 130%),
  caption: [Schema relazionale],
)*/

#pagebreak()
=== Meccanismi implementativi <meccanismi-implementativi>

La normativa impone una serie di vincoli: un dato non falsificabile, una richiesta che non va eseguita due volte, un log che non si può alterare senza lasciarne traccia, uno stato che resta coerente anche sotto richieste concorrenti. Nel backend questi vincoli diventano meccanismi precisi nel codice, e le righe seguenti ne isolano cinque, ciascuno nel punto esatto in cui agisce.
#v(0.5cm)

Ogni transazione porta un sigillo fiscale non falsificabile (#link(<uc-emissione>)[UC-4]), ottenuto concatenando i dati della transazione, applicando una funzione di hash e prendendone i primi sedici caratteri:

#phpcode(```php
public function calculateSeal(ActivationCard $card, string $fiscalDate, string $fiscalTime, int $amountCents, int $progressive): string
{
    $canonico = implode('|', [$card->card_code, $fiscalDate, $fiscalTime, $amountCents, $progressive]);
    return substr(hash('sha256', $canonico), 0, 16);
}
```, caption: [Calcolo del sigillo fiscale]) <listing-seal>

#v(1cm)

La _#link(<gloss-chiave-idempotenza>)[chiave di idempotenza]_ garantisce che una richiesta ripetuta, ad esempio un doppio click o un retry di rete, non venga eseguita due volte: se il comando è già noto, il backend non lo riscrive, ma restituisce l'esito della prima esecuzione.

#phpcode(```php
$comandoEsistente = FiscalCommand::query()
    ->where('system_id', $system->id)
    ->where('idempotency_key', $idempotencyKey)
    ->first();

if ($comandoEsistente !== null) {
    return match ($comandoEsistente->status) {
        'COMPLETED' => FiscalTransaction::findOrFail($comandoEsistente->result_fiscal_tx_id),
        'PENDING' => throw new RuntimeException("Il comando {$idempotencyKey} è già in corso."),
        'FAILED' => throw new RuntimeException("Il comando {$idempotencyKey} è già fallito: {$comandoEsistente->failure_code}"),
    };
}
```, caption: [Verifica della chiave di idempotenza]) <listing-idempotenza>

#v(1cm)
#pagebreak()
Ogni movimento porta anche l'impronta di quello precedente, così che un'alterazione di un record già scritto si manifesti come una mancata corrispondenza nel record successivo:
#v(1cm)
#phpcode(```php
$improntaPrecedente = $segmento->last_record_digest;

$transazione = FiscalTransaction::create([
    // ...
    'record_digest' => hash('sha256', $sigillo . $progressivo . $amountCents . $improntaPrecedente),
    'previous_record_digest' => $improntaPrecedente,
]);
```, caption: [Concatenazione dell'impronta del movimento precedente]) <listing-hash-chain>

#v(1cm)

Lo stato del sistema certificato deve restare consistente anche sotto accessi concorrenti (#link(<uc-carta>)[UC-3]) e il backend lo garantisce con un _optimistic locking_ sul campo `version` dove il cambio di stato controlla che nessun altro l'abbia già modificato nel frattempo, altrimenti rifiuta e chiede di rileggere lo stato.
#v(1cm)
#phpcode(```php
$righeAggiornate = DB::table('fiscal_core_states')
    ->where('system_id', $statoLetto->system_id)
    ->where('version', $statoLetto->version)
    ->update([/* ... */ 'version' => $statoLetto->version + 1]);

if ($righeAggiornate === 0) {
    throw new RuntimeException("Lo stato del sistema {$statoLetto->system_id} è cambiato nel frattempo: rileggilo e riprova.");
}
```, caption: [#link(<gloss-locking-ottimistico>)[Locking ottimistico] sul campo `version`]) <listing-locking>

#v(1cm)
#pagebreak()

Il valore fiscale di un titolo o di un movimento del log dipende dal fatto che, una volta scritto, non possa più essere alterato né cancellato fuori dal percorso previsto dal sistema. Il prototipo applica questo vincolo a livello di applicazione con un trait `Eloquent` condiviso da tutti i model dello stato persistente, che intercetta ogni tentativo di `UPDATE` o `DELETE` e lo blocca sollevando un'eccezione prima che raggiunga il database:
#v(1cm)
#phpcode(```php
protected static function bootIsAppendOnly(): void
{
    static::updating(function (self $model): void {
        throw new RuntimeException(static::class . ' è append-only: UPDATE non è ammesso.');
    });

    static::deleting(function (self $model): void {
        throw new RuntimeException(static::class . ' è append-only: DELETE non è ammesso.');
    });
}
```, caption: [Vincolo append-only sui model]) <listing-append-only>

#pagebreak()
== Progettazione frontend <progettazione-frontend>

Il prototipo deve rispondere a due esigenze diverse, affidate ai due attori: l'operatore di back-office, che gestisce eventi, titoli e abbonamenti per conto dell'organizzatore, e il cliente, che acquista un titolo sullo storefront online in modalità white-label.

Il frontend del prototipo riflette questa distinzione in due interfacce separate con un pannello riservato all'operatore e uno storefront pubblico rivolto al cliente entrambe limitate a raccogliere l'input e a passarlo ai servizi di dominio di `App\Fiscal\Support`, senza contenere esse stesse logica fiscale.

=== Pannello di back-office <frontend-backoffice>

Il back-office è un'unica pagina Filament, `EmissioneTitolo`, organizzata in schede, invece di tante pagine separate una per funzione: l'operatore passa dall'una all'altra senza mai lasciare la pagina, mentre Livewire sostituisce solo il contenuto interessato. La scelta riduce la navigazione a un solo punto di ingresso e tiene vicine funzioni che condividono lo stesso contesto, come lo stesso evento e lo stesso organizzatore, invece di separarle in risorse Filament indipendenti.

#table(
  columns: (4.75cm, 1fr),
  inset: 7pt,
  stroke: 0.5pt + rgb("b8b8bd"),
  fill: (_, row) => if calc.odd(row) { rgb("f5f5f7") } else { white },
  table.header([*Scheda*], [*Contenuto*]),
  [*Log titoli*], [Tabella dei titoli emessi, con le azioni di emissione, annullo e, sulla singola riga, cambio nominativo e rimessa in vendita su richiesta del cliente.],
  [*Abbonamenti*], [Emissione e annullo degli abbonamenti, con la stessa logica dei log titoli.],
  [*Riepiloghi*], [Consultazione dei riepiloghi giornalieri e mensili.],
  [*Trasmissioni*], [Trasmissione dei moduli previsti dalla normativa, pronti per l'invio all'Agenzia delle Entrate e comunicazione dei periodi di inattività.],
) <tab-pagine-filament>

Ciascuna scheda è stata realizzata solo dopo che il servizio di dominio corrispondente era già stato implementato e validato dal relativo test.

#pagebreak()
#v(1fr)
#heading(level: 4, numbering: none, outlined: false)[#text(size: 0.6cm, weight: "bold")[Log titoli]]
#v(0.4cm)
La #link(<fig-backoffice-log-titoli>)[figura seguente] mostra la scheda "Log titoli": sulla riga di un titolo valido, il menu delle azioni espone proprio "Cambia nominativo" e "Rimetti in vendita", le due operazioni su richiesta del cliente.

Le tre schede riassuntive in alto (titoli validi, titoli annullati, valore complessivo) permettono all'operatore di verificare lo stato del registro senza contare le righe della tabella sottostante e il pulsante "Emetti titolo" apre la stessa form del caso d'uso #link(<uc-emissione>)[UC-4]\; il pulsante "Annulla", disponibile su ogni riga di eventi non annullati o non passati, chiede invece la causale tra i dieci codici previsti dalla normativa, coerentemente con il #link(<uc-annullo>)[UC-5].
#v(1.2cm)
#screenshot("../../img/screenshots/log-titoli.png", caption: [Figura 1: Tab dei log dei titoli]) <fig-backoffice-log-titoli>
#v(1fr)

#pagebreak()
#v(1fr)
#heading(level: 4, numbering: none, outlined: false)[#text(size: 0.6cm, weight: "bold")[Riepiloghi]]
#v(0.4cm)
La #link(<fig-backoffice-riepiloghi>)[figura seguente] mostra la scheda "Riepiloghi": l'operatore seleziona una giornata e vede i titoli e gli abbonamenti emessi e annullati per ciascun evento, insieme ai proventi, e da qui scarica anche il documento di riepilogo e il modulo C.1, un'aggiunta richiesta dalla checklist di certificazione.

È possibile alternare la vista giornaliera e quella mensile mantenendo la stessa tabella dove ogni riga riporta un singolo evento, non un totale aggregato per giornata: un organizzatore con più eventi lo stesso giorno compare quindi su più righe distinte, una per evento, così che il riepilogo resti tracciabile fino al singolo evento invece di nascondere il dettaglio dietro una somma.
#v(1.2cm)
#screenshot("../../img/screenshots/riepiloghi.png", caption: [Figura 2: Tab dei riepiloghi giornalieri e mensili]) <fig-backoffice-riepiloghi>
#v(1fr)

#pagebreak()
#v(1fr)
#heading(level: 4, numbering: none, outlined: false)[#text(size: 0.6cm, weight: "bold")[Trasmissioni]]
#v(0.4cm)
La #link(<fig-backoffice-trasmissioni>)[figura seguente] mostra la scheda "Trasmissioni", che raccoglie due cose distinte che la normativa tratta separatamente: la comunicazione preventiva a SIAE dei periodi di inattività del sistema (simulata), e il giornale fiscale, un segmento per ogni giornata di attività. Per ogni segmento chiuso l'interfaccia mostra se la catena di impronte è integra, la stessa verifica descritta a proposito della catena di hash, ricostruendola in lettura invece di limitarsi a fidarsi del dato salvato.
#v(1.2cm)
#screenshot("../../img/screenshots/trasmissioni.png", caption: [Figura 3: Tab delle trasmissioni e giornale fiscale]) <fig-backoffice-trasmissioni>
#v(1fr)
#pagebreak()

=== Interfaccia di vendita online <frontend-storefront>

Il cliente interagisce con un componente Livewire a pagina intera, `TicketPurchase`, raggiungibile su `/biglietteria-fiscale/{event}` senza autenticazione preventiva, non con il pannello Filament riservato all'operatore. A differenza del back-office, qui ogni fase dell'acquisto è gestita come stato interno dello stesso componente: il cliente non sceglie liberamente tra schede, ma avanza in un unico ordine, dalla verifica del CAPTCHA ai dati anagrafici o SPID, dalla conferma del codice OTP alla scelta dei biglietti e al pagamento, fino alla conferma finale con generazione del codice QR allegato al biglietto.

#heading(level: 4, numbering: none, outlined: false)[#text(size: 0.6cm, weight: "bold")[Dati e biglietti]]
Le #link(<fig-storefront-dati-biglietti>)[due figure seguenti] mostrano queste schermate: il cliente si identifica con SPID simulato oppure con nome, cognome e telefono, e se l'utente non viene identificato vengono richiesti ulteriori dati per effettuare la registrazione; di seguito avviene la verifica via OTP e la scelta dei biglietti, dove il carrello è parte della stessa schermata e si aggiorna a ogni aggiunta mostrando il totale da pagare.
#v(0.5cm)
#screenshot-pair(
  "../../img/screenshots/dati.png", [Figura 4: Schermata di identificazione dell'utente],
  "../../img/screenshots/biglietti.png", [Figura 5: Schermata scelta dei biglietti disponibili],
  pull-left: 0.5cm, pull-right: 0.5cm,
) <fig-storefront-dati-biglietti>
#v(1fr)

#heading(level: 4, numbering: none, outlined: false)[#text(size: 0.6cm, weight: "bold")[Pagamento e biglietto emesso]]
#v(0.4cm)
Le #link(<fig-storefront-pagamento-biglietto>)[due figure seguenti] mostrano il pagamento e il biglietto emesso. Il pagamento è delegato a Stripe Checkout, che offre carta, Apple Pay, Satispay e il wallet Link; se non va a buon fine, nessun titolo viene emesso né scritto nel log. Confermato il pagamento, il titolo è consultabile tramite un link firmato da token, senza bisogno di login: la vista del biglietto con il codice QR da presentare al varco, lo stesso QR in formato immagine e il PDF stampabile, serviti da un controller pubblico separato dal componente Livewire.
#v(1.2cm)
#screenshot-pair(
  "../../img/screenshots/pagamento.png", [Figura 6: Schermata del pagamento],
  "../../img/screenshots/biglietto-emesso.png", [Figura 7: Schermata del biglietto con QR code],
) <fig-storefront-pagamento-biglietto>
#v(1.2cm)

#pagebreak()

=== Separazione tra presentazione e logica <frontend-pagina-servizio>

In entrambe le interfacce la pagina (o il componente) si limita a raccogliere e normalizzare l'input: la decisione se un'operazione è ammessa, e la sua esecuzione, spettano sempre al servizio di dominio sottostante.\ Non è una scelta di stile perché in un sistema di emissione certificato, verificare la conformità normativa si deve tradurre nel leggere un numero finito di classi in `App\Fiscal\Support`, non ogni schermata che può toccare un dato fiscale.

Sul pannello di back-office le azioni Filament risolvono sistema, carta e segmento attivi tramite `FiscalEnvironment` e delegano l'operazione al servizio corrispondente, come mostra l'annullo di un titolo:
#v(1cm)
#phpcode(```php
->action(function (Title $record, array $data): void
{
    try
    {
        [$sistema, $carta, $segmentoId] = app(FiscalEnvironment::class)->active();

        app(CancellationIssuer::class)->cancelTitle(
            system: $sistema,
            card: $carta,
            logSegmentId: $segmentoId,
            idempotencyKey: (string) Str::uuid(),
            originalTitle: $record,
            causeCode: $data['causale'],
            reasonText: $data['motivo'] ?? null,
            requestedByUserId: auth()->id(),
        );

        Notification::make()->title("Titolo #{$record->id} annullato")->success()->send();
    }
    catch (Throwable $errore)
    {
        Notification::make()->title('Annullo rifiutato')->body($errore->getMessage())->danger()->send();
    }
})
```, caption: [Azione Filament "Annulla"]) <listing-backoffice-delega>

#pagebreak()
La pagina non sa, e non deve sapere, quali causali escludano un titolo dall'annullo: quella regola vive in `CancellationIssuer`. Lo stesso schema regge l'emissione, il cambio nominativo, la rimessa in vendita e l'eliminazione, cambia solo il servizio invocato non la struttura della delega.\  Sullo storefront il principio è identico: `TicketPurchase` interroga `CaptchaVerifier`, `OtpChallenger`, `IdentifiedUserRegistrar`, `CartManager` e `PaymentEngine` a ogni passo del wizard, e si limita a reagire al loro esito aggiornando lo stato del componente, senza mai decidere da sé un importo o una capienza.

Le due interfacce convergono così sullo stesso strato di servizi e sullo stesso scrittore `FiscalWriter` che non distingue se la richiesta arriva dal pannello back-office o da un passo del checkout online, e questo garantisce che la regola fiscale sia applicata una sola volta, indipendentemente da quale delle due interfacce la invochi.

#pagebreak()

== Design Pattern <design-pattern>

Tre problemi si ripetono più volte nel modulo fiscale: costruire lo stesso oggetto in rappresentazioni diverse (un tracciato ASCII, un documento XML), nascondere dietro un'unica chiamata un'inizializzazione che coinvolge più classi correlate, e riconoscere un'operazione già eseguita invece di ripeterla. Le sezioni seguenti descrivono i tre design pattern del catalogo classico della progettazione orientata agli oggetti (#link(<gof>)[Gamma et al., 1994]) con cui il modulo fiscale (`App\Fiscal`) risponde a ciascun problema.

=== Builder <pattern-builder>

Il pattern creazionale *Builder* separa la costruzione di un oggetto complesso dalla sua rappresentazione finale. Ogni tipo di record del tracciato AdE/SIAE ha una classe builder dedicata, da `HeaderRecordBuilder` ai builder dei riepiloghi e dell'export XML. Ciascuna classe espone due metodi: 
- `fields()` restituisce l'elenco ordinato dei campi già formattati;
- `build()` li concatena nella stringa a lunghezza fissa. 
La formattazione dei singoli campi è centralizzata in `FixedWidthFormatter`, che non va riscritta in ogni builder.

I due metodi restano separati perché `fields()` viene usato anche altrove: la pagina `EmissioneTitolo` lo chiama direttamente per mostrare il tracciato in una tabella, senza passare dalla stringa concatenata prodotta da `build()`.\
Lo schema generico del pattern, nei ruoli Director/Builder/Product descritti a lezione, è riportato nella figura seguente.
#v(0.8cm)

#screenshot("../../img/patterns/builder.png", caption: [Figura 8: Diagramma del Pattern Builder]) <fig-pattern-builder>
#pagebreak()
=== Facade <pattern-facade>

Il pattern strutturale *Facade* fornisce un'interfaccia unica per un sottosistema composto da più parti correlate. `FiscalEnvironment::active()` svolge questo ruolo andando a risolvere in un'unica chiamata il sistema certificato attivo, la carta di attivazione associata, verifica e aggiorna lo stato della macchina a stati, chiude i segmenti di log rimasti aperti da giornate precedenti e apre quello del giorno corrente.

Il metodo nasconde cinque classi (`CertifiedSystem`, `ActivationCard`, `SystemStateMachine`, `FiscalLogSegment`, `FiscalLogSegmentCloser`) ed è chiamato così com'è da quattordici punti diversi del codice. Senza la facciata, ognuno di quei punti dovrebbe ripetere la stessa sequenza di cinque controlli, con il rischio di sbagliarne l'ordine.\
Lo schema generico del pattern, con il Client che vede solo la Facade e non i sottosistemi che essa orchestra, è riportato nella figura seguente.
#v(0.8cm)

#screenshot("../../img/patterns/facade.png", caption: [Figura 9: Diagramma del Pattern Facade]) <fig-pattern-facade>

#pagebreak()
=== Command <pattern-command>

Il pattern comportamentale *Command* incapsula una richiesta come oggetto, invece che come una semplice chiamata di metodo e questo permette di riconoscere se una richiesta è già stata eseguita. Ogni operazione fiscale passa attraverso `FiscalWriter::execute()` con un `commandType` che la identifica: `ISSUE_TITLE`, `ISSUE_SUBSCRIPTION`, `CANCEL_TITLE`, `CANCEL_SUBSCRIPTION`.\  Il comando è salvato come riga di `FiscalCommand`, con tipo, richiesta serializzata, impronta e stato (`PENDING`/`COMPLETED`/`FAILED`); è questa riga a decidere l'esito quando la stessa chiave di idempotenza arriva una seconda volta.\
 La classe `FiscalWriter` non sa cosa sia un titolo o un abbonamento ma riceve un comando generico e scrive una riga di `fiscal_transactions` all'interno del database.\
Lo schema generico del pattern, con l'Invoker disaccoppiato dai Client che costruiscono i comandi, è riportato nella figura seguente.
#v(0.8cm)

#screenshot("../../img/patterns/command.png", caption: [Figura 10: Diagramma del Pattern Command]) <fig-pattern-command>