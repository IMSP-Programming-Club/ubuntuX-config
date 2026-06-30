# AGENTS.md — UbuntuX-Config

## Ce que c'est

Flake Nix Home Manager qui provisionne les environnements dev étudiants pour BClub.
L'utilisateur cible est toujours `/home/student`.

## Structure

- `flake.nix` — point d'entrée. Pin nixpkgs et home-manager sur **nixos-26.05**.
- `config.nix` — lit `user.yaml`, expose `username`, `github`, `group`, `source.url`.
- `user.yaml` — identité étudiant. Changer `group` pour `ml`, `web`, ou `hacking`.
- `home.nix` — packages partagés, shell (bash, git), locale fr, pay-respects, copilot.
- `groups/{ml,web,hacking}.nix` — packages spécifiques chargés conditionnellement par `flake.nix`.
- `scripts.nix` — script `update-config` (backup + fetch + rebuild automatisé).
- `shell.nix` — dev shell pour helix (bash-language-server, shfmt, shellcheck).
- `notes.md` — todo list interne.

## Commandes

```bash
home-manager switch --flake .     # Appliquer la config
nix flake update                  # MAJ inputs du flake
update-config                     # MAJ auto depuis GitHub
nix-shell                         # Shell dev (LSP bash)
```

## Détails importants

- `config.nix` utilise `yq-go` pour parser `user.yaml`. Le champ `group` doit être `"ml"`, `"web"`, ou `"hacking"`.
- `home.homeDirectory` = `/home/student` (hardcodé dans `home.nix` et `flake.nix`).
- `allowUnfree = true` dans `flake.nix`.
- Langue par défaut : `fr_FR.UTF-8` (locale + messages).
- `catppuccin` activé uniquement pour `bat` (flavor mocha).
- `pay-respects` intégré (alias `wtf`) + présent dans `initExtra`.
- `github-copilot-cli` avec `enableMcpIntegration = true`.
- `nixfmt` installé pour formater les `.nix`.
- `micro` est l'éditeur par défaut (`$EDITOR`).

## Conventions

- Scripts en français, UI avec `gum`.
- `writeShellApplication` pour les scripts (shellcheck automatique).
- Meta : `description`, `version`, `lastUpdated` en ISO.
