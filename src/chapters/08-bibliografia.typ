#import "shared.typ": *

#let urlcolor = rgb("7a1f1f")

#let webref(entry, descr: none, url: none, label: none, visited: "27/10/2026") = block(above: 1.5em, below: 2em)[
  #set par(hanging-indent: 1.1em, leading: 0.65em)
  #sym.dash.em #h(0.25em) #emph(entry)#if descr != none [, #descr].
  #align(center)[#smallcaps[Url]: #link(url)[#text(fill: urlcolor)[#label]] #emph[(visitato il #visited)].]
]

#pagebreak()

// Bibliografia e sitografia, incluse direttamente nel file.
= Bibliografia <bibliografia>

/*
== Testi

#v(0.5em)
[1] James P. Womack, Daniel T. Jones. _Lean Thinking, Second Edition_. Simon & Schuster, Inc., 2010.

== Articoli

#v(0.5em)
[2] Albert Einstein, Boris Podolsky, Nathan Rosen. _Can Quantum-Mechanical Description of Physical Reality be Considered Complete?_, Physical Review, 47(10), 777-780, 1935. DOI: `10.1103/PhysRev.47.777`.
*/
#heading(level: 2, numbering: none)[Normativa] <normativa>

#webref([Ministero delle Finanze. Decreto Ministeriale 13 luglio 2000], descr: [recante le caratteristiche dei misuratori fiscali e dei titoli di accesso per spettacoli e altre attività di intrattenimento], url: "https://www.agenziaentrate.gov.it/portale/documents/20143/275244/Decreto+del+13+07+2000_DM+13+luglio+2000.pdf/c53eee61-57b8-3f33-ee15-dfb4c7b19dc7", label: [agenziaentrate.gov.it])

#webref([Agenzia delle Entrate. Provvedimento 23 luglio 2001], descr: [caratteristiche dei misuratori fiscali, contenuto e modalità di emissione dei titoli di accesso e trasmissione dei dati alla SIAE], url: "https://www.agenziaentrate.gov.it/portale/documents/20143/275244/Decreto+del+23+07+2001_Decreto+23+luglio+2001.pdf/fe239ae7-f9b2-6488-87d0-bb3ad42366ab", label: [agenziaentrate.gov.it])

#webref([Agenzia delle Entrate. Provvedimento 22 ottobre 2002], descr: [rilascio delle carte di attivazione dei sistemi di emissione dei titoli di accesso e riconoscimento di idoneità delle apparecchiature], url: "https://www.agenziaentrate.gov.it/portale/documents/20143/275244/Provvedimento+del+22+10+2002_Provvedimento+AE+22+ottobre+2002.pdf/6cc8cbd3-5243-c35f-52a8-4d90222bf9ab", label: [agenziaentrate.gov.it])

#webref([Agenzia delle Entrate. Certificazione dei sistemi per l'emissione dei titoli di accesso], descr: [checklist di verifica per la certificazione, 2 dicembre 2002], url: "https://www.agenziaentrate.gov.it/portale/documents/20143/274973/Certificazione+dei+sistemi+per+emissione+dei+titoli+di+accesso_certif_sistemi.pdf/439cfdd9-33b9-e55d-38ad-dee8afbd6da2", label: [agenziaentrate.gov.it])

#webref([Agenzia delle Entrate. Provvedimento 4 marzo 2008], descr: [controllo automatizzato degli accessi per i titoli emessi in forma digitale e trasmissione telematica dei riepiloghi], url: "https://www.agenziaentrate.gov.it/portale/documents/20143/275244/Provvedimento+del+04+03+2008_Provvedimento+AE+4+marzo+2008.pdf/615c1b16-403a-32e3-1946-64003ac72e93", label: [agenziaentrate.gov.it])

#webref([Agenzia delle Entrate. Provvedimento n. 223774 del 27 giugno 2019], descr: [misure attuative in materia di vendita o qualsiasi altra forma di collocamento di titoli di accesso], url: "https://www.agenziaentrate.gov.it/portale/documents/20143/1646898/Provvedimento+del+27+giugno+2019+secondary+ticketing.pdf/d72cb570-41b3-3c47-1bce-6aa4e98ef205", label: [agenziaentrate.gov.it])

#webref([Agenzia delle Entrate. Provvedimento n. 356768 del 25 settembre 2025], descr: [modifiche al provvedimento del Direttore dell'Agenzia delle Entrate n. 223774 del 27 giugno 2019], url: "https://www.agenziaentrate.gov.it/portale/documents/20143/9294995/provvedimento-del-25-settembre-2025.pdf/aee353e6-59da-0824-fdc0-ab3fedaae525", label: [agenziaentrate.gov.it])

/*
= Sitografia <sitografia>

#v(0.5em)
[3] _Manifesto Agile_. #link("http://agilemanifesto.org/iso/it/")[http://agilemanifesto.org/iso/it/]
*/
