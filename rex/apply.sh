#!/usr/bin/env bash
# Apply to one existing Rex terminal block, not the client UI or other blocks.
set -euo pipefail
variant=${1:-thunderbolt}
block=${2:-${REX_BLOCK:-}}
session=${3:-${REX_SESSION:-}}
case "$variant" in thunderbolt|whirlwind) ;; *) echo 'Usage: apply.sh [thunderbolt|whirlwind] [BLOCK] [SESSION]' >&2; exit 2;; esac
if [[ -z "$block" ]]; then
  echo 'Specify a Rex block ID or run inside a Rex terminal with REX_BLOCK set.' >&2
  exit 2
fi
root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
args=(-b "$block")
if [[ -n "$session" ]]; then
  args+=(-s "$session")
fi
rex block call "${args[@]}" set_theme "@$root/$variant.json"
