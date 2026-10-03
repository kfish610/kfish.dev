// CV rendered from the JSON produced by `nix build .#cv-json`.
// Built by `nix build .#cv-pdf`, which passes the JSON as `--input data=...`.
// Otherwise it reads the copy the dev server generates, resolved from the
// project root (the repo), e.g. in `nix develop`:
//   typst watch --root . cv/cv.typ

#let data = json(sys.inputs.at("data", default: "/src/lib/generated/cv.json"))
#let person = data.person

// ---------- Style ----------

#let ink = rgb("#595959")
#let rule-color = rgb("#9a9a9a")
#let sidebar = rgb("#eeeeee")
#let link-color = rgb("#1155cc")
#let serif = "Roboto Slab"
#let sans = "Roboto"

#set document(title: person.name + " – Curriculum Vitae", author: person.name)
#set page(paper: "us-letter", margin: 0.75in)
#set text(font: sans, size: 10pt, fill: ink)
#set par(leading: 0.5em, spacing: 0.9em)
#set list(
  marker: text(size: 0.75em, baseline: -0.1em)[#sym.circle.filled],
  indent: 0.6em,
  body-indent: 0.7em,
  spacing: 0.65em,
)

#let skill-labels = (
  programming: "Programming",
  provers: "Theorem Provers",
)

// ---------- Data ----------

// Return the value at `key` in `d`, or `none` if it doesn't exist.
#let opt(d, key) = d.at(key, default: none)

// Flatten all entries in the CV into a single map from ID to entry
#let by-id = {
  let m = (:)
  for coll in ("education", "research", "work", "publications", "activities", "projects") {
    for e in data.at(coll).values() { m.insert(e.id, e) }
  }
  for group in data.skills.values() {
    for s in group.values() { m.insert(s.id, s) }
  }
  m
}

#let skill-category = {
  let m = (:)
  for (cat, group) in data.skills {
    for s in group.values() { m.insert(s.id, cat) }
  }
  m
}

#let months = (
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
)

// Convert a date string from "YYYY-MM" to "Month YYYY", or "Present" if the date is `none`.
#let fmt-date(s) = {
  if s == none { return "Present" }
  let (year, ..rest) = s.split("-")
  if rest.len() == 0 { year } else { months.at(int(rest.at(0)) - 1) + " " + year }
}

// Format a date range object
#let date-range(e) = fmt-date(e.startDate) + " – " + fmt-date(opt(e, "endDate"))

// Order events by end date (or start date if no end date), newest first.
#let newest-first(entries) = {
  entries
    .values()
    .sorted(key: e => {
      let end = opt(e, "endDate")
      (if end == none { "9999" } else { end }) + e.startDate
    })
    .rev()
}

// The first within entry of an entry (e.g. the university for a research lab)
#let parent(e) = if e.within.len() > 0 { by-id.at(e.within.at(0)) }

// ---------- Components ----------

// Build an icon from SVG path data
#let icon(paths) = box(baseline: 0.15em, image(
  bytes(
    "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' "
      + "stroke='"
      + ink.to-hex()
      + "' stroke-width='2' stroke-linecap='round' "
      + "stroke-linejoin='round'>"
      + paths
      + "</svg>",
  ),
  height: 1em,
))
#let mail-icon = icon(
  "<rect x='3' y='5' width='18' height='14' rx='1.5'/><path d='M3.5 6.5 12 13l8.5-6.5'/>",
)
#let link-icon = icon("<path d='M10 7H7a5 5 0 0 0 0 10h3M14 7h3a5 5 0 0 1 0 10h-3M8 12h8'/>")

// Show a link with an underline
#let ext-link(url, label) = link(url, underline(text(fill: link-color, label)))

// Roboto Slab has no small caps, so we imitate them here
#let smallcaps(s) = {
  s.split(" ").map(w => w.first() + text(size: 0.8em, upper(w.slice(1)))).join(" ")
}

// Create a section with a title and body
#let section(title, body) = {
  text(font: serif, size: 15pt, smallcaps(title))
  v(0.3em)
  body
}

#let divider = block(above: 1.5em, below: 1.5em, line(length: 100%, stroke: 0.5pt + rule-color))

// Join a list of sections with dividers between them
#let column(..sections) = sections.pos().join(divider)

// Format an entry (an item in a section)
#let entry(title, dates, role: none, bullets: ()) = block(above: 1.5em)[
  #text(font: serif, size: 10pt, title) \
  #text(size: 8.5pt, style: "italic", dates)
  #if role != none [\ #strong(role)]
  #if bullets.len() > 0 { block(above: 0.75em, list(..bullets)) }
]

