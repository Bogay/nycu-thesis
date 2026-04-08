# NYCU Thesis Template (Typst)

A [Typst](https://typst.app/) template for master's theses at
**National Yang Ming Chiao Tung University (國立陽明交通大學)**, following the
official NYCU Graduate School Thesis Format Specification.

## Credits

- **LaTeX original**: [JingWangTW/NYCU-Thesis-Template](https://github.com/JingWangTW/NYCU-Thesis-Template) (GPL-3.0)
- **Format specification**: NYCU Graduate School Thesis Format Specification
- **Typst port**: bogay

## Project Structure

```
nycu-thesis/
├── template/
│   └── nycu-thesis.typ      # Template library — import this in your thesis
└── examples/
    └── demo/                # Example document showing all features
        ├── main.typ
        └── references.bib
```

Add your own thesis under `examples/`:

```
examples/
├── demo/
└── my-thesis/
    ├── main.typ
    └── references.bib
```

## Requirements

### Typst

Install Typst 0.12 or later: https://github.com/typst/typst/releases

### just (optional)

Install the [just](https://github.com/casey/just) command runner to use the recipes in `justfile`.

### Fonts

The template uses **楷書 (KaiTi)** for Chinese and **Times New Roman** for English.

| Platform | KaiTi | Times New Roman |
|----------|-------|-----------------|
| Linux    | `sudo apt install fonts-arphic-ukai` | `sudo apt install ttf-mscorefonts-installer` |
| macOS    | Built-in (BiauKai) | Via Microsoft Office or Homebrew |
| Windows  | Built-in (DFKai-SB) | Built-in |

If either font is unavailable, Typst falls back to the next available font in
the stack (e.g. `Liberation Serif` for TNR, `Noto Serif CJK TC` for KaiTi).

## Usage

### 1. Create your thesis file

```typst
// examples/my-thesis/main.typ
#import "../../template/nycu-thesis.typ": *

#show: nycu-thesis.with(
  zh-title:       "論文中文題目",
  en-title:       "Thesis English Title",

  zh-author:      "王○○",
  en-author:      ("Wang", "FirstName"),    // (last, first)
  zh-advisor:     "吳○○",
  en-advisor:     ("Wu", "FirstName"),

  zh-university:  "國立陽明交通大學",
  en-university:  "National Yang Ming Chiao Tung University",
  zh-department:  "資訊工程學系",
  en-department:  "Department of Computer Science and Engineering",
  zh-college:     "資訊學院",
  en-college:     "College of Computer Science",
  zh-degree:      "碩士論文",
  en-degree:      "Master Thesis",
  en-degree-type: "Master of Science",
  en-field:       "Computer Science",

  zh-date:        ("一一三", "七"),    // (ROC year in Chinese numerals, month)
  en-date:        ("July", "2024"),

  zh-keywords:    ("關鍵詞一", "關鍵詞二", "關鍵詞三"),
  en-keywords:    ("keyword one", "keyword two", "keyword three"),

  // "draft"  — shows 初稿 watermark on every page
  // "upload" — no watermark, no PDF form pages (for library upload)
  // "print"  — no watermark, include PDF form pages (for binding)
  mode:           "draft",
)

// ── Front matter ──────────────────────────────────────────────────────

#acknowledgments[
  ...
]

#zh-abstract[
  ...
]

#en-abstract[
  ...
]

#toc-section()

// ── Chapters ───────────────────────────────────────────────────────────

= Introduction        // → 第一章　Introduction

== Background         // → 1.1　Background

// ── References ────────────────────────────────────────────────────────

#thesis-bibliography(bibliography("references.bib", style: "ieee", title: none))

// ── Appendices ────────────────────────────────────────────────────────

#show: appendix

= Data                // → 附錄A　Data
```

### 2. Compile

With [just](https://github.com/casey/just) (recommended):

```sh
just compile my-thesis   # compile examples/my-thesis
just watch   my-thesis   # live preview
just build-all           # compile every example
just clean               # delete all generated PDFs
```

Or manually from the repository root:

```sh
typst compile --root . examples/my-thesis/main.typ
typst watch  --root . examples/my-thesis/main.typ
```

### 3. Authorization and approval forms

NYCU requires physically signed/stamped PDF forms. Merge them with the compiled PDF externally:

```sh
# Linux/macOS
pdfunite auth.pdf approval.pdf thesis.pdf final.pdf

# Windows: use PDF24, Adobe Acrobat, or similar
```

## Template API Reference

| Function | Description |
|----------|-------------|
| `nycu-thesis(..params)` | Main show rule — sets up the entire document |
| `acknowledgments[body]` | Inserts 誌謝 section |
| `zh-abstract[body]` | Inserts 中文摘要 with keywords |
| `en-abstract[body]` | Inserts Abstract with keywords |
| `toc-section()` | Inserts 目錄, 圖目錄, 表目錄 |
| `thesis-bibliography(bib)` | Inserts 參考文獻 with unnumbered heading |
| `appendix` | Show rule — switches headings to 附錄A, 附錄B… |

## License

GPL-3.0. See [LICENSE](LICENSE).
