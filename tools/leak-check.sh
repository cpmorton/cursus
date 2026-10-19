#!/usr/bin/env bash
# pre-commit: block staged additions matching a private denylist kept outside the repo.
# Patterns are fixed strings, one per line, case-insensitive; '#' lines are comments.
set -euo pipefail
DENY="${CURSUS_DENYLIST:-$HOME/.config/cursus/denylist}"
[[ -r $DENY ]] || { echo "leak-check: no denylist at $DENY, skipping" >&2; exit 0; }
pats=$(grep -v -e '^\s*#' -e '^\s*$' "$DENY" || true)
[[ -n $pats ]] || exit 0
# only added lines, so removing a leak is never blocked
if hits=$(git diff --cached -U0 --no-color | grep '^+' | grep -v '^+++' | grep -iF -- "$pats"); then
  echo "leak-check: staged changes match your denylist:" >&2
  printf '%s\n' "$hits" | sed 's/^/  /' >&2
  exit 1
fi
