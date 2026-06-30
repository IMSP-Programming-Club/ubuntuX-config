#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/home-manager"
TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
BACKUP_DIR="$HOME/.config/home-manager-backup-$TIMESTAMP"

header() { echo "=== install ==="; }

main() {
  header

  echo "[1/3] Sauvegarde de l'ancienne config..."
  if [[ -d "$HM_DIR" ]]; then
    mkdir -p "$BACKUP_DIR"
    cp -r "$HM_DIR/" "$BACKUP_DIR/"
    echo "  ✓ Backup → $BACKUP_DIR"
  else
    echo "  ℹ Aucune config existante"
  fi

  echo "[2/3] Copie des fichiers dans $HM_DIR..."
  mkdir -p "$HM_DIR"
  cp -r "$SOURCE_DIR/." "$HM_DIR/"
  echo "  ✓ Fichiers copiés"

  echo "[3/3] home-manager switch..."
  home-manager switch --flake "$HM_DIR"
  echo "  ✓ Configuration appliquée"

  echo "Terminé !"
}

main "$@"
