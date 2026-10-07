#set document(
  title: "Sviluppo di un prototipo di biglietteria automatizzata conforme alla normativa AdE/SIAE",
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
#set par(justify: true, leading: 0.8em, first-line-indent: 1.25em)
#set heading(numbering: "1.1")
#set quote(block: true)
#set figure.caption(position: bottom)
#show figure.caption: set text(weight: "bold")
#show heading: set text(size: 21pt)

#import "chapters/shared.typ": *

// Frontespizio
#page(numbering: none)[
  #align(center)[
    #v(1.5cm)
    #text(size: 15pt, weight: "bold")[#uni]
    #v(5pt)
    #text(size: 13pt)[#smallcaps[#department]]
    #v(5pt)
    #text(size: 13pt)[#smallcaps[#facoltà]]
    #v(1.25cm)
    #image("../img/logo_unipd.jpeg", height: 6cm, alt: "Emblema dell'Universita degli Studi di Padova")
    #v(1cm)
    #text(size: 15pt, weight: "bold")[#titolo]
    #v(5pt)
    #text(size: 13pt, style: "italic")[#degree]
    #v(2cm)
    #grid(columns: (1fr, 1fr),
      align(left)[
        #emph[Relatore]\
        #relatore
      ],
      align(right)[
        #emph[Laureando]\
        #io\
        Matricola #matricola
      ],
    )
    #v(1fr)
    #line(length: 100%)\
    #text(size: 11pt)[#smallcaps[Anno Accademico #anno]]
  ]
]

// Frontmatter
#page(numbering: none)[
  #v(1fr)
  #text(size: 9pt)[© #io, #date. Tutti i diritti riservati. #degree: "#titolo", #uni, #department, #facoltà.]
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

Desidero esprimere la mia gratitudine al professor #relatore, mio relatore, per l'aiuto e il sostegno che mi ha dato durante la stesura dell'elaborato.

Vorrei anche ringraziare, con affetto, i miei genitori per il loro sostegno, il grande aiuto e la loro presenza in ogni momento durante gli anni di studio.

Desidero poi ringraziare i miei amici per i bellissimi anni trascorsi insieme e le mille avventure vissute.

#v(1em)
#align(right)[#location, #date \\ #emph[#io]]
*/

#pagebreak()
#set heading(numbering: none)

= Sommario <sommario>

Il presente documento descrive il lavoro svolto durante il periodo di stage dal laureando #io presso l'azienda #azienda, della durata di circa 300 ore, svolte nel periodo che intercorre dal 28 settembre 2026 al 20 novembre 2026. Lo stage ha per oggetto la realizzazione di un prototipo di sistema di biglietteria automatizzata per la vendita online di titoli di accesso per conto di organizzatori terzi, in modalità white-label, destinato a integrarsi con il CRM aziendale RelAi. Il sistema deve rispettare i requisiti stabiliti dalla normativa AdE/SIAE.

L'elaborato è stato redatto seguendo il piano di lavoro proposto dal tutor aziendale #tutor ed espone le procedure operative e metodologiche adoperate durante lo sviluppo del prodotto atteso. In particolare, descrive le modalità di apprendimento e di esecuzione delle attività, l'organizzazione del lavoro in settimane e il confronto periodico con il tutor, che comprende incontri settimanali e revisioni del codice.

Poiché la carta di attivazione, il sigillo fiscale e il supporto immodificabile sono simulati e il sistema non è oggetto di certificazione durante lo stage, il prototipo serve a dimostrare i flussi end-to-end e a costituire la base tecnica per lo sviluppo del sistema definitivo. Il lavoro comprende l'analisi dei requisiti normativi, la progettazione del modello dati su PostgreSQL, l'emissione e l'annullamento dei titoli, la generazione del log delle transazioni e dei riepiloghi, la vendita online e il controllo accessi, con la verifica dei risultati tramite test funzionali e di concorrenza.

/*
#pagebreak()
= Indice <indice>
#outline(title: none, depth: 5)

#pagebreak()
= Elenco delle figure <figure>
#outline(target: figure.where(kind: image), title: none)

#pagebreak()
= Elenco delle tabelle <tabelle>
*/

#pagebreak()
//#include "chapters/00-glossario.typ"

#pagebreak()
#counter(page).update(1)
#set page(numbering: "1.")

#include "chapters/01-introduzione.typ"
#include "chapters/02-processi-metodologie.typ"
#include "chapters/03-descrizione-stage.typ"
#include "chapters/04-analisi-requisiti.typ"
#include "chapters/05-progettazione-codifica.typ"
#include "chapters/06-verifica-validazione.typ"
#include "chapters/07-conclusioni.typ"
#include "chapters/08-bibliografia.typ"
