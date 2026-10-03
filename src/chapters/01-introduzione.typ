#import "shared.typ": *

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
