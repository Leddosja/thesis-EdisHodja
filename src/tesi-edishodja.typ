#set document(
  title: "Lorem ipsum dolor sit amet, consectetur adipisci elit.",
  author: "Edis Hodja",
  keywords: ("tesi", "informatica", "Università di Padova"),
)

#set page(
  paper: "a4",
  margin: (top: 2.75cm, bottom: 2.75cm, left: 3.75cm, right: 3cm),
  numbering: "i",
  number-align: center,
)
#set text(font: "New Computer Modern", size: 12pt, lang: "it")
#set par(justify: true, leading: 0.75em, first-line-indent: 1.25em)
#set heading(numbering: "1.1")
#set quote(block: true)
#set figure.caption(position: bottom)
#show figure.caption: set text(weight: "bold")

#let uni = [Università degli Studi di Padova]
#let department = [Dipartimento di Matematica "Tullio Levi-Civita"]
#let faculty = [Corso di Laurea in Informatica]
#let thesis-title = [Sviluppo di un prototipo di biglietteria automatizzata conforme alla normativa AdE/SIAE]
#let degree = [Tesi di Laurea]
#let supervisor = [Prof. Zanella Marco]
#let candidate = [Edis Hodja]
#let student-id = [2116422]
#let academic-year = [2025-2026]
#let location = [Padova]
#let date = [Ottobre 2026]

#let placeholder = [
  Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget
  dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes,
  nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis,
  sem. Nulla consequat massa quis enim.
]

#let usecase(id, title, actors, pre, description, post, alternative: none) = {
  block(spacing: 1em)[
    *UC #id: #title*
    \
    *Attori principali:* #actors \
    *Precondizioni:* #pre \
    *Descrizione:* #description \
    *Postcondizioni:* #post
    if alternative != none [\
      *Scenario alternativo:* #alternative
    ]
  ]
}

#let risk(number, title, description, solution) = {
  block(spacing: 0.75em)[
    *#number. #title* \
    *Descrizione:* #description. \
    *Soluzione:* #solution.
  ]
}

#let requirement-table(rows, caption: none) = {
  table(
    columns: (2.25cm, 1fr, 2.25cm),
    inset: 6pt,
    stroke: 0.5pt + rgb("b8b8bd"),
    fill: (_, row) => if calc.odd(row) { rgb("f5f5f7") } else { white },
    table.header([*Requisito*], [*Descrizione*], [*Use Case*]),
    ..rows.flatten(),
  )
  if caption != none {
    align(center)[#emph(caption)]
  }
}

// Frontespizio
#page(numbering: none)[
  #align(center)[
    #v(1.5cm)
    #text(size: 15pt, weight: "bold")[#uni]
    #v(5pt)
    #text(size: 13pt)[#smallcaps[#department]]
    #v(5pt)
    #text(size: 13pt)[#smallcaps[#faculty]]
    #v(1.25cm)
    #image("logo_unipd.jpeg", height: 6cm, alt: "Emblema dell'Universita degli Studi di Padova")
    #v(1cm)
    #text(size: 15pt, weight: "bold")[#thesis-title]
    #v(5pt)
    #text(size: 13pt, style: "italic")[#degree]
    #v(2cm)
    #grid(columns: (1fr, 1fr),
      align(left)[
        #emph[Relatore]\
        #supervisor
      ],
      align(right)[
        #emph[Laureando]\
        #candidate\
        Matricola #student-id
      ],
    )
    #v(1fr)
    #line(length: 100%)\
    #text(size: 11pt)[#smallcaps[Anno Accademico #academic-year]]
  ]
]

// Frontmatter
#page(numbering: none)[
  #v(1fr)
  #text(size: 9pt)[© #candidate, #date. Tutti i diritti riservati. #degree: "#thesis-title", #uni, #department, #faculty.]
]

#pagebreak()
/*
#align(right)[
  #emph["Colui il quale ha inseguito e sconfitto i demoni Sem, che ora vagano per il mondo, domandandosi: «ma nu, chi sem?»"]\
  #v(0.5em)
  --- Il grande Pdor, figlio di Kmer, della tribu di Ishtar, della terra desolata dei Kfnir, uno degli ultimi sette saggi: Pfulur, Galer, Astaparigna, Susar, Param, Fusus e Tarim.
]
#v(2em)
= Ringraziamenti <ringraziamenti>

Desidero esprimere la mia gratitudine al professor #supervisor, mio relatore, per l'aiuto e il sostegno che mi ha dato durante la stesura dell'elaborato.

Vorrei anche ringraziare, con affetto, i miei genitori per il loro sostegno, il grande aiuto e la loro presenza in ogni momento durante gli anni di studio.

Desidero poi ringraziare i miei amici per i bellissimi anni trascorsi insieme e le mille avventure vissute.

#v(1em)
#align(right)[#location, #date \\ #emph[#candidate]]
*/

#set heading(numbering: none)

= Sommario <sommario>

//Il presente documento descrive il lavoro svolto durante il periodo di stage 

