# Conventions

Generic rules that apply to any resume built with cursus. Put your own style decisions (names, claims, wording) in your private repo.

## Layout
- At most 2 pages for a resume. A longer full-history version is a CV and gets a separate source.
- Header: name, a role tagline, then a contact line. Profile as bullets. Skills as labelled rows. Dates right-aligned, education dates included.
- One source per **role type** (for example DevOps, data center operations, storage), never per target company. Tailor by choosing the role type, and don't fork a source for each posting.

## ATS and web forms
- No straight double quotes. Some applicant forms reject `< > [ ] " { } \` as "illegal characters", so text pasted from a resume must avoid all of them.
- No emoji. They pull in a color-emoji font, and some parsers drop them.
- Links are rendered as visible text, never as hyperlink fields.
- Test that the PDF's text extracts cleanly (`pdftotext file.pdf -`) before sending it.

## Truthfulness
- Keep a do-not-claim list next to your canon: skills you have only read about, tools you only evaluated, titles you never held. Any AI assistant editing your resume should read it first.
- Never let a tool invent a metric. Leave `[TODO: metric?]` until you supply a real one.

## Canon
- The resume sources are canon. Agents and scripts propose changes, and you approve them. Nothing edits canon silently.
