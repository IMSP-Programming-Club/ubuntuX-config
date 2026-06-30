{ pkgs, ... }:

{
  # ──────────────────────────────────────────────────
  # 📦 ML packages
  # ──────────────────────────────────────────────────
  home.packages = with pkgs; [
    (python3.withPackages (ps: with ps; [
      pip
      numpy
      pandas
      matplotlib
      jupyter
    ]))
    uv
  ];
}
