# UbuntuX-Config

Bienvenue ! 🎉 Ce dépôt configure automatiquement ton environnement de développement avec **Home Manager** (Nix).  
Pas besoin de tout installer à la main — une commande et tout est prêt.

## Fonctionnalités

| | |
|---|---|
| **🎨 Shell prêt à l'emploi** | Bash + starship (prompt stylé) + ble.sh (auto-complétion) + eza/bat (jolis listings) |
| **📦 Packages par groupe** | Choisis ton groupe : `ml` (Python/IA), `web` (PHP/Node/SQLite), ou `hacking` (nmap/Wireshark) |
| **🔄 Mise à jour automatique** | Commande `update-config` → backup, fetch GitHub, rebuild en un clic |
| **🐍 Python & Data Science** | numpy, pandas, matplotlib, Jupyter, pip — tout pré-installé |
| **🌍 Locale française** | Langue du système en fr_FR.UTF-8 |
| **🛡️ Git configuré** | Nom, email, branche `main` par défaut |
| **🎯 Outils dev** | gh, micro, nixfmt, pay-respects (`wtf`), copilot CLI |
| **✨ Fun** | cowsay, lolcat, fastfetch au lancement |

## Pour commencer

```bash
# Applique la config
home-manager switch --flake .

# Mets à jour depuis GitHub
update-config
```

## Personnaliser

Édite `user.yaml` pour changer ton groupe et ton identité GitHub :

```yaml
username: student
github:
  username: TonPseudo
  email: toi@email.com
group: ml   # ml | web | hacking
```

---

Fait avec ❤️ pour les membres du **BClub**.
