{ config, pkgs, userConfig, nhModules, ... }:


{
  home.username = "${userConfig.name}";
  home.homeDirectory = "/home/${userConfig.name}";

  home.stateVersion = "24.11";

  imports = [
    "${nhModules}/programs/shell.nix"
    "${nhModules}/programs/git.nix"
    "${nhModules}/programs/gpg.nix"
    "${nhModules}/programs/nh.nix"
  ];

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    neovim
    gnumake
    unzip
    gcc
    ripgrep
    rustc
    cargo
    nodePackages_latest.nodejs
    nix-search-cli
    gh
    vscode
    pinentry-gtk2
    floorp
    github-desktop
    nvd
    (import "${nhModules}/scripts/check-home-diff.nix" { inherit pkgs; })
    (import "${nhModules}/scripts/check-nix-diff.nix" { inherit pkgs; })
    (import "${nhModules}/scripts/check-nix-boot-diff.nix" { inherit pkgs; })
  ];


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
