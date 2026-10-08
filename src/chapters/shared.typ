#let uni = [Università degli Studi di Padova]
#let department = [Dipartimento di Matematica "Tullio Levi-Civita"]
#let facoltà = [Corso di Laurea in Informatica]
#let titolo = [Sviluppo di un prototipo di biglietteria automatizzata conforme alla normativa AdE/SIAE]
#let degree = [Tesi di Laurea]
#let relatore = [Prof. Zanella Marco]
#let tutor = [Matteo Forzan]
#let io = [Edis Hodja]
#let matricola = [2116422]
#let anno = [2025-2026]
#let location = [Padova]
#let date = [Ottobre 2026]
#let azienda = [Spazio Dev S.r.l.]

#let placeholder = [
  Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget
  dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes,
  nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis,
  sem. Nulla consequat massa quis enim.
]

#let uc-diagram(path, caption-text: "Diagramma dei Casi d'Uso dell'intero sistema.") = {
  figure(
    image(path, width: 85%),
    caption: [#caption-text],
    kind: image,
    supplement: [Figura],
  )
}

#let usecase(id, title, actors, pre, description, post, alternative: none, diagram: none, requires: none) = {
  block(spacing: 2em)[
    #text(size: 0.5cm, weight: "bold")[UC #id: #title]
    \ \
    #if diagram != none [
      #uc-diagram(diagram, caption-text: [Diagramma del caso d'uso UC#id.])
    ]
    \
    - *Attori principali:* #actors \
    - *Precondizioni:* #pre \
    - *Descrizione:* #description \
    - *Postcondizioni:* #post \
    #if requires != none [
      - *Dipendenze:* #requires \
    ]
    - *Scenario alternativo:* #alternative

    #v(1em)
    #line(length: 100%, stroke: 0.5pt + luma(150))
  ]
}

#let risk(number, title, description, solution, probabilita: none, impatto: none) = {
  block(spacing: 1.5em)[
    *#number. #title* \

    *Descrizione:* #description.

    *Soluzione:* #solution.

    #if probabilita != none or impatto != none [
      #v(0.3em)
      #align(center)[
        #table(
          columns: (5cm, 5cm),
          inset: 5pt,
          align: center,
          stroke: 0.5pt + rgb("b8b8bd"),
          fill: (_, row) => if row == 0 { rgb("f5f5f7") } else { white },
          table.header([*Probabilità*], [*Impatto*]),
          [#probabilita], [#impatto],
        )
      ]
    ]
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
