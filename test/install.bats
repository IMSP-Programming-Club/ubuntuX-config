setup() {
  export TEST_DIR=$(mktemp -d)
  export HOME="$TEST_DIR/home"
  export XDG_CONFIG_HOME="$HOME/.config"
  export REPO_DIR="$TEST_DIR/repo"
  mkdir -p "$XDG_CONFIG_HOME/home-manager"
  mkdir -p "$REPO_DIR/groups"
  echo 'old-config' > "$XDG_CONFIG_HOME/home-manager/test.nix"
  echo 'new-config' > "$REPO_DIR/test.nix"
  echo 'ml-pkg' > "$REPO_DIR/groups/ml.nix"
}

teardown() {
  rm -rf "$TEST_DIR"
}

@test "backup conserve les fichiers existants" {
  TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
  BACKUP_DIR="$HOME/.config/home-manager-backup-$TIMESTAMP"
  mkdir -p "$BACKUP_DIR"
  cp -r "$XDG_CONFIG_HOME/home-manager/" "$BACKUP_DIR/"

  [ -f "$BACKUP_DIR/home-manager/test.nix" ]
  run cat "$BACKUP_DIR/home-manager/test.nix"
  [ "$output" = "old-config" ]
}

@test "copie depuis le repo remplace l'ancien contenu" {
  cp -r "$REPO_DIR/." "$XDG_CONFIG_HOME/home-manager/"

  [ -f "$XDG_CONFIG_HOME/home-manager/test.nix" ]
  run cat "$XDG_CONFIG_HOME/home-manager/test.nix"
  [ "$output" = "new-config" ]
}

@test "copie preserve les sous-dossiers" {
  cp -r "$REPO_DIR/." "$XDG_CONFIG_HOME/home-manager/"

  [ -f "$XDG_CONFIG_HOME/home-manager/groups/ml.nix" ]
}

@test "install.bash passe shellcheck" {
  run shellcheck install.bash
  [ "$status" -eq 0 ]
}
