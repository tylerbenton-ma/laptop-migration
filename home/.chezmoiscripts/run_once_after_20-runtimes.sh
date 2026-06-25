#!/usr/bin/env bash
# Installs default Ruby, Node, and Python versions via rbenv, nvm, and uv.
set -euo pipefail

RBENV_RUBY="${LAPTOP_MIGRATION_RUBY:-3.4.9}"
NVM_NODE="${LAPTOP_MIGRATION_NODE:-20.19.4}"
UV_PYTHON="${LAPTOP_MIGRATION_PYTHON:-3.12}"

install_rbenv_ruby() {
  if ! command -v rbenv >/dev/null 2>&1; then
    echo "rbenv not found — skip Ruby ${RBENV_RUBY}"
    return 0
  fi

  if ! rbenv versions --bare 2>/dev/null | grep -qx "${RBENV_RUBY}"; then
    echo "==> rbenv install ${RBENV_RUBY}"
    rbenv install "${RBENV_RUBY}"
  fi

  rbenv global "${RBENV_RUBY}"
  echo "==> rbenv global ${RBENV_RUBY}"
}

install_nvm_node() {
  export NVM_DIR="${NVM_DIR:-${HOME}/.nvm}"

  if [[ ! -s "${NVM_DIR}/nvm.sh" ]]; then
    echo "nvm not found — skip Node ${NVM_NODE}"
    return 0
  fi

  # shellcheck source=/dev/null
  source "${NVM_DIR}/nvm.sh"

  if ! nvm ls "${NVM_NODE}" >/dev/null 2>&1; then
    echo "==> nvm install ${NVM_NODE}"
    nvm install "${NVM_NODE}"
  fi

  nvm alias default "${NVM_NODE}"
  nvm use default
  echo "==> nvm default ${NVM_NODE}"
}

install_uv_python() {
  if ! command -v uv >/dev/null 2>&1; then
    echo "uv not found — skip Python ${UV_PYTHON}"
    return 0
  fi

  echo "==> uv python install ${UV_PYTHON}"
  uv python install "${UV_PYTHON}" || true
}

install_rbenv_ruby
install_nvm_node
install_uv_python
