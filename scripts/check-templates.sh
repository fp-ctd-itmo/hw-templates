#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
templates=(go cpp rust python javascript haskell ocaml c java)

for template in "${templates[@]}"; do
  echo "==> checking $template"
  pushd "$repo_root/templates/$template" >/dev/null
  rm -f result
  nix build

  test -x result/bin/hello
  test -x result/bin/goodbye
  result/bin/hello >/dev/null
  result/bin/goodbye >/dev/null

  popd >/dev/null
done
