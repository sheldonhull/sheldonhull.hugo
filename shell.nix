# https://nix.dev/tutorials/declarative-and-reproducible-developer-environments
with import <nixpkgs> { };

# stdenv.mkDerivation {
#   name = "devshell";
#
#   buildInputs = [
#     pkgs.figlet
#     pkgs.lolcat
#   ];
#
#   # The '' quotes are 2 single quote characters
#   # They are used for multi-line strings
#   shellHook = ''
#     figlet "Welcome!" | lolcat --freq 0.5
#   '';
# }
# programs.zsh.enable;
# users.extraUsers.codespace = {
#     shell = pkgs.zsh;
# };

mkShell {

  # Package names can be found via https://search.nixos.org/packages
  nativeBuildInputs = [
    direnv
    bat
    eva
    fzf
    git
    zsh
  ];

  NIX_ENFORCE_PURITY = true;

  shellHook = ''
  '';
}
