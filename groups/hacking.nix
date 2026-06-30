{ pkgs, ... }:

{
  # ──────────────────────────────────────────────────
  # 📦 Hacking packages
  # ──────────────────────────────────────────────────
  home.packages = with pkgs; [
    nmap
    wireshark
    john
    sqlmap
  ];
}
