# laptop-migration

One-command Mac dev environment setup using [chezmoi](https://www.chezmoi.io) + [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle).

Push this repo to your personal GitHub. On a **fresh Mac with zero prior setup**, run:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply tjbenton/laptop-migration
```

Or use the full bootstrap (installs Xcode CLT + Homebrew first):

```bash
curl -fsSL https://raw.githubusercontent.com/tjbenton/laptop-migration/main/bootstrap.sh | bash
```

After cloning locally:

```bash
make install    # full bootstrap from local clone
make brew       # install Homebrew packages from Brewfile
make apply      # apply chezmoi dotfiles
make doctor     # sanity check
```

## What it sets up

| Layer | Tool | Notes |
|-------|------|-------|
| Package manager | Homebrew + Brewfile | Formulae, casks, VS Code/Cursor extensions |
| Dotfiles | chezmoi | Templated `.gitconfig`, hooks for brew/runtimes/macos |
| Ruby | rbenv | Default 3.4.9 (override via `LAPTOP_MIGRATION_RUBY`) |
| Node | nvm | Default 20.19.4 (override via `LAPTOP_MIGRATION_NODE`) |
| Python | uv | Default 3.12 (override via `LAPTOP_MIGRATION_PYTHON`) |
| macOS prefs | defaults write | Finder, Dock, keyboard, screenshots |

## Repo layout

```
├── Brewfile              # Homebrew packages (brew bundle)
├── bootstrap.sh          # Fresh-Mac entry point
├── Makefile              # make install | brew | apply | doctor
├── docs/MIGRATION.md     # Personal file migration plan (reference)
└── home/                 # chezmoi source (applied to ~)
    ├── .chezmoi.toml.tmpl
    ├── dot_gitconfig.tmpl
    └── .chezmoiscripts/  # run_onchange / run_once hooks
```

## chezmoi hooks

- **`run_onchange_before_10-homebrew.sh`** — runs `brew bundle` when `Brewfile` changes
- **`run_once_after_20-runtimes.sh`** — installs rbenv Ruby, nvm Node, uv Python defaults
- **`run_once_after_30-macos-defaults.sh`** — applies macOS system defaults

## Secrets

This repo does **not** contain SSH keys, tokens, or credentials. Copy those manually or add chezmoi age/1Password integration in a follow-up pass. See [docs/MIGRATION.md](docs/MIGRATION.md).

## Updating from this machine

```bash
make brew-dump    # refresh Brewfile from current brew list
chezmoi add ~/.zshrc   # add a dotfile to chezmoi (example)
make apply
git add -A && git commit -m "Update dotfiles"
git push
```

On the new laptop: `chezmoi update` pulls and applies.

## Follow-up (not in this scaffold)

- Seed dotfiles (`.zshrc`, `.bash_*`, Hyper, Cursor settings)
- Add `mas` App Store entries to Brewfile
- Personal file copy-to-drive scripts (see `docs/MIGRATION.md`)
- Trim Brewfile casks you no longer use

## Reference

Full personal-file migration plan and 20 decision questions: **[docs/MIGRATION.md](docs/MIGRATION.md)**
