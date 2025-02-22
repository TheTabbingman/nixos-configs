{ config, pkgs, pkgs-stable, userConfig, nhModules, ... }:


{
  home.username = "${userConfig.name}";
  home.homeDirectory = "/home/${userConfig.name}";

  home.stateVersion = "24.11";

  imports = [
    (import "${nhModules}/programs/shell.nix" { 
      nix = "/etc/nixos";
      nixHost = "/etc/nixos/hosts/vm";
      nixFlake = "/etc/nixos#vm";
      homeFlake = "/etc/nixos";
    })
    "${nhModules}/programs/git.nix"
    "${nhModules}/programs/gpg.nix"
    "${nhModules}/programs/nh.nix"
  ];

  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
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
