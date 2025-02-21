{ config, pkgs, userConfig, nhModules, ... }:


{
  home.username = "${userConfig.name}";
  home.homeDirectory = "/home/${userConfig.name}";

  home.stateVersion = "24.11";

  imports = [
    (import "${nhModules}/shell.nix" { 
      nix = "/etc/nixos";
      nixHost = "/etc/nixos/hosts/vm";
      nixFlake = "/etc/nixos#vm";
      homeFlake = "/etc/nixos";
    })
    "${nhModules}/git.nix"
    "${nhModules}/gpg.nix"
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
    steam
    hyprland
    kdePackages.partitionmanager
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
