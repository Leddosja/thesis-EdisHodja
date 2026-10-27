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

#let tech-heading(name, logo) = heading(level: 3, numbering: none, outlined: false)[
  #box(baseline: 30%, image(logo, height: 0.85cm)) #h(0.2em) #text(size: 0.5cm, weight: "bold")[#name]
]

#let uc-diagram(path, caption-text: "Diagramma dei Casi d'Uso dell'intero sistema.") = {
  figure(
    image(path, width: 90%),
    caption: [#caption-text],
    kind: image,
    supplement: [Figura],
  )
}

#let usecase(id, title, actors, pre, description, post, alternative: none, diagram: none, 
requires: none, secondary: none) = {
  let level = if type(id) == int { 3 } else if id.split(".").len() > 2 { 5 } else { 4 }
  heading(level: level, numbering: none)[UC #id: #title]
  block(spacing: 1.2em)[
    #show list: set block(spacing: 0.65em)
    #show enum: set block(spacing: 0em)
    #if diagram != none [
      #v(0.5cm)
      #uc-diagram(diagram, caption-text: [Diagramma del caso d'uso UC#id.])
    ]
    \
    - *Attori principali:* #actors \
    #if secondary != none [
      - *Attori secondari* #secondary \
      ]
    - *Precondizioni:* #pre \
    - *Descrizione:* #description \
    - *Postcondizioni:* #post \
    #if requires != none [
      - *Dipendenze:* #requires \
    ]
    #if alternative != none [
      - *Scenario alternativo:* #alternative \
    ]
  ]
}

#let risk(number, title, description, solution, probabilita: none, impatto: none) = {
  block(spacing: 1.5em)[
    *#number. #title* \

    *Descrizione:* #description.

    *Soluzione:* #solution.
  ]
}

#let risk-table(rows, caption: none) = {
  let body = table(
    columns: (2cm, 7cm, 3.2cm, 2.75cm),
    inset: 10pt,
    stroke: 0.5pt + rgb("b8b8bd"),
    fill: (_, row) => if calc.odd(row) { rgb("f5f5f7") } else { white },
    table.header([*ID*], [*Rischio*], [*Probabilità*], [*Impatto*]),
    ..rows.flatten(),
  )
  if caption != none {
    figure(body, caption: caption, kind: table, supplement: [Tabella])
  } else {
    body
  }
}

#let requirement-table(rows, caption: none) = {
  let body = table(
    columns: (2.25cm, 1fr, 2.25cm),
    inset: 6pt,
    stroke: 0.5pt + rgb("b8b8bd"),
    fill: (_, row) => if calc.odd(row) { rgb("f5f5f7") } else { white },
    table.header([*Requisito*], [*Descrizione*], [*Use Case*]),
    ..rows.flatten(),
  )
  if caption != none {
    figure(body, caption: emph(caption), kind: table, supplement: [Tabella])
  } else {
    body
  }
}
