# UbuntuX-Config

Bienvenue ! 🎉 Ce dépôt configure automatiquement ton environnement de développement avec **Home Manager** (Nix).  
Pas besoin de tout installer à la main — une commande et tout est prêt.

## Fonctionnalités

| | |
|---|---|
| **🎨 Shell prêt à l'emploi** | Bash + starship (prompt stylé) + ble.sh (auto-complétion) + eza/bat (jolis listings) |
| **📦 Packages par groupe** | Choisis ton groupe : `ml` , `web`, ou `hacking`  |
| **🔄 Mise à jour automatique** | Commande `update-config` → backup -> tout en une commande |
| **🌍 Locale française** | Langue du système en fr_FR.UTF-8 |
| **🛡️ Git configuré** | Nom, email, branche `main` par défaut |
| **🎯 Outils dev** | gh,  devenv , pay-respects (`wtf`), avec ✨copilot CLI ! |

## Pour commencer

```bash
# Clone le repo
git clone https://github.com/IMSP-Programming-Club/ubuntuX-config

# Deplace toi dans le dossier
cd ubuntuX-config

# Pour etre sur que tu es bien arrive
pwd         # resultat devrait 'resembler' à un truc du genre :/home/student/ubuntuX-config/
    
# Premiere fois ? le script d'install est là !
chmod +x install.bash
./install.bash

# Si le script echoue (msg erreur): Applique la config manuellement
home-manager switch

# Si le script reussie: relance ta session
exit
```
  Et Voila !! Maintenant tu peux ecrire ton code sans te soucier de ce qui est installé ;)
  
## Personnaliser

Édite `user.yaml` pour changer ton groupe et ton identité GitHub :

```yaml
username: student    # ⚠️ Encore experimental 
github:
  username: TonPseudo
  email: toi@email.com
group: ml   # ml | web | hacking
```

---

Fait avec ~~HAINE~~ ❤️ pour les membres du **BClub**.
