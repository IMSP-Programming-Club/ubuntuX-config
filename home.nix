{ pkgs, ... }:
let
  cfg = import ./config.nix { inherit pkgs; };
in
{

  # ──────────────────────────────────────────────────
  # 🏠 Home
  # ──────────────────────────────────────────────────
  home.username = cfg.username;
  home.homeDirectory = "/home/${cfg.username}";
  home.stateVersion = "26.05";

  # ──────────────────────────────────────────────────
  # 📦 Packages
  # ──────────────────────────────────────────────────
  home.packages = with pkgs; [

    # Dev
    gh
    man-pages
    man-pages-posix
    devenv

    # fun
    cowsay
    lolcat
    sl

    # Big 3
    fastfetch
    starship
    yazi

    # utils
    blesh
    eza
    bat
    tealdeer
    yq
    glibcLocales

  ];

  # ──────────────────────────────────────────────────
  # 🖥️ Shell
  # ──────────────────────────────────────────────────
  programs.bash = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      y = "yazi";
      la = "eza --tree --icons --level=3 --all --group-directories-first";
      ls = "eza --icons --group-directories-first";
      ll = "eza -lh --icons --git --group-directories-first";
      hm = "home-manager";

    };
    initExtra = ''
      fastfetch
      eval "$(${pkgs.starship}/bin/starship init bash)"
    '';
    bashrcExtra = ''
      [[ $- == *i* ]] && source -- "$(blesh-share)"/ble.sh --attach=none

      [[ ! ''${BLE_VERSION-} ]] || ble-attach
    '';
  };

  # ──────────────────────────────────────────────────
  # 📝 Git
  # ──────────────────────────────────────────────────
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = cfg.github.username;
        email = cfg.github.email;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  # ──────────────────────────────────────────────────
  # 🔧 Tools
  # ──────────────────────────────────────────────────
  ###
  programs.micro = {
    enable = true;
    settings = {
      # utiles ?
    };
  };

  programs.pay-respects = {
    enable = true;
    enableBashIntegration = true;
    options = [
      "--alias"
      "wtf"
    ];
  };

  programs.bat = {
    enable = true;

  };

  programs.github-copilot-cli = {
    enable = true;
    enableMcpIntegration = true;
  };
  # ──────────────────────────────────────────────────
  # 🎨 N/A
  # ──────────────────────────────────────────────────
  catppuccin = {
    bat = {
      enable = true;
      flavor = "mocha";
    };
  };
  # ──────────────────────────────────────────────────
  # 📄 Extra Config
  # ──────────────────────────────────────────────────
  home.language = {
    base = "fr_FR.UTF-8";
    messages = "fr_FR.UTF-8";
    ctype = "fr_FR.UTF-8";
    numeric = "fr_FR.UTF-8";
    time = "fr_FR.UTF-8";
    monetary = "fr_FR.UTF-8";
  };

  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    PAGER = "less -RF";
    MANROFFOPT = "-c -P-c";
    EDITOR = "micro";
    LANG = "fr_FR.UTF-8";
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };
}
