// ╔══════════════════════════════════════════════════════════════════════╗
// ║           NYCU Master's Thesis Template — Typst                     ║
// ║   National Yang Ming Chiao Tung University (國立陽明交通大學)          ║
// ╠══════════════════════════════════════════════════════════════════════╣
// ║  Typst port by bogay                                                ║
// ║  Based on LaTeX template by JingWangTW (GPL-3.0)                   ║
// ║  Original: github.com/JingWangTW/NYCU-Thesis-Template              ║
// ║  Spec: NYCU Graduate School Thesis Format Specification             ║
// ╚══════════════════════════════════════════════════════════════════════╝
//
// ── FONT REQUIREMENTS (楷書 KaiTi + Times New Roman) ──────────────────
//   Linux:   sudo apt install fonts-arphic-ukai ttf-mscorefonts-installer
//   macOS:   BiauKai is built-in; TNR via Microsoft Office or Homebrew
//   Windows: Both fonts are built-in
// ─────────────────────────────────────────────────────────────────────

// ── Font stacks ───────────────────────────────────────────────────────
// KaiTi (楷書) candidates across platforms
#let _zh-fonts = ("DFKai-SB", "BiauKai", "AR PL UKai TW", "Noto Serif CJK TC")
// Times New Roman candidates
#let _en-fonts = ("Times New Roman", "Liberation Serif", "Noto Serif")
// Mixed stack: TNR first. Since TNR lacks CJK glyphs, Typst automatically
// falls back to the next font that has the character.
// Result: Latin chars → TNR; CJK chars → KaiTi.
#let _mixed-fonts = ("Times New Roman", "Liberation Serif",
                     "DFKai-SB", "BiauKai", "AR PL UKai TW", "Noto Serif CJK TC")

// ── State ─────────────────────────────────────────────────────────────
#let _in-appendix = state("_in-appendix", false)  // true after #show: appendix
#let _zh-kw       = state("_zh-kw",       ())     // stored keywords for abstracts
#let _en-kw       = state("_en-kw",       ())
#let _meta        = state("_meta",        none)   // thesis data for abstract headers

// ── Abstract header block (lab convention; not in the school's rules) ──
// Title, student and advisor, university and institute, printed above the
// 中文摘要 / 英文摘要 heading.
#let _abs-info(zh, m) = {
  let adv = m.en-advisor
  set align(center)
  set par(justify: false, leading: 0.5em)
  text(size: 12pt)[
    #if zh [#m.zh-title] else [#m.en-title]
    #v(0.4em)
    #grid(
      columns: (1fr, 1fr),
      align: (left, right),
      if zh [學生：#m.zh-author] else [Student : #m.en-author.at(1) #m.en-author.at(0)],
      if zh [指導教授：#m.zh-advisor 博士] else [Advisor: Dr. #adv.at(1) #adv.at(0)],
    )
    #v(0.4em)
    #if zh [
      #m.zh-university \
      #m.zh-department
    ] else [
      #m.en-department \
      #m.en-university
    ]
  ]
  v(1em)
}

// ── Watermark (draft mode) ────────────────────────────────────────────
#let _watermark = place(
  center + horizon,
  rotate(
    -45deg,
    text(
      font:   _zh-fonts,
      size:   96pt,
      weight: "bold",
      fill:   rgb(0, 0, 0, 25),  // ~10% opacity
    )[初稿],
  ),
)

