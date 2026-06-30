{ pkgs, ... }:
let
  config = ./config.nix { inherit pkgs; };
in
{
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "update-config";

      runtimeInputs = with pkgs; [
        git
        gum
        dix
        nix-output-monitor
        home-manager
      ];
      text = ''
        # -- variables -- #
        TEMP_DIR=$( mktemp -d)
        readonly TEMP_DIR
        DATE_STAMP=$( date "+%d%m%Y_%H%M")
        readonly DATE_STAMP
        readonly BACKUP_DIR="$HOME/.backup/$DATE_STAMP"
        readonly CONFIG_DIR="$HOME/.config"
        readonly HM_DIR="$CONFIG_DIR/home-manager"
        REPO_NAME=$(basename "${config.source.url}")
        MAX_RETRY=5

        # -- ui helpers -- #
        header() {
          gum style \
            --border rounded \
            --align center \
            --width 50 \
            --margin "1 0" \
            "🔄 update-config" "v1.0"
        }

        step() {
          gum style --foreground 212 "[$1/$2]" "$3"
        }

        success() {
          gum style --foreground 2 "  ✓ $1"
        }

        fail() {
          gum style --foreground 1 "  ✗ $1"
          exit 1
        }

        info() {
          gum style --foreground 243 "  ℹ $1"
        }

        confirm() {
          gum confirm "$1" || exit 0
        }

        check_update(){
          # Verifie si MAJ depuis github
          local remote_ref
          remote_ref=$( git ls-remote "${config.source.url}" HEAD | cut -f1 )
          local local_ref
          local_ref=$( git -C "$HM_DIR" rev-parse HEAD 2>/dev/null || echo "" )

          if [[ "$remote_ref" == "$local_ref" ]]; then
            info "Déjà à jour"
            rm -rf "$TEMP_DIR"
            exit 0
          fi
        }

        fetch_update(){
          # Clone MAJ dans dossier temp
          if git clone --depth=1 "${config.source.url}" "$TEMP_DIR" 2>/dev/null; then
            return 0
          fi

          # Retry mecanisme
          for (( i=1; i<=MAX_RETRY; i++)); do
            info "Tentative $i/$MAX_RETRY..."
            sleep $((i * 2))
            git clone --depth=1 "${config.source.url}" "$TEMP_DIR" 2>/dev/null && return 0
          done

          fail "Échec de la connexion après $MAX_RETRY tentatives"
        }


        backup(){
          # Backup les fichiers actuels
          mkdir -p "$BACKUP_DIR"

          if rsync -aP "$HM_DIR" "$BACKUP_DIR" 2>/dev/null; then
            return 0
          fi

          # Fallback avec cp
          info "rsync indisponible, utilisation de cp..."
          cp -r "$HM_DIR" "$BACKUP_DIR" && return 0

          fail "Échec du backup"
        }

        move2config(){
          # Deplace les fichiers .nix dans .config/home-manager/
          if rsync -P --stats "$TEMP_DIR/$REPO_NAME/" "$HM_DIR/" 2>/dev/null; then
            rm -rf "$TEMP_DIR"
            return 0
          fi

          # Fallback avec cp
          info "rsync indisponible, utilisation de cp..."
          cp -r "$TEMP_DIR/$REPO_NAME/" "$HM_DIR" && rm -rf "$TEMP_DIR" && return 0

          fail "Échec de la copie des fichiers"
        }

        build_conf(){
          # construit la configuration avec hm et nom
          if home-manager switch --flake "$HM_DIR" --backup "backup" 2>&1 | nom; then
            return 0
          fi

          fail "Échec du rebuild. Verifier avec: home-manager switch --flake $HM_DIR"
        }
        # -- main -- #
        main() {
          header

          step 1 6 "Vérification des dépendances..."
          for cmd in git gum dix nom home-manager; do
            command -v "$cmd" &>/dev/null || fail "Manquant: $cmd"
          done
          success "Toutes les dépendances sont OK"

          step 2 6 "Vérification des mises à jour..."
          check_update
          success "Mise à jour disponible"

          confirm "Procéder à la mise à jour ?"

          step 3 6 "Sauvegarde de la config actuelle..."
          backup
          success "Backup sauvegardé dans $BACKUP_DIR"

          step 4 6 "Récupération des mises à jour..."
          fetch_update
          success "Fetched depuis $REPO_URL"

          step 5 6 "Application des mises à jour..."
          move2config
          success "Fichiers mis à jour"

          step 6 6 "Reconstruction de la configuration..."
          build_conf
          success "Configuration reconstruite"

          gum style \
            --border rounded \
            --align center \
            --width 50 \
            --foreground 2 \
            "✨ Terminé !" "Redémarrez WSL pour appliquer les changements"
        }

        main
      '';

      meta = {
        description = "Mise à jour automatique de la config BClub";
        version = "1.0.0";
        lastUpdated = "2026-06-30";
      };
    })
  ];
}
