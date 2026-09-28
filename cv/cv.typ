#import "@preview/cmarker:0.1.10": render

#let ink = rgb("#4a4a4a")
#let body-ink = rgb("#3a3a3a")
#let rule-ink = rgb("#bdbdbd")
#let slab = "Roboto Slab"
#let sans = "Open Sans"

#let md(s) = render(s.trim(), raw-typst: false, set-document-title: false)

// Page Zola ../content/cv.md : front matter YAML (champs du CV sous "extra"), puis le corps markdown
#let parts = read("../content/cv.md").split(regex("(?m)^---\s*$"))
#let meta = yaml(bytes(parts.at(1))).extra
#let body = parts.slice(2).join("---")

#set document(title: "CV — " + meta.nom, author: meta.nom)
#set page(
  paper: "a4",
  margin: 1.35cm,
  background: place(top + left, dx: 0.6cm, dy: 0.6cm,
    rect(width: 100% - 1.2cm, height: 100% - 1.2cm, stroke: 2.2pt + ink)),
)
#set text(font: sans, size: 9.2pt, fill: body-ink, lang: "fr")
#set par(leading: 0.5em, spacing: 0.5em)
#set list(indent: 0.4em, body-indent: 0.5em, spacing: 0.55em, marker: text(fill: ink, sym.bullet))
#show strong: set text(font: slab, fill: ink)

#let hrule = line(length: 100%, stroke: 0.6pt + rule-ink)

#let entry(left, content) = grid(
  columns: (2.4cm, 0.6pt, 1fr),
  column-gutter: 0.35cm,
  text(font: slab, weight: "bold", size: 8.8pt, fill: ink, left),
  line(angle: 90deg, length: 0.9em, stroke: 0.6pt + rule-ink),
  content,
)

// "### gauche | titre" suivi du contenu jusqu'au prochain ###
#let parse-entry(chunk) = {
  let lines = chunk.split("\n")
  let head = lines.first()
  let rest = lines.slice(1).join("\n").trim()
  let (left, title) = if head.contains("|") {
    let i = head.position("|")
    (head.slice(0, i).trim(), head.slice(i + 1).trim())
  } else { (head.trim(), none) }
  (left: left, title: title, rest: rest)
}

#let render-entry(e) = entry(e.left, {
  if e.title != none { md(e.title); if e.rest != "" { v(0.2em) } }
  if e.rest != "" { md(e.rest) }
})

#let render-section(chunk, last) = {
  let lines = chunk.split("\n")
  let title = lines.first().trim()
  let pieces = lines.slice(1).join("\n").split(regex("(?m)^### "))
  let intro = pieces.first().trim()
  let entries = pieces.slice(1).map(parse-entry)
  let gap = if entries.any(e => e.title != none) { 2.2em } else { 0.85em }

  v(0.5cm)
  grid(columns: (3.3cm, 1fr),
    text(font: slab, weight: "bold", size: 10pt, fill: ink, upper(title)),
    {
      set par(leading: 0.65em) if entries.len() == 0
      if intro != "" { md(intro) }
      if intro != "" and entries.len() > 0 { v(gap) }
      stack(spacing: gap, ..entries.map(render-entry))
    })
  if not last { v(0.5cm); hrule }
}

// En-tête
#v(0.1cm)
#text(font: slab, weight: "bold", size: 27pt, fill: ink, tracking: -0.3pt, meta.nom)
#v(-0.15cm)
#text(font: slab, size: 13pt, fill: ink, skew(ax: -12deg, meta.titre))
#v(0.5cm)

#let contact(label, value) = stack(spacing: 0.35em,
  text(font: slab, weight: "bold", size: 6.8pt, fill: ink, label + "."),
  text(size: 7pt, str(value)))
#let vsep = line(angle: 90deg, length: 1.7em, stroke: 0.6pt + rule-ink)
#let cells = meta.contact.map(c => contact(c.label, c.value))
#grid(columns: cells.len() * 2 - 1, column-gutter: 0.45cm, align: horizon,
  ..cells.intersperse(vsep))
#v(0.5cm)
#hrule

#let sections = body.split(regex("(?m)^## ")).slice(1)
#for (i, s) in sections.enumerate() {
  render-section(s, i == sections.len() - 1)
}
