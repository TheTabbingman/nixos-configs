{ config, pkgs, pkgs-stable, userConfig, nhModules, ... }:


{
  home.username = "${userConfig.name}";
  home.homeDirectory = "/home/${userConfig.name}";

  home.stateVersion = "24.11";

  imports = [
    (import "${nhModules}/shell.nix" { 
      nix = "/etc/nixos";
      nixHost = "/etc/nixos/hosts/wsl";
      nixFlake = "/etc/nixos#wsl";
      homeFlake = "/etc/nixos";
    })
    "${nhModules}/git.nix"
    "${nhModules}/gpg.nix"
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
    pinentry-gtk2
    nvd
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
