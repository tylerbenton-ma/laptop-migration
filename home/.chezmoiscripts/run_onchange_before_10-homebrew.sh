#!/usr/bin/env bash
# Installs Homebrew packages from repo-root Brewfile when the file changes.
set -euo pipefail

BREWFILE="${CHEZMOI_WORKING_TREE}/Brewfile"

if [[ ! -f "${BREWFILE}" ]]; then
  echo "Brewfile not found at ${BREWFILE}" >&2
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required but not installed." >&2
  exit 1
fi

echo "==> brew bundle install --file=${BREWFILE}"
brew bundle install --file="${BREWFILE}"