// ── Cover page (封面, Appendix 1) ─────────────────────────────────────
#let _cover(
  zh-university, zh-department, zh-degree,
  en-university, en-department, en-degree,
  zh-title, en-title,
  zh-author, en-author-last, en-author-first,
  zh-advisor, en-advisor-last, en-advisor-first,
  zh-year, zh-month, en-month, en-year,
  show-watermark,
) = page(
  paper:      "a4",
  margin:     (top: 3cm, bottom: 3cm, left: 3cm, right: 2cm),
  header:     none,
  footer:     none,
  numbering:  none,
  background: if show-watermark { _watermark } else { none },
)[
  #set align(center)
  #set par(justify: false)

  // ① Chinese institution — KaiTi 18 pt, ~1.5× line height
  #text(font: _zh-fonts, size: 18pt)[
    #set par(leading: 11.2pt)
    #zh-university \
    #zh-department \
    #zh-degree
  ]

  #v(2em)

  // ② English institution — TNR
  #[
    #set par(leading: 13.5pt)
    #text(font: _en-fonts, size: 14pt)[#en-department] \
    #text(font: _en-fonts, size: 16pt)[#en-university] \
    #text(font: _en-fonts, size: 16pt)[#en-degree]
  ]

  #v(2em)

  // ③ Titles — KaiTi/TNR 18 pt
  #text(font: _mixed-fonts, size: 18pt)[#set par(leading: 11.2pt); #zh-title]
  #v(0.5em)
  #text(font: _en-fonts, size: 18pt)[#set par(leading: 15.2pt); #en-title]

  // Remaining vertical space pushed to author/date area
  #v(1fr)

  // ④ Author & advisor — mixed 18 pt
  #text(font: _mixed-fonts, size: 18pt)[
    #set par(leading: 11.2pt)
    研究生：#zh-author（#en-author-last, #en-author-first）\
    指導教授：#zh-advisor（#en-advisor-last, #en-advisor-first）
  ]

  #v(2em)

  // ⑤ Date
  #text(font: _zh-fonts, size: 18pt)[中華民國#zh-year;年#zh-month;月]
  #v(0.3em)
  #text(font: _en-fonts, size: 18pt)[#en-month #en-year]
]

// ── Title page (書名頁, Appendix 2) ───────────────────────────────────
#let _title-page(
  zh-university, zh-department, zh-degree,
  en-university, en-department, en-college,
  en-degree-type, en-field,
  zh-title, en-title,
  zh-author, en-author-last, en-author-first,
  zh-advisor, en-advisor-last, en-advisor-first,
  zh-year, zh-month, en-month, en-year,
  show-watermark,
) = page(
  paper:      "a4",
  margin:     (top: 2cm, bottom: 2cm, left: 3cm, right: 2cm),
  header:     none,
  footer:     none,
  numbering:  none,
  background: if show-watermark { _watermark } else { none },
)[
  #set align(center)
  #set par(justify: false)

  // Titles — 18 pt
  #text(font: _mixed-fonts, size: 18pt)[#set par(leading: 11.2pt); #zh-title]
  #v(0.5em)
  #text(font: _en-fonts, size: 18pt)[#set par(leading: 15.2pt); #en-title]

  #v(2em)

  // Author / advisor block — 14 pt, single spacing
  #set text(size: 14pt)
  #grid(
    columns:       (auto, auto),
    align:         left,
    column-gutter: 3em,
    row-gutter:    0.5em,
    text(font: _zh-fonts)[#box(width: 4em)[研#h(1fr)究#h(1fr)生]：#zh-author],
    text(font: _en-fonts)[Student：#en-author-last, #en-author-first],
    text(font: _zh-fonts)[指導教授：#zh-advisor],
    text(font: _en-fonts)[Advisor：#en-advisor-last, #en-advisor-first],
  )

  #v(2em)

  // Chinese institution — 14 pt
  #text(font: _zh-fonts, size: 14pt)[
    #set par(leading: 8.7pt)
    #zh-university \
    #zh-department \
    #zh-degree
  ]

  #v(2em)

  // English "submitted-to" block — TNR 14 pt, single spacing
  #text(font: _en-fonts, size: 14pt)[
    #set par(leading: 7pt)
    A Thesis \
    Submitted to #en-department \
    #en-college \
    #en-university \
    in Partial Fulfillment of the Requirements \
    for the Degree of \
    #en-degree-type \
    in \
    #en-field
  ]

  #v(1fr)

  // Date
  #text(font: _en-fonts, size: 14pt)[
    #en-month #en-year \
    Taiwan, Republic of China
  ]
  #v(0.3em)
  #text(font: _zh-fonts, size: 14pt)[中華民國 #zh-year;年#zh-month;月]
]

