#import "../component/title.typ": approved-and-agreed-fields, detailed-sign-field, per-line
#import "../utils.typ": fetch-field, sign-field

#let arguments(..args) = {
  let args = args.named()

  args.manager = fetch-field(
    args.at("manager", default: none),
    ("title*", "name*"),
    hint: "руководителя",
  )

  let raw-performers = args.at("performers", default: args.at("performer", default: none))
  if raw-performers != none {
    if type(raw-performers) != array {
      raw-performers = (raw-performers,)
    }
    args.performers = raw-performers.map(p => fetch-field(
      p,
      ("title*", "name*"),
      hint: "исполнителя",
    ))
  } else {
    args.performers = ()
  }

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
  performer: none,
  performers: (),
  report-type: "Отчёт",
  about: none,
  discipline: none,
  subject: none,
  manager: (title: none, name: none),
  text-size: (normal: none, small: none),
  title-footer-align: center,
  city: none,
  year: auto,
  show-performers-page: false,
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

  let all-performers = if performers.len() > 0 {
    performers
  } else if performer != none {
    (performer,)
  } else {
    ()
  }

  for p in all-performers {
    sign-field(name: p.at("name", default: none), title: p.at("title", default: none))
  }

  if manager.name != none {
    sign-field(name: manager.at("name"), title: manager.at("title"))
  }

  linebreak()

  align(title-footer-align)[
    #city
    #linebreak()
    #year
  ]

  pagebreak()
}
