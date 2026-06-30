{
  description = "BClub Dev Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { nixpkgs, home-manager, nix-index-database,... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system; allowUnfree = true; };
    student = import ./config.nix;
  in
  {
    homeConfigurations.${student.username} =
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./home.nix
          (
		if student.group == "ml"
		|| student.group == "web"
		|| student.group == "hacking"
		then import (./groups + "/${student.group}.nix")
		else {}
	  )

          {
            programs.home-manager.enable = true;

            home.username = student.username;
            home.homeDirectory = "/home/student";
          }

          # Extra

        ];
      };
  };
}
