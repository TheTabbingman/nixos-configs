{ config, pkgs, ... }:


{
  home.username = "jonah";
  home.homeDirectory = "/home/jonah";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

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

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    # NIXPKGS_ALLOW_UNFREE = 1;
  };

  home.shellAliases = {
      he = "nvim /etc/nixos/hosts/laptop/home-manager/home.nix";
      hms = "home-manager switch --flake /etc/nixos/hosts/laptop/home-manager/";
      ne = "nvim /etc/nixos/hosts/laptop/configuration.nix";
      fe = "nvim /etc/nixos/flake.nix";
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos#laptop";
      nrsu = "nix flake update --flake /etc/nixos && sudo nixos-rebuild switch --flake /etc/nixos#laptop";
      nrb = "sudo nixos-rebuild boot --flake /etc/nixos#laptop";
      nrbu = "nix flake update --flake /etc/nixos && sudo nixos-rebuild boot --flake /etc/nixos#laptop";
      nrt = "sudo nixos-rebuild test --flake /etc/nixos#laptop";
      nhe = "nvim /etc/nixos/hosts/laptop/configuration.nix /etc/nixos/hosts/laptop/home-manager/home.nix";
      rm = "rm -I";
  };
  programs.bash = {
    enable = true;
  };
  programs.zsh = {
    enable = true;
  };
  programs.fish = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userEmail = "51281790+TheTabbingman@users.noreply.github.com";
    userName = "TheTabbingMan";
    extraConfig = {
      credential.helper = "store";
    };
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
