# Run: nix-build

{ pkgs, ... }:
{
# let
# in {
#   nixpkgs.config.allowUnfree = true;

#   imports = [

#   ];

  # ]
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # List of packages that gets installed....
  environment.systemPackages = with pkgs; [
    curl
    git
    htop
    build-essential
    file
    gcc
    tree
    wget
    unzip
    pv
    go
    git-town
    hugo
    chezmoi
    nodejs
    nixfmt
  ];

  # pkgs.mkShell {
  #   buildInputs = [
  #     nixpkgs.go
  #     nixpkgs.git-town
  #     nixpkgs.hugo
  #     nixpkgs.chezmoi
  #     nixpkgs.nodejs
  #     nixpkgs.nixfmt
  #   ];
}
