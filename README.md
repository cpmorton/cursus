# cursus

*Cursus*: Latin for "course" or "career path". It's the root of *curriculum vitae* and of the Roman *cursus honorum*, the ladder of offices.

Resumes as code. You write one plain-text source per role-type resume and build a tight 2-page Word and PDF file from it, with the same pagination in Word, Google Docs and LibreOffice. It's tool-agnostic. Any editor or AI assistant can work on the sources, and nothing here depends on a particular one.

## Two repos: engine public, canon private

| Repo | Holds |
| --- | --- |
| **cursus** (this one, public) | The builder, docs, generic prompts, a fictional example |
| **your private repo** | Your canon: resume sources, target postings, career history, outputs |

Your real data never enters this repo, so there is nothing to scrub out of its history. See [docs/PRIVATE-REPO.md](docs/PRIVATE-REPO.md) for the setup and the leak guard.

## Quick start

```bash
docker run --rm -v "$PWD:/work" ghcr.io/cpmorton/cursus build example/jane-doe-platform.md
# or open in a Codespace and run: ./build example/*.md
# or don't install anything: every push to main builds PDFs in GitHub Actions
```

The source format is a tiny markup dialect, described in [docs/BUILD.md](docs/BUILD.md). The layout and ATS rules learned the hard way are in [docs/CONVENTIONS.md](docs/CONVENTIONS.md). Reusable AI prompts for interview prep and LinkedIn refreshes are in [prompts/](prompts/).

## License

Apache-2.0. Free to use, fork and adapt. Never sold.
