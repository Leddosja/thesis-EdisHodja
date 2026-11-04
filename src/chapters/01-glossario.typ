#import "shared.typ": *

#pagebreak()

#heading(outlined: false)[Glossario] <glossario> \

#block[
  #set par(first-line-indent: 0pt, justify: true)
  #set terms(hanging-indent: 2em, spacing: 2em)

  / Abbonamento: titolo che dà diritto a più ingressi su un insieme di eventi, abilitato a turno libero, quando il titolare sceglie quali prestazioni usare, o a turno fisso, quando le prestazioni sono prestabilite e il relativo importo è ripartito in ratei. Un abbonamento open è registrato con lo stesso meccanismo ma con un solo evento abilitato e turno libero.

  / AdE: Agenzia delle Entrate. Insieme alla SIAE, è l'ente che definisce i requisiti normativi a cui devono conformarsi i sistemi di biglietteria automatizzata per la vendita di titoli di accesso.

  / API: _Application Programming Interface_. Insieme di procedure messe a disposizione di un programma per permettere la comunicazione con altri sistemi; nel prototipo è lo strumento con cui il CRM RelAi e lo storefront interrogano i servizi di emissione e controllo accessi.

  / Append-only: proprietà di una tabella del database il cui contenuto può essere soltanto aggiunto e mai modificato o cancellato, imposta tramite trigger; è il modello adottato per il log delle transazioni e per i record di annullo.

  / Back-office: interfaccia web riservata agli operatori autorizzati, utilizzata per la gestione delle anagrafiche di organizzatori, locali ed eventi e per le operazioni di emissione e annullo dei titoli.

  / CAPTCHA: test automatico proposto all'utente prima della composizione del carrello, impiegato per distinguere un accesso umano da uno effettuato tramite software automatizzato.

  / Carta di attivazione: dispositivo, nel prototipo simulato, che custodisce il PIN, i contatori dei movimenti, il progressivo e il sigillo fiscale; il sistema blocca tutte le funzioni di emissione e annullo in assenza di una carta valida.

  / Causale di annullo: codice, scelto tra i dieci previsti dalla documentazione normativa (da 001 a 010), che motiva l'annullamento di un titolo o di un abbonamento; è obbligatorio per ogni annullo e determina il termine entro cui l'operazione resta ammessa.

  / Chiave di idempotenza: identificativo univoco associato a un'operazione di scrittura, utilizzato dal writer serializzato per riconoscere ed evitare la duplicazione di un movimento già registrato in caso di richieste ripetute.

  / CRM: _Customer Relationship Management_. Sistema software per la gestione delle relazioni con organizzatori e clienti; nel progetto è rappresentato da RelAi, con cui il prototipo deve integrarsi.

  / Giornata fiscale: periodo durante il quale i movimenti di emissione e annullo restano aperti sullo stesso segmento del giornale fiscale, fino alla chiusura che ne genera il riepilogo; non coincide necessariamente con la giornata di calendario, perché un evento può attraversare la mezzanotte.

  / Impronta (digest): valore calcolato a partire dal contenuto di un movimento e dall'impronta del movimento precedente, usato per concatenare i record di un segmento in una catena verificabile: un'alterazione di un record già scritto si manifesta come una mancata corrispondenza nel record successivo. Si distingue dal sigillo fiscale, che autentica un singolo titolo o movimento anziché collegarlo ai precedenti.

  / Lock di riga: meccanismo del database che blocca temporaneamente una riga durante una transazione, impiegato per far rispettare in modo concorrente vincoli come il limite di dieci titoli per evento e utente.

  / Locking ottimistico: tecnica di controllo della concorrenza che permette un aggiornamento solo se il dato non è stato modificato da un'altra richiesta nel frattempo, verificato confrontando un numero di versione; nel prototipo protegge lo stato del sistema certificato, a differenza del lock di riga, che serializza l'accesso a un vincolo condiviso tra più richieste.

  / Multi-tenant: architettura software in cui una singola installazione serve più organizzatori, detti tenant, mantenendone isolati dati, configurazione e dominio di vendita.

  / OTP: _One-Time Password_. Codice a validità limitata nel tempo, inviato al cellulare dell'utente e impiegato come doppio riscontro in fase di registrazione.
  \
  / Perimetro fiscale: insieme dei componenti del sistema soggetti direttamente agli obblighi normativi AdE/SIAE, quali la carta di attivazione, l'emissione, l'annullo, il log delle transazioni e i riepiloghi, distinto dai servizi non fiscali.

  / Progressivo: contatore tenuto a bordo della carta di attivazione, incrementato a ogni emissione o annullo e usato, insieme al codice della carta, per calcolare il sigillo fiscale e per identificare univocamente un movimento in fase di ricerca.

  / Record: unità elementare del tracciato e del giornale fiscale, corrispondente a un singolo movimento — un'emissione, un annullo o una registrazione di abbonamento; ciascun record porta il proprio progressivo e il proprio sigillo, ed è l'elemento che la catena delle impronte collega al precedente.

  / RelAi: CRM aziendale di Spazio Dev S.r.l. con cui il prototipo di biglietteria si integra, sincronizzando organizzatori ed eventi e restituendo i dati di vendita e di presenza.

  / Riepilogo: documento che aggrega i movimenti di una giornata fiscale, riepilogo giornaliero, o di un mese, riepilogo mensile, con proventi per evento, abbonamenti e ingressi per tipologia.

  / SIAE: Società Italiana degli Autori ed Editori. Ente che, con l'Agenzia delle Entrate, stabilisce i requisiti tecnici e normativi per i sistemi di biglietteria automatizzata e per il relativo controllo accessi.

  / Sigillo fiscale: codice alfanumerico generato dalla carta di attivazione, nel prototipo dichiaratamente simulato, che certifica l'autenticità di un titolo o di un segmento del log delle transazioni.

  / Sistema certificato: l'istanza del sistema di emissione a cui sono associati la carta di attivazione, lo stato operativo e i segmenti del giornale fiscale; un movimento sigillato da una carta si registra solo nel sistema certificato che la ospita.
  \ \ 
  / SPID: Sistema Pubblico di Identità Digitale. Sistema italiano di autenticazione digitale, nel prototipo simulato, previsto come modalità di accesso alternativa in fase di registrazione.

  / Storefront: interfaccia web rivolta al pubblico, personalizzata per dominio in modalità _white-label_, attraverso cui gli utenti consultano gli eventi e acquistano i titoli di accesso.

  / Supporto immodificabile: dispositivo di memorizzazione, nel prototipo simulato, su cui viene scritto il risultato della chiusura di un segmento del giornale fiscale, in modo che il dato firmato non possa più essere alterato dopo la scrittura.

  / Tenant: organizzatore che utilizza il sistema in modalità multi-tenant, con propria configurazione, dominio e catalogo di eventi isolato dagli altri organizzatori.

  / Titolo di accesso: documento, fisico o digitale, che attesta il diritto di ingresso a un evento o a un locale e che reca i dati obbligatori previsti dalla normativa di riferimento.

  / Titolo nominativo: titolo di accesso associato al nome e al cognome di un utente specifico, soggetto a vincoli particolari in caso di cambio nominativo o di rimessa in vendita.

  / Tracciato: rappresentazione di un record del log o di un riepilogo in uno dei due formati previsti dalla normativa, ASCII a campi fissi o XML; nel prototipo è prodotto da una classe builder dedicata per ciascun tipo di record.

  / Transazione serializzabile: livello di isolamento delle transazioni del database che garantisce un comportamento equivalente alla loro esecuzione in sequenza, impiegato per evitare condizioni di corsa sui vincoli condivisi tra i tenant.

  / White-label: modalità di distribuzione in cui l'aspetto grafico e il dominio del prodotto software sono personalizzati per il cliente che lo utilizza, mascherando il fornitore originario della piattaforma.

  / Writer serializzato: componente che garantisce la scrittura in sequenza, una alla volta, dei movimenti sulla carta di attivazione e sul log delle transazioni, impiegato insieme alla chiave di idempotenza per preservarne l'integrità.

  / DTD: _Document Type Definition_. Linguaggio utilizzato per definire la struttura e i vincoli di validità di un documento XML, meno espressivo dell'XSD; impiegato per validare i tracciati XML del log delle transazioni e dei riepiloghi.
]