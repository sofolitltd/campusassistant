#!/usr/bin/env bash
#
# Colour-system ratchet.
#
# The rule (see lib/core/theme/app_colors.dart): feature code uses
# `context.colors.<role>` and nothing else — no `Colors.*`, no `Color(0x…)`.
#
# There are ~2,200 pre-existing violations, so this is a ratchet rather than a
# wall: it fails only when the count goes UP. New code can't add violations;
# existing ones burn down file by file without blocking anyone today.
#
# Usage:
#   scripts/check_colors.sh            # check against the baseline
#   scripts/check_colors.sh --update   # re-baseline (only ever downwards)
#
set -euo pipefail

cd "$(dirname "$0")/.."

BASELINE_FILE="scripts/.colors_baseline"

# Exemptions, each for a reason:
#   core/theme/     — the system itself; it has to name real colours somewhere
#   *.g.dart        — generated
#   Colors.transparent — semantically "no colour", not a design decision
#   immersive media — photo/PDF/video viewers are deliberately black-on-white
#                     regardless of theme; they carry an explanatory comment
count_violations() {
  grep -rnoE "\<Colors\.[a-zA-Z]+|Color\(0x[A-Fa-f0-9]{6,8}\)" \
      --include="*.dart" lib 2>/dev/null \
    | grep -v "^lib/core/theme/" \
    | grep -v "\.g\.dart:" \
    | grep -v "\.freezed\.dart:" \
    | grep -v "Colors\.transparent" \
    | grep -vE "lib/widgets/(image_viewer|full_image|pdf_viewer_page)\.dart:" \
    | wc -l | tr -d ' '
}

CURRENT="$(count_violations)"

if [[ "${1:-}" == "--update" ]]; then
  echo "$CURRENT" > "$BASELINE_FILE"
  echo "Baseline updated to $CURRENT."
  exit 0
fi

if [[ ! -f "$BASELINE_FILE" ]]; then
  echo "No baseline found. Creating one at $CURRENT."
  echo "$CURRENT" > "$BASELINE_FILE"
  exit 0
fi

BASELINE="$(cat "$BASELINE_FILE")"

if (( CURRENT > BASELINE )); then
  echo "FAIL: raw colour usage went up ($BASELINE -> $CURRENT)."
  echo
  echo "Use context.colors.<role> instead of Colors.* / Color(0x…)."
  echo "Roles are listed in lib/core/theme/app_colors.dart."
  echo
  echo "Newly added violations are likely among these:"
  grep -rnoE "\<Colors\.[a-zA-Z]+|Color\(0x[A-Fa-f0-9]{6,8}\)" \
      --include="*.dart" lib 2>/dev/null \
    | grep -v "^lib/core/theme/" | grep -v "\.g\.dart:" \
    | grep -v "\.freezed\.dart:" | grep -v "Colors\.transparent" \
    | grep -vE "lib/widgets/(image_viewer|full_image|pdf_viewer_page)\.dart:" \
    | tail -20
  exit 1
fi

if (( CURRENT < BASELINE )); then
  echo "Raw colour usage went down ($BASELINE -> $CURRENT). Nice."
  echo "Run 'scripts/check_colors.sh --update' to lock in the improvement."
  exit 0
fi

echo "OK: raw colour usage unchanged at $CURRENT."