// Format a highlight (a bullet point in an entry)
#let highlight(h) = {
  h.text
  for l in h.links [ [#ext-link(l.url, if opt(l, "label") != none { l.label } else { l.url })] ]
}

// ---------- Sections (Left Column) ----------

#let skills-section = section("Skills", {
  let groups = ()
  for id in person.skills {
    let cat = skill-category.at(id)
    let i = groups.position(g => g.at(0) == cat)
    if i == none {
      groups.push((cat, (by-id.at(id).name,)))
    } else {
      groups.at(i).at(1).push(by-id.at(id).name)
    }
  }
  list(
    ..groups
      .map(((cat, names)) => {
        let label = skill-labels.at(cat, default: none)
        if label == none { names } else { (label + ": " + names.join(", "),) }
      })
      .flatten(),
  )
})

#let education-section = section(
  "Education",
  newest-first(data.education)
    .map(e => {
      let degrees = e.degrees.map(d => {
        let c = opt(d, "concentration")
        d.degree + " " + d.field + if c != none { " (" + c.short + ")" }
      })
      let gpa = opt(e, "gpa")
      let distinctions = e.honors + if gpa != none { ("GPA " + str(gpa),) } else { () }
      let highlights = if distinctions.len() > 0 {
        degrees + (distinctions.join(", "),)
      } else {
        degrees
      }
      entry(e.name.long, date-range(e), bullets: highlights)
    })
    .join(),
)

#let activities-section = section(
  "Activities",
  newest-first(data.activities).map(a => entry(a.organization, date-range(a))).join(),
)

#let publications-section = section("Publications", {
  set text(size: 9pt)
  set par(leading: 0.75em)
  data
    .publications
    .values()
    .sorted(key: p => p.date)
    .rev()
    .map(p => [
      #strong(p.title + ".") \
      #p.authors.map(a => if a == person.name { emph(a) } else { a }).join(", ") \
      #p.venue #fmt-date(p.date).
      #if p.awards.len() > 0 { emph(p.awards.join(", ") + ".") }
    ])
    .join()
})

#let left = (skills-section, education-section, activities-section, publications-section)

// ---------- Sections (Right Column) ----------

#let summary-section = section("Summary", {
  set par(leading: 1em)
  person.summary.short
})

#let research-section = section(
  "Research Experience",
  newest-first(data.research)
    .map(r => {
      let p = parent(r)
      let where = if p != none { ", " + p.name.short + ", " + p.location.state }
      entry(r.lab + where, date-range(r), role: r.role, bullets: r.highlights.map(highlight))
    })
    .join(),
)

#let work-section = section(
  "Work Experience",
  newest-first(data.work)
    .map(w => {
      let where = w.organization.name + ", " + w.location.city + ", " + w.location.state
      entry(where, date-range(w), role: w.role, bullets: w.highlights.map(highlight))
    })
    .join(),
)

#let right = (summary-section, research-section, work-section)

// ---------- Page ----------

// Title and contact info
#align(center)[
  #text(font: serif, size: 30pt, person.name)
  #v(-1.2em)
  #let strip(url) = url.replace(regex("^https?://(www\.)?"), "")
  #let contacts = (
    (mail-icon, link("mailto:" + person.email, person.email)),
    (link-icon, link(person.website, strip(person.website))),
  )
  #(
    contacts
      .map(((i, l)) => [#i #l])
      .join(h(0.6em) + text(size: 0.6em, baseline: -0.15em)[#sym.circle.filled] + h(0.6em))
  )
]

// Fill the rest of the page so the sidebar and bottom rule reach the margin.
#block(height: 1fr, layout(size => {
  let inset-x = 8pt
  let left-width = 42% * size.width
  let right-width = size.width - left-width

  // Controls how many dividers are aligned between left and right
  let aligned = 2

  let heights = left
    .zip(right)
    .slice(0, aligned)
    .map(((l, r)) => calc.max(
      measure(l, width: left-width - 2 * inset-x).height,
      measure(r, width: right-width - 2 * inset-x).height,
    ))
  let pad(sections) = sections
    .enumerate()
    .map(((i, s)) => if i < aligned { block(height: heights.at(i), s) } else { s })

  grid(
    columns: (left-width, 1fr),
    rows: 100%,
    inset: (x: inset-x, y: 12pt),
    fill: (x, _) => if x == 0 { sidebar },

    grid.hline(stroke: 0.9pt + ink),
    column(..pad(left)),
    column(..pad(right)),
    grid.hline(stroke: 0.9pt + ink),
  )
}))
