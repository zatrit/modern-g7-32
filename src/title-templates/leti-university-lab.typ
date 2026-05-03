#import "../component/title.typ": approved-and-agreed-fields, detailed-sign-field, per-line
#import "../utils.typ": fetch-field, sign-field

#let arguments(..args) = {
  let args = args.named()

  args.manager = fetch-field(
    args.at("manager", default: none),
    ("title*", "name*"),
    hint: "руководителя",
  )

  args.performer = fetch-field(
    args.at("performer", default: none),
    ("title*", "name*"),
    hint: "исполнителя",
  )

  return args
}

#let sign-field(name: none, title: none) = {
  set par(justify: false)
  table(
    stroke: none,
    inset: (x: 0pt, y: 0pt),
    columns: (5fr, 1fr, 3fr, 1fr, 3fr),
    [#title], [], [], [], table.cell(align: bottom)[#name],
    table.hline(start: 2, end: 3),
    [], [],
  )
}

#let template(
  ministry: "МИНОБРНАУКИ РОССИИ",
  organization: "Санкт-Петербургский государственный электротехнический университет «ЛЭТИ» им. В.И. Ульянова (Ленина)",
  department: none,
  performer: (title: none, name: none),
  report-type: "Отчёт",
  about: none,
  discipline: none,
  part: none,
  bare-subject: false,
  research: none,
  subject: none,
  stage: none,
  manager: (title: none, name: none),
  text-size: (normal: none, small: none),
  title-footer-align: center,
  city: none,
  year: auto,
) = {
  set text(weight: "bold")

  per-line(
    indent: 0pt,
    ministry,
    (
      value: organization,
      when-present: organization,
    ),
    (
      value: [Кафедра #department],
      when-present: (department),
    ),
  )

  v(1fr)

  per-line(
    align: center,
    indent: 0.5fr,
    (value: upper(report-type), when-present: report-type),
    (value: about, when-present: about),
    (value: [по дисциплине: «#discipline»], when-present: discipline),
    (value: [Тема: #subject], when-present: subject),
  )

  set text(weight: "regular")

  v(0.75fr)

  if manager.name != none {
    sign-field(name: manager.at("name"), title: manager.at("title"))
  }

  if performer != none {
    sign-field(name: performer.at("name"), title: performer.at("title"))
  }

  linebreak()

  align(title-footer-align)[
    #city
    #linebreak()
    #year
  ]

  pagebreak()
}
