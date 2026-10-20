#!/usr/bin/env bash
# Block personal data from entering this public repo.
#   leak-check.sh          pre-commit: scan staged additions, show offending lines
#   leak-check.sh --all    CI: scan every tracked file, report file:line ONLY
# --all never prints content: CI logs on a public repo are public, and GitHub only
# masks a secret's exact full value, not one entry inside a ';'-joined list.
# Denylist: $CURSUS_DENYLIST_TEXT (';'-separated) or the file $CURSUS_DENYLIST
# (default ~/.config/cursus/denylist). Matching ignores case, spaces and punctuation,
# so one entry "919-555-0100" also catches 9195550100 and (919) 555.0100.
set -euo pipefail
norm() { tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]@\n'; }
SSN='(^|[^0-9])[0-9]{3}([- ])[0-9]{2}\2[0-9]{4}([^0-9]|$)'   # 3-2-4, same separator

if [[ ${1:-} == --all ]]; then
  mode=all; lines=$(git grep -n -I -e '' -- . ':!tools/leak-check.sh' || true)   # path:lineno:text
else
  mode=staged; lines=$(git diff --cached -U0 --no-color | grep '^+' | grep -v '^+++' | cut -c2- | nl -ba -s: -w1 || true)
fi
[[ -n $lines ]] || exit 0

if [[ -n ${CURSUS_DENYLIST_TEXT:-} ]]; then
  raw=$(tr ';' '\n' <<<"$CURSUS_DENYLIST_TEXT")
else
  DENY="${CURSUS_DENYLIST:-$HOME/.config/cursus/denylist}"
  raw=$( [[ -r $DENY ]] && cat "$DENY" || true)
  [[ -n $raw ]] || echo "leak-check: no denylist; SSN shape check only" >&2
fi
pats=$(grep -v -e '^\s*#' -e '^\s*$' <<<"$raw" | norm | grep . || true)

fail=0
report() {  # $1 = why, $2 = "loc:text"
  fail=1
  if [[ $mode == all ]]; then echo "leak-check: $1 at ${2%%:*}:$(cut -d: -f2 <<<"$2")" >&2
  else echo "leak-check: $1: ${2#*:}" >&2; fi
}
while IFS= read -r l; do
  text=${l#*:}; [[ $mode == all ]] && text=${text#*:}
  grep -qE -- "$SSN" <<<"$text" && report "SSN-shaped number" "$l"
  [[ -n $pats ]] && grep -qF -- "$pats" <<<"$(norm <<<"$text")" && report "denylist match" "$l"
done <<<"$lines"
exit $fail
