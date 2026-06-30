{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    bash-language-server
    shfmt
    shellcheck
  ];
}