#pagebreak()
= Ringraziamenti <ringraziamenti>

#pagebreak()
= Indice <indice>
#outline(title: none, depth: 5)

#pagebreak()
= Elenco delle figure <figure>
#outline(target: figure.where(kind: image), title: none)

#pagebreak()
= Elenco delle tabelle <tabelle>

#pagebreak()
#counter(page).update(1)
#set page(numbering: "1.")

= Introduzione <introduzione>

Introduzione al contesto applicativo.

Lorem.

Esempio di utilizzo di un termine nel glossario: _API_ (Application Program Interface).

Esempio di citazione direttamente nel testo: #link("http://agilemanifesto.org/iso/it/")[ _Manifesto Agile_ ].

Esempio di citazione nel pie di pagina #footnote[Womack e Jones, _Lean Thinking_].

#placeholder
#placeholder

== L'azienda
#placeholder

== L'idea
Introduzione all'idea dello stage #footnote[Einstein, Podolsky e Rosen, _Can Quantum-Mechanical Description of Physical Reality be Considered Complete?_].
#placeholder
#placeholder
#placeholder

== Organizzazione del testo

- *Il secondo capitolo* descrive i processi e le metodologie.
- *Il terzo capitolo* approfondisce la descrizione dello stage.
- *Il quarto capitolo* approfondisce l'analisi dei requisiti.
- *Il quinto capitolo* approfondisce progettazione e codifica.
- *Il sesto capitolo* approfondisce verifica e validazione.
- *Nel settimo capitolo* vengono descritte le conclusioni.

Riguardo la stesura del testo sono state adottate le seguenti convenzioni tipografiche:

- gli acronimi, le abbreviazioni e i termini ambigui vengono definiti nel glossario;
- per la prima occorrenza dei termini riportati nel glossario viene utilizzata la nomenclatura completa;
- i termini in lingua straniera o facenti parte del gergo tecnico sono evidenziati in _corsivo_.

#figure(
  ```c
  #include <stdio.h>
  int main() {
      print("Hello, world!");
      return 0;
  }
  ```
  , caption: [Example of code], kind: raw,
) <listing-a>

