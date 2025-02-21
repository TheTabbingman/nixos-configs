{ config, pkgs, pkgs-stable, userConfig, ... }:


{
  home.username = "${userConfig.name}";
  home.homeDirectory = "/home/${userConfig.name}";

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
    nvd


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

  home.shellAliases = 
  let
    nix = "/etc/nixos";
    nixHost = "/etc/nixos/hosts/vm";
    nixFlake = "/etc/nixos#vm";
    homeFlake = "/etc/nixos";
  in
    {
      he = "nvim ${homeFlake}/home.nix";
      hne = "nvim ${homeFlake}/flake.nix";
      hms = "home-manager switch --flake ${homeFlake} && chd";
      hmu = "nix flake update --flake ${homeFlake}";
      hmsu = "hmu && hms";
      hd = "nvd diff $(home-manager generations | sed 's/.*-> //' | head -n 2 | tail -n 1) $(home-manager generations | sed 's/.*-> //' | head -n 1)";
      sd = "home-manager generations | sed 's/.*-> //' | head -n 2 | tail -n 1 > /home/jonah/test.txt";
      ne = "nvim ${nixHost}/configuration.nix";
      fe = "nvim ${nix}/flake.nix";
      nrs = "sudo nixos-rebuild switch --flake ${nixFlake} && cnd";
      nrsu = "nu && nrs";
      nrb = "sudo nixos-rebuild boot --flake ${nixFlake} && cnbd";
      nrbu = "nu && nrb";
      nrt = "sudo nixos-rebuild test --flake ${nixFlake} && ntd";
      nhe = "nvim ${nixHost}/configuration.nix ${homeFlake}/home.nix";
      nu = "nix flake update --flake ${nix}";
      nd = "nvd diff $(ls -1d /nix/var/nix/profiles/system-* | sort -V | tail -n 2 | head -n 1) /run/current-system/";
      nbd = "nvd diff /run/current-system/ $(ls -1d /nix/var/nix/profiles/system-* | sort -V | tail -n 1)";
      ntd = "nvd diff $(ls -1d /nix/var/nix/profiles/system-* | sort -V | tail -n 1) /run/current-system/";
      rm = "rm -I";
      fish-reload = "source ~/.config/fish/**/*.fish";
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
