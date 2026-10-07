#import "shared.typ": *

= Glossario <glossario> \

#block[
  #set par(first-line-indent: 0pt, justify: true)
  #set terms(hanging-indent: 2em, spacing: 2em)

  / AdE: Agenzia delle Entrate. Insieme alla SIAE, è l'ente che definisce i requisiti normativi a cui devono conformarsi i sistemi di biglietteria automatizzata per la vendita di titoli di accesso.

  / API: _Application Programming Interface_. Insieme di procedure messe a disposizione di un programma per permettere la comunicazione con altri sistemi; nel prototipo è lo strumento con cui il CRM RelAi e lo storefront interrogano i servizi di emissione e controllo accessi.

  / Append-only: proprietà di una tabella del database il cui contenuto può essere soltanto aggiunto e mai modificato o cancellato, imposta tramite trigger; è il modello adottato per il log delle transazioni e per i record di annullo.

  / Back-office: interfaccia web riservata agli operatori autorizzati, utilizzata per la gestione delle anagrafiche di organizzatori, locali ed eventi e per le operazioni di emissione e annullo dei titoli.

  / CAPTCHA: test automatico proposto all'utente prima della composizione del carrello, impiegato per distinguere un accesso umano da uno effettuato tramite software automatizzato.

  / Carta di attivazione: dispositivo, nel prototipo simulato, che custodisce il PIN, i contatori dei movimenti, il progressivo e il sigillo fiscale; il sistema blocca tutte le funzioni di emissione e annullo in assenza di una carta valida.

  / Chiave di idempotenza: identificativo univoco associato a un'operazione di scrittura, utilizzato dal writer serializzato per riconoscere ed evitare la duplicazione di un movimento già registrato in caso di richieste ripetute.

  / CRM: _Customer Relationship Management_. Sistema software per la gestione delle relazioni con organizzatori e clienti; nel progetto è rappresentato da RelAi, con cui il prototipo deve integrarsi.

  / Lock di riga: meccanismo del database che blocca temporaneamente una riga durante una transazione, impiegato per far rispettare in modo concorrente vincoli come il limite di dieci titoli per evento e utente.

  / Multi-tenant: architettura software in cui una singola installazione serve più organizzatori, detti tenant, mantenendone isolati dati, configurazione e dominio di vendita.

  / OTP: _One-Time Password_. Codice a validità limitata nel tempo, inviato al cellulare dell'utente e impiegato come doppio riscontro in fase di registrazione.

  / Perimetro fiscale: insieme dei componenti del sistema soggetti direttamente agli obblighi normativi AdE/SIAE, quali la carta di attivazione, l'emissione, l'annullo, il log delle transazioni e i riepiloghi, distinto dai servizi non fiscali.

  / Progressivo: numero sequenziale univoco assegnato dalla carta di attivazione a ciascun titolo emesso o annullato, utilizzato insieme al sigillo per la ricerca e la tracciabilità dei movimenti.

  / RelAi: CRM aziendale di Spazio Dev S.r.l. con cui il prototipo di biglietteria si integra, sincronizzando organizzatori ed eventi e restituendo i dati di vendita e di presenza.

  / Rimessa in vendita: procedura che consente al possessore di un titolo nominativo di renderlo nuovamente disponibile per l'acquisto attraverso il canale di vendita primario, con conseguente annullo del titolo originario.

  / Sigillo fiscale: codice alfanumerico generato dalla carta di attivazione, nel prototipo dichiaratamente simulato, che certifica l'autenticità di un titolo o di un segmento del log delle transazioni.

  / SIAE: Società Italiana degli Autori ed Editori. Ente che, con l'Agenzia delle Entrate, stabilisce i requisiti tecnici e normativi per i sistemi di biglietteria automatizzata e per il relativo controllo accessi.

  / SPID: Sistema Pubblico di Identità Digitale. Sistema italiano di autenticazione digitale, nel prototipo simulato, previsto come modalità di accesso alternativa in fase di registrazione.

  / Storefront: interfaccia web rivolta al pubblico, personalizzata per dominio in modalità _white-label_, attraverso cui gli utenti consultano gli eventi e acquistano i titoli di accesso.

  / Supporto immodificabile: mezzo di conservazione dei dati fiscali, nel prototipo simulato, che garantisce la non alterabilità dei segmenti di log già chiusi e firmati, verificata tramite digest.

  / Tenant: organizzatore che utilizza il sistema in modalità multi-tenant, con propria configurazione, dominio e catalogo di eventi isolato dagli altri organizzatori.

  / Titolo di accesso: documento, fisico o digitale, che attesta il diritto di ingresso a un evento o a un locale e che reca i dati obbligatori previsti dalla normativa di riferimento.

  / Titolo nominativo: titolo di accesso associato al nome e al cognome di un utente specifico, soggetto a vincoli particolari in caso di cambio nominativo o di rimessa in vendita.

  / Transazione serializzabile: livello di isolamento delle transazioni del database che garantisce un comportamento equivalente alla loro esecuzione in sequenza, impiegato per evitare condizioni di corsa sui vincoli condivisi tra i tenant.

  / White-label: modalità di distribuzione in cui l'aspetto grafico e il dominio del prodotto software sono personalizzati per il cliente che lo utilizza, mascherando il fornitore originario della piattaforma.

  / Writer serializzato: componente che garantisce la scrittura in sequenza, una alla volta, dei movimenti sulla carta di attivazione e sul log delle transazioni, impiegato insieme alla chiave di idempotenza per preservarne l'integrità.

  / XSD: _XML Schema Definition_. Linguaggio utilizzato per definire la struttura e i vincoli di validità di un documento XML, impiegato per validare i tracciati XML del log delle transazioni e dei riepiloghi.
]
