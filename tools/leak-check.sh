#!/usr/bin/env bash
# pre-commit: block staged additions that match a private denylist kept outside the repo,
# or that look like a US SSN. Matching ignores case, spaces and punctuation, so one
# entry "919-555-0100" also catches 9195550100, (919) 555.0100, etc.
set -euo pipefail
DENY="${CURSUS_DENYLIST:-$HOME/.config/cursus/denylist}"
norm() { tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]@\n'; }

added=$(git diff --cached -U0 --no-color | grep '^+' | grep -v '^+++' | cut -c2- || true)
[[ -n $added ]] || exit 0
fail=0

# Shape check needs no secret: any SSN-shaped number, not just yours.
# 3-2-4 with consistent separators, or exactly 9 bare digits (ZIP+4 and phones don't fit)
if ssn=$(grep -nE '(^|[^0-9])([0-9]{3}-[0-9]{2}-[0-9]{4}|[0-9]{3} [0-9]{2} [0-9]{4}|[0-9]{9})([^0-9]|$)' <<<"$added"); then
  echo "leak-check: SSN-shaped number in staged changes:" >&2; sed 's/^/  /' <<<"$ssn" >&2; fail=1
fi

if [[ -r $DENY ]]; then
  pats=$(grep -v -e '^\s*#' -e '^\s*$' "$DENY" | norm | grep . || true)
  if [[ -n $pats ]]; then
    # compare normalized forms, report the original line
    while IFS= read -r line; do
      grep -qF -- "$pats" <<<"$(norm <<<"$line")" && { echo "leak-check: denylist match:" >&2; echo "  $line" >&2; fail=1; }
    done <<<"$added"
  fi
else
  echo "leak-check: no denylist at $DENY (SSN check still ran)" >&2
fi
exit $fail