// ═══════════════════════════════════════════════════════════════════════
// PUBLIC API — call these functions inside the body of main.typ
// ═══════════════════════════════════════════════════════════════════════

/// Inserts the Acknowledgments (誌謝) page: no page number, not in the
/// table of contents, and not counted, so 中文摘要 is page i.
#let acknowledgments(body) = {
  [
    #set page(numbering: none)
    #heading(level: 1, numbering: none, outlined: false)[誌謝]
    #body
  ]
  counter(page).update(1)
}

/// Inserts the Chinese abstract with auto-injected keywords.
#let zh-abstract(body) = {
  heading(level: 1, numbering: none, outlined: true)[中文摘要]
  body
  v(1em)
  context {
    let kw = _zh-kw.get()
    if kw.len() > 0 [*關鍵詞：*#kw.join("、")]
  }
}

/// Inserts the English abstract with auto-injected keywords.
#let en-abstract(body) = {
  heading(level: 1, numbering: none, outlined: true)[英文摘要]
  body
  v(1em)
  context {
    let kw = _en-kw.get()
    if kw.len() > 0 [*Keywords:* #kw.join(", ")]
  }
}

/// Switches page numbering to Arabic numerals starting at 1.
/// Usage:  #show: main-matter   (place right before the first chapter)
#let main-matter(body) = {
  set page(numbering: "1")
  counter(page).update(1)
  body
}

/// Generates Table of Contents, List of Figures, and List of Tables.
/// Call this after the abstracts and before the first chapter.
#let toc-section() = {
  // Figure / table numbers depend on the chapter counter, which must be read
  // at the figure's own location; evaluated at the outline it would read 0.
  show outline.entry: it => {
    let el = it.element
    if el.func() != figure { return it }
    let loc = el.location()
    let ch = counter(heading.where(level: 1)).at(loc).first()
    let n = counter(figure.where(kind: el.kind)).at(loc).first()
    link(loc, it.indented(
      [#el.supplement #ch.#n],
      [#el.caption.body #box(width: 1fr, it.fill) #it.page()],
    ))
  }
  // Titles are real (unnumbered, outlined) headings so that 目錄, 圖目錄
  // and 表目錄 appear in the table of contents, as in the school's sample.
  heading(level: 1, numbering: none, outlined: true)[目錄]
  outline(title: none, depth: 3, indent: auto)
  heading(level: 1, numbering: none, outlined: true)[圖目錄]
  outline(title: none, target: figure.where(kind: image))
  heading(level: 1, numbering: none, outlined: true)[表目錄]
  outline(title: none, target: figure.where(kind: table))
}

/// Switches heading numbering to appendix style (附錄A, 附錄B…).
/// Usage:  #show: appendix   (place before appendix headings)
#let appendix(body) = {
  _in-appendix.update(true)
  counter(heading).update(0)
  body
}

/// Renders the bibliography section with a properly-styled unnumbered heading.
/// Pass the bibliography() call as the argument so the path resolves in the
/// caller's file context (not the template's):
///   #thesis-bibliography(bibliography("references.bib", style: "ieee", title: none))
#let thesis-bibliography(bib) = {
  // Use an explicit unnumbered heading so it appears in TOC without
  // receiving a chapter number like "第X章".
  heading(level: 1, numbering: none, outlined: true)[參考文獻]
  bib
}

// ═══════════════════════════════════════════════════════════════════════
// MAIN TEMPLATE FUNCTION
// ═══════════════════════════════════════════════════════════════════════

