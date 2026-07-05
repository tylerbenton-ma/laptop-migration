# laptop-migration

One-command Mac dev environment setup using [chezmoi](https://www.chezmoi.io) + [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle).

Push this repo to your personal GitHub. On a **fresh Mac with zero prior setup**, run:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply tylerbenton-ma/laptop-migration
```

Or use the full bootstrap (installs Xcode CLT + Homebrew first):

```bash
curl -fsSL https://raw.githubusercontent.com/tylerbenton-ma/laptop-migration/main/bootstrap.sh | bash
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
| Shell | zsh + oh-my-zsh | Consolidated `~/.zshrc`, syntax highlighting, default shell via `chsh` |
| Dotfiles | chezmoi | Templated `.gitconfig`, hooks for brew/shell/runtimes/macos |
| Runtimes | mise | Global Ruby 3.4.9, Node 20.19.4, Python 3.12 in `~/.config/mise/config.toml`; per-project overrides via `.tool-versions` / `.ruby-version` / `.nvmrc` |
| macOS prefs | defaults write | Finder, Dock, keyboard, screenshots |

## Repo layout

```
├── Brewfile              # Homebrew packages (brew bundle)
├── bootstrap.sh          # Fresh-Mac entry point
├── Makefile              # make install | brew | apply | doctor
├── migrate/              # Personal file pack + restore (external drive)
│   ├── pack.sh           # Run on OLD Mac → writes archives to drive
│   └── restore.sh        # Run on NEW Mac from the drive
├── docs/MIGRATION.md     # Personal file migration plan (reference)
└── home/                 # chezmoi source (applied to ~)
    ├── .chezmoi.toml.tmpl
    ├── dot_gitconfig.tmpl
    ├── dot_zshrc             # Consolidated zsh + oh-my-zsh config
    ├── dot_bash_profile      # Bash shim → sources .zshrc
    ├── dot_config/mise/      # Global Ruby, Node, Python versions
    └── .chezmoiscripts/  # run_onchange / run_once hooks
```

## chezmoi hooks

- **`run_onchange_before_10-homebrew.sh`** — runs `brew bundle` when `Brewfile` changes
- **`run_once_after_15-shell.sh`** — installs oh-my-zsh, zsh-syntax-highlighting, sets default shell to Homebrew zsh
- **`run_once_after_20-runtimes.sh`** — `mise install` for global Ruby, Node, Python defaults
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

## Personal files (external drive)

Dotfiles and dev tools are handled by chezmoi + Brewfile. **Personal folders** (Desktop, Documents, ui-development, etc.) are copied separately so they never land in git.

### On this Mac (before unplugging the drive)

```bash
# Plug in external drive, then:
./migrate/pack.sh /Volumes/YourDrive

# Optional: also copy Desktop/old hard drive/ as un-archived cold storage (~34 GB)
./migrate/pack.sh --with-old-hard-drive /Volumes/YourDrive
```

This creates `/Volumes/YourDrive/laptop-migration-files/` with:

- One `.tar.gz` per folder (`Desktop.tar.gz`, `ui-development.tar.gz`, …)
- `cursor-setup.tar.gz` — Cursor settings, keybindings, hooks, custom CSS, Fira Code + Operator Mono fonts
- `MANIFEST.txt` and `checksums.sha256`
- `restore.sh` (copied onto the drive)

**Excluded from every archive:** `node_modules`, `Pods`, `dist`, `build`, `coverage`, `graphify-out`, `.next`, `.expo`, `.turbo`, `.cache`, `.gradle`, `DerivedData`, `.DS_Store`. Git history (`.git`) is kept.

**Skipped by default:** Dropbox, Google Drive (re-sync from cloud). `Documents/Adobe/` is excluded. Edit the `FOLDERS` array at the top of `migrate/pack.sh` to change what gets packed.

### On the new Mac

```bash
/Volumes/YourDrive/laptop-migration-files/restore.sh
```

Verifies checksums, extracts archives into `~`, and skips any folder that already has content. After restore, run `npm install` / `yarn`, `bundle install`, and `pod install` in projects as needed.

See [docs/MIGRATION.md](docs/MIGRATION.md) for the full tier list and decision notes.

## Follow-up (not in this scaffold)

- Hyper settings (see `docs/MIGRATION.md` Tier C)
- Add `mas` App Store entries to Brewfile
- Trim Brewfile casks you no longer use

## Reference

Full personal-file migration plan and 20 decision questions: **[docs/MIGRATION.md](docs/MIGRATION.md)**
