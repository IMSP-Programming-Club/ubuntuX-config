{ pkgs, ... }:
let
  studentYAML = ./user.yaml;

  studentJSON =
    pkgs.runCommand " yaml-to-json"
      {
        nativeBuildInputs = [ pkgs.yq-go ];
      }
      ''
        yq   -o=json '.' "${studentYAML}" >$out    
      '';
  student = builtins.fromJSON (builtins.readFile studentJSON);

in
{
  username = "student";
  github = {
    username = student.github.username;
    email = student.github.email;
  };
  group = student.group;

  # Options pour desactiver les configs par defaut

  source = {
    url = "https://github.com/IMSP-Programming-Club/ubuntuX-config";
  };
}