/// NYCU master's thesis template.
///
/// Usage:
///   #show: nycu-thesis.with( ...params... )
///
/// Parameters:
///   zh-title / en-title  — thesis title in Chinese and English
///   zh-author / en-author — author name; en-author is (last, first)
///   zh-advisor / en-advisor — advisor name; en-advisor is (last, first)
///   zh-department / en-department — department name
///   zh-college / en-college — college name
///   zh-degree / en-degree — degree label (碩士論文 / Master Thesis)
///   en-degree-type — full English degree (Master of Science)
///   en-field — field of study (Computer Science)
///   zh-date — (ROC-year in Chinese numerals, month in Chinese)
///   en-date — (month string, year string)
///   zh-keywords / en-keywords — keyword lists (5–7 items each)
///   mode — "draft" (初稿 watermark) | "upload" | "print"
#let nycu-thesis(
  zh-title:        [論文中文題目],
  en-title:        "Thesis English Title",
  zh-author:       "王○○",
  en-author:       ("Wang", "FirstName"),
  zh-advisor:      "吳○○",
  en-advisor:      ("Wu", "FirstName"),

  zh-university:   "國立陽明交通大學",
  en-university:   "National Yang Ming Chiao Tung University",
  zh-department:   "資訊工程學系",
  en-department:   "Department of Computer Science and Engineering",
  zh-college:      "資訊學院",
  en-college:      "College of Computer Science",
  zh-degree:       "碩士論文",
  en-degree:       "Master Thesis",
  en-degree-type:  "Master of Science",
  en-field:        "Computer Science",

  zh-date:         ("一一三", "七"),
  en-date:         ("July", "2024"),

  zh-keywords:     (),
  en-keywords:     (),

  mode:            "draft",

  body,
) = {
  assert(
    mode in ("draft", "upload", "print"),
    message: "nycu-thesis: mode must be \"draft\", \"upload\" or \"print\", got " + repr(mode),
  )

  // Store keywords for use by zh-abstract / en-abstract
  _zh-kw.update(zh-keywords)
  _en-kw.update(en-keywords)
  _meta.update((
    zh-title: zh-title, en-title: en-title,
    zh-author: zh-author, en-author: en-author,
    zh-advisor: zh-advisor, en-advisor: en-advisor,
    zh-university: zh-university, en-university: en-university,
    zh-department: zh-department, en-department: en-department,
  ))

  // ── Document metadata ──────────────────────────────────────────────
  set document(
    title:  en-title,
    author: en-author.at(0) + ", " + en-author.at(1),
  )

  // ── Global text settings ───────────────────────────────────────────
  set text(
    font:   _mixed-fonts,
    size:   12pt,
    lang:   "zh",
    region: "TW",
  )
  set par(leading: 0.65em, justify: true)

  // ── Heading numbering ──────────────────────────────────────────────
  // The numbering function is context-aware to support appendix mode.
  set heading(
    numbering: (..nums) => {
      let pos   = nums.pos()
      let depth = pos.len()
      context {
        if depth == 1 {
          if _in-appendix.get() {
            [附錄#numbering("A", pos.first())　]
          } else {
            [第#numbering("一", pos.first())章　]
          }
        } else {
          // Section / subsection: "2.1　", "2.1.3　" …
          pos.map(str).join(".") + [　]
        }
      }
    },
  )

  // ── Base page settings ─────────────────────────────────────────────
  // body margins: top 2.5 cm, left 3 cm, right 2 cm, bottom 2.5 cm
  // Page number at 1.5 cm from bottom edge:
  //   footer-descent = bottom-margin − 1.5 cm = 2.5 cm − 1.0 cm = 1.0 cm
  set page(
    paper:          "a4",
    margin:         (top: 2.5cm, left: 3cm, right: 2cm, bottom: 2.5cm),
    header:         none,
    footer-descent: 1cm,
    footer: context {
      if page.numbering != none {
        align(center, counter(page).display())
      }
    },
    background: if mode == "draft" { _watermark } else { none },
  )

  // ── Figure / table captions ────────────────────────────────────────
  show figure.where(kind: image): set figure(supplement: [圖])
  show figure.where(kind: table): set figure(supplement: [表])

  // Chapter-based numbering: 圖 1.1, 表 2.3
  // The figure/table counters are reset inside the heading show rule.
  show figure.where(kind: image): set figure(
    numbering: n => context {
      let ch = counter(heading.where(level: 1)).get().first()
      str(ch) + "." + str(n)
    },
  )
  show figure.where(kind: table): set figure(
    numbering: n => context {
      let ch = counter(heading.where(level: 1)).get().first()
      str(ch) + "." + str(n)
    },
  )

  // ── Equation numbering: (1.1), (2.3) ──────────────────────────────
  set math.equation(
    numbering: n => context {
      let ch = counter(heading.where(level: 1)).get().first()
      "(" + str(ch) + "." + str(n) + ")"
    },
    supplement: [式],
  )

  // ── Heading show rule ──────────────────────────────────────────────
  show heading: it => {
    // At numbered level-1 headings (chapters):
    if it.level == 1 and it.numbering != none {
      // Reset chapter-local counters
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      counter(math.equation).update(0)

    }

    // Build display: numbering prefix + body text
    let num-display = if it.numbering != none {
      counter(heading).display(it.numbering)
    } else {
      []
    }

    if it.level == 1 {
      // Short unnumbered titles are letter-spaced to a fixed width (as in
      // the school's sample and upstream); outline entries are unaffected.
      let spread = (
        "誌謝": 3em, "目錄": 3em, "圖目錄": 4em, "表目錄": 4em, "參考文獻": 5.5em,
      )
      let key = if it.body.has("text") { it.body.text } else { none }
      let title = if it.numbering == none and key in spread {
        box(width: spread.at(key), key.clusters().join(h(1fr)))
      } else {
        it.body
      }
      // Every level-1 heading (chapter or unnumbered section) starts a new page
      pagebreak(weak: true)
      if it.numbering == none and key in ("中文摘要", "英文摘要") {
        context {
          let m = _meta.get()
          if m != none { _abs-info(key == "中文摘要", m) }
        }
      }
      block(width: 100%, above: 2em, below: 1.2em, breakable: false)[
        #set align(center)
        #set text(size: 16pt, weight: "bold")
        #num-display#title
      ]
    } else if it.level == 2 {
      block(width: 100%, above: 1.5em, below: 0.8em, breakable: false)[
        #set text(size: 14pt, weight: "bold")
        #num-display#it.body
      ]
    } else if it.level == 3 {
      block(width: 100%, above: 1em, below: 0.5em, breakable: false)[
        #set text(size: 12pt, weight: "bold")
        #num-display#it.body
      ]
    } else {
      block(above: 0.8em, below: 0.3em)[
        #set text(weight: "bold")
        #it.body
      ]
    }
  }

  // ── TOC entry style ────────────────────────────────────────────────
  // Chapter-level entries in outline are bold
  show outline.entry.where(level: 1): it => {
    v(0.3em, weak: true)
    strong(it)
  }

  // ── Generate cover and title pages ────────────────────────────────
  let wm = mode == "draft"
  _cover(
    zh-university, zh-department, zh-degree,
    en-university, en-department, en-degree,
    zh-title, en-title,
    zh-author, en-author.at(0), en-author.at(1),
    zh-advisor, en-advisor.at(0), en-advisor.at(1),
    zh-date.at(0), zh-date.at(1), en-date.at(0), en-date.at(1),
    wm,
  )
  _title-page(
    zh-university, zh-department, zh-degree,
    en-university, en-department, en-college,
    en-degree-type, en-field,
    zh-title, en-title,
    zh-author, en-author.at(0), en-author.at(1),
    zh-advisor, en-advisor.at(0), en-advisor.at(1),
    zh-date.at(0), zh-date.at(1), en-date.at(0), en-date.at(1),
    wm,
  )

  // ── Start front-matter page numbering (i, ii, iii …) ─────────────
  // Set through `page.numbering` (not a footer-only state) so that table of
  // contents entries are formatted the same way as the page footers.
  set page(numbering: "i")
  counter(page).update(1)

  // ── User body (acknowledgments → abstracts → toc-section → chapters) ─
  body
}
