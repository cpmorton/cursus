# Building

Pipeline: `source.md` → `build.py` (python-docx) → `.docx` → LibreOffice → `.pdf`. Arial 10.5pt, exactly 14pt leading, 0.65" side and 0.55" top/bottom margins, US Letter.

Pick whichever host you have. All of them run the same `./build` in the same image:

| Host | Command |
| --- | --- |
| Browser only | Push to `main`, then download the `pdfs` artifact from the Actions run |
| Codespaces / VS Code devcontainer | `./build resume.md` (the devcontainer uses the `Dockerfile`) |
| Docker | `docker run --rm -v "$PWD:/work" ghcr.io/cpmorton/cursus build resume.md` |
| Native (best effort) | `pip install python-docx`, install LibreOffice + `fonts-liberation` + `poppler-utils`, then `./build resume.md` |

`./build` writes `out/<name>.docx` and `out/<name>.pdf`, and fails if a PDF exceeds 2 pages (`-p N` changes the limit). `--public` drops any phone number from the ` · `-separated contact line, for copies you post online; recruiters can ask for it. Pagination is only guaranteed in the image, because font versions move line breaks.

Calling `build.py` directly: `python3 build.py <src>.md out.docx 10.5 1.15 0.65`.

Arguments after the output file are body size (pt), the leading multiple and the side margin (in). Exact leading is computed as size × multiple × 1.15, rounded to 0.5pt.

## Markup dialect

| Prefix | Renders as |
| --- | --- |
| `# ` | Name |
| `> ` | Tagline (accent color) |
| `## ` | Section heading with a rule below |
| `### Employer \| Location` | Employer row, right-aligned location |
| `### !Employer` | Same, forced onto a new page |
| `@ Title \| Dates` | Italic title row, right-aligned dates |
| `- ` | Bullet |
| `~ ` | Skill row (hanging indent) |
| `= Left \| Right` | Two-column row (education) |
| `**bold**` `*italic*` | Inline emphasis |
| `[text](url)` | Visible text only (no hyperlink field codes, which some ATS parsers choke on) |
| U+2011 | Non-breaking hyphen, emitted as Word's native `w:noBreakHyphen` |

## Why exact leading

The "multiple" line spacing setting is computed from each application's own font metrics, so Word, Google Docs and LibreOffice paginate the same document differently. "Exactly 14pt" comes out identical everywhere. Liberation Sans is metric-compatible with Arial, so a LibreOffice render on Linux matches Word's layout.

## Fit checks before sending

- Exactly 2 pages.
- No runts (a 1–3 word last line on a bullet).
- About 1" of slack on page 2, so that edits someone makes in Word don't tip it onto page 3.
