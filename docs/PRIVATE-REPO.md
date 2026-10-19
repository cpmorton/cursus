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

## Leak guard for your cursus clone

If you contribute back to cursus, install the pre-commit hook. It refuses any commit whose staged diff matches a pattern in a denylist kept **outside** the repo. The mechanism is public and the patterns stay private. Checking the denylist into the repo would leak exactly what it guards.

```bash
mkdir -p ~/.config/cursus
printf '%s\n' '555-0100' 'jane@example.com' 'Acme Corp' > ~/.config/cursus/denylist   # your real strings
ln -s ../../tools/leak-check.sh .git/hooks/pre-commit
```

Matching ignores case, spaces and punctuation, so one entry per fact is enough. The hook also blocks any SSN-shaped number without needing your SSN; never put government IDs in the denylist, which would just create another plaintext copy.

GitHub push protection (free on public repos: Settings → Code security) blocks real credentials. It doesn't know your phone number, which is why the hook exists.
