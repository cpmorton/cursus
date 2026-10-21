# Your private repo

Keep your real data in a separate **private** repo (GitHub Free includes unlimited private repos). Suggested layout:

```
resumes/src/*.md      # canon, one per role type
resumes/README.md     # your conventions and do-not-claim list
resumes/targets.md    # postings, requirements, gaps, story bank
resumes/history.md    # long-form facts trimmed from the resumes
prompts/              # copies of cursus prompts wired to your files
```

## Pulling engine updates

GitHub won't let you make a private fork of a public repo, so add cursus as a second remote instead:

```bash
git remote add upstream https://github.com/<you>/cursus.git
git fetch upstream
git merge upstream/main --allow-unrelated-histories   # first time only
```

Data flows one way only, from cursus into the private repo. Never push the private repo to `upstream`. To make that impossible, run:

```bash
git remote set-url --push upstream DISABLED
```

## Pinning the toolchain

Keep the cursus version in one file, let Dependabot bump it, and have the devcontainer and CI both read it. Each bump arrives as a PR whose CI rebuilds every resume, so a release that reflows a page fails there instead of on `main`.

```dockerfile
# .devcontainer/Dockerfile
FROM ghcr.io/<you>/cursus:1.0.0
```

```jsonc
// .devcontainer/devcontainer.json
{ "build": { "dockerfile": "Dockerfile" } }
```

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: docker
    directory: /.devcontainer
    schedule: { interval: weekly }
```

```yaml
# .github/workflows/build.yml (excerpt): a job's container can't come from a file,
# so a tiny first job reads the FROM line and hands it over
on:
  push: { branches: [main] }
  pull_request:
jobs:
  toolchain:
    runs-on: ubuntu-latest
    outputs:
      image: ${{ steps.pin.outputs.image }}
    steps:
      - uses: actions/checkout@v7
        with: { sparse-checkout: .devcontainer }
      - id: pin
        run: awk '/^FROM /{print "image=" $2; exit}' .devcontainer/Dockerfile >> "$GITHUB_OUTPUT"
  build:
    needs: toolchain
    runs-on: ubuntu-latest
    container: ${{ needs.toolchain.outputs.image }}
    steps:
      - uses: actions/checkout@v7
      - run: build resumes/src/*.md -o out
```

## Leak guard for your cursus clone

If you contribute back to cursus, install the pre-commit hook. It refuses any commit whose staged diff matches a pattern in a denylist kept **outside** the repo. The mechanism is public and the patterns stay private. Checking the denylist into the repo would leak exactly what it guards.

```bash
mkdir -p ~/.config/cursus
printf '%s\n' '555-0100' 'jane@example.com' 'Acme Corp' > ~/.config/cursus/denylist   # your real strings
ln -s ../../tools/leak-check.sh .git/hooks/pre-commit
```

Matching ignores case, spaces and punctuation, so one entry per fact is enough. The hook also blocks SSN-formatted numbers (`NNN-NN-NNNN` or `NNN NN NNNN`) with no secret needed.

## CI backstop

The `leak-check` job scans every tracked file on each push, reading the denylist from the Actions secret `CURSUS_DENYLIST_TEXT` (entries separated by `;`). It reports `file:line` only, never content: CI logs on a public repo are public, and GitHub masks only a secret's exact full value, not one entry inside a list. Bare identifiers that are too generic to shape-match (a 9-digit SSN without dashes) are safe to list here, because the secret never reaches a log or an LLM session.

CI runs after the push, so on a public repo it detects rather than prevents; the hook is the prevention layer.

GitHub push protection (free on public repos: Settings → Code security) blocks real credentials. It doesn't know your phone number, which is why the hook exists.