/*
#pagebreak()

= Processi e metodologie <processi-metodologie>

#placeholder

== Processo sviluppo prodotto
#placeholder
#placeholder

#figure(```c
#include <stdio.h>
int main() {
    print("Hello, world!");
    return 0;
}
```, caption: [Example of code], kind: raw) <listing-b>

Lorem ipsum:
#figure(```c
#include <stdio.h>
int main() {
    print("Hello, world!");
    return 0;
}
```, caption: [Example of code], kind: raw) <listing-b-2>

Lorem ipsum:
#figure(```c
#include <stdio.h>
int main() {
    print("Hello, world!");
    return 0;
}
```, caption: [Example of code], kind: raw) <listing-b-3>

#pagebreak()
= Descrizione dello stage <descrizione-stage>

#placeholder

== Analisi preventiva dei rischi

Durante la fase di analisi iniziale sono stati individuati alcuni possibili rischi a cui si potra andare incontro. Si e quindi proceduto a elaborare possibili soluzioni.

#risk(1, [Performance del simulatore hardware], [le performance del simulatore hardware e la comunicazione con questo potrebbero risultare lente o non abbastanza buone da causare il fallimento dei test], [coinvolgimento del responsabile del progetto relativo al simulatore hardware]) <risk-hardware-simulator>

== Requisiti e obiettivi

#requirement-table((
  ([AA], [BB], [AA]),
  ([AA], [BB], [AA]),
  ([AA], [BB], [AA]),
  ([AA], [BB], [AA]),
), caption: [Lorem.]) <tab-requisiti-obiettivi>

== Pianificazione
#placeholder

=== Subsection
#placeholder

==== Subsubsection
#placeholder

===== Paragraph
#placeholder

#pagebreak()
= Analisi dei requisiti <analisi-requisiti>

== Casi d'uso
Per lo studio dei casi di utilizzo del prodotto sono stati creati dei diagrammi. I diagrammi dei casi d'uso (_Use Case Diagram_) sono diagrammi di tipo _UML_ dedicati alla descrizione delle funzioni o servizi offerti da un sistema, cosi come sono percepiti dagli attori che interagiscono col sistema stesso.

#usecase(0, [Scenario principale], [Sviluppatore applicativi.], [Lo sviluppatore e entrato nel plugin di simulazione all'interno dell'IDE.], [La finestra di simulazione mette a disposizione i comandi per configurare, registrare o eseguire un test.], [Il sistema e pronto per permettere una nuova interazione.]) <uc-scenario-principale>

#usecase(1, [Gestione Utente], [Amministratore, Utente Registrato.], [L'utente deve essere autenticato nel sistema.], [L'utente puo gestire le informazioni del proprio profilo.], [Le modifiche vengono salvate nel sistema.], alternative: [Se l'utente non e autenticato, viene visualizzato un messaggio di errore.]) <uc-casi-uso>

#usecase(2, [Creazione Prodotto], [Amministratore.], [L'amministratore ha effettuato l'accesso al sistema.], [L'amministratore puo aggiungere un nuovo prodotto al catalogo.], [Il nuovo prodotto viene aggiunto con successo.], alternative: [Se i campi obbligatori non sono compilati, viene visualizzato un messaggio di errore.]) <uc-creazione-prodotto>

== Tracciamento dei requisiti
Da un'attenta analisi dei requisiti e degli use case effettuata sul progetto e stata stilata la tabella che traccia i requisiti in rapporto agli use case.

Il codice dei requisiti, dove ogni requisito e identificato con il carattere *R*, e cosi strutturato:

+ *F:* Funzionale.
+ *Q:* Qualitativo.
+ *V:* Di vincolo.
+ *N:* Obbligatorio (necessario).
+ *D:* Desiderabile.
+ *Z:* Opzionale.

Nelle tabelle seguenti sono riassunti i requisiti e il loro tracciamento con gli use case delineati in fase di analisi.

== Tabelle dei requisiti
#requirement-table((
  ([RFN-1], [L'interfaccia permette di configurare il tipo di sonde del test], [UC1]),
), caption: [Tabella del tracciamento dei requisiti funzionali.]) <tab-requisiti-funzionali>

#requirement-table((
  ([RQD-1n], [Le prestazioni del simulatore hardware devono garantire la giusta esecuzione dei test e non la generazione di falsi negativi], [-]),
  ([RQD-2n], [Le prestazioni del simulatore hardware devono essere monitorate durante l'esecuzione], [-]),
  ([RQD-3n], [Il sistema deve notificare eventuali anomalie], [-]),
), caption: [Tabella del tracciamento dei requisiti qualitativi.]) <tab-requisiti-qualitativi>

#requirement-table((
  ([RVO-1], [La libreria per l'esecuzione dei test automatici deve essere riutilizzabile], [-]),
), caption: [Tabella del tracciamento dei requisiti di vincolo.]) <tab-requisiti-vincolo>

#pagebreak()
= Progettazione e codifica <progettazione-codifica>

Breve introduzione al capitolo.

== Tecnologie e strumenti <tecnologie-strumenti>
Di seguito viene data una panoramica delle tecnologie e strumenti utilizzati.

=== Tecnologia 1
Descrizione Tecnologia 1.

=== Tecnologia 2
Descrizione Tecnologia 2.

== Ciclo di vita del software <ciclo-vita-software>

== Progettazione <progettazione>

=== Namespace 1
Descrizione namespace 1.

== Design Pattern utilizzati

== Codifica
Blocco di codice in C.
#figure(```c
#include <stdio.h>
int main() {
    print("Hello, world!");
    return 0;
}
```, caption: [Example of code], kind: raw) <listing-c>

#pagebreak()
= Verifica e validazione <verifica-validazione>

#placeholder
#placeholder

Esempio di importazione di un file contenente codice:
#figure(```python
# Il contenuto di code/example.py viene riportato qui per mantenere il file Typst autonomo.
def recur_fibo(n):
    if n <= 1:
        return n
    return recur_fibo(n - 1) + recur_fibo(n - 2)

nterms = 10
for i in range(nterms):
    print(recur_fibo(i))
```, caption: [Fibonacci recursive], kind: raw) <listing-py-fibo>

#placeholder

#pagebreak()
= Conclusioni <conclusioni>

== Consuntivo finale
Esempio di aggiunta di un termine con glossario e acronimo:

Lorem _SDK_ (Software Development Kit) ipsum dolor.

Nel successivo utilizzo apparira solo l'acronimo:

Lorem _SDK_.

Nel caso si voglia invece mettere solo il termine per esteso:

Lorem _Software Development Kit_.

== Raggiungimento degli obiettivi
Esempio di termine con solo acronimo: Lorem _TSA_, ipsum dolor sit amet.

Termine costruito senza acronimo: _Nome del termine_, ipsum dolor sit amet.

== Conoscenze acquisite
Lorem ipsum dolor, Lorem _API_.

Lorem ipsum dolor, Lorem _Application Program Interface_.

Si puo consultare la sezione Glossario per alcuni esempi di utilizzo.

== Valutazione personale


== Valutazione personale

#pagebreak()

// Bibliografia e sitografia, incluse direttamente nel file.
#set page(numbering: "i")
= Bibliografia <bibliografia>

== Testi

#v(0.5em)
[1] James P. Womack, Daniel T. Jones. _Lean Thinking, Second Edition_. Simon & Schuster, Inc., 2010.

== Articoli

#v(0.5em)
[2] Albert Einstein, Boris Podolsky, Nathan Rosen. _Can Quantum-Mechanical Description of Physical Reality be Considered Complete?_, Physical Review, 47(10), 777-780, 1935. DOI: `10.1103/PhysRev.47.777`.

= Sitografia <sitografia>

#v(0.5em)
[3] _Manifesto Agile_. #link("http://agilemanifesto.org/iso/it/")[http://agilemanifesto.org/iso/it/]
*/