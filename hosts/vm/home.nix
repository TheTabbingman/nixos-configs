{
  config,
  pkgs,
  userConfig,
  nhModules,
  inputs,
  ...
}: {
  home.username = "${userConfig.name}";
  home.homeDirectory = "/home/${userConfig.name}";

  home.stateVersion = "24.11";

  nix.gc = {
    automatic = true;
    frequency = "03:15";
    options = "--delete-older-than 14d";
  };

  imports = [
    "${nhModules}/programs/shell.nix"
    "${nhModules}/programs/git.nix"
    "${nhModules}/programs/gpg.nix"
    "${nhModules}/programs/nh.nix"
    "${nhModules}/programs/neovim.nix"
    "${nhModules}/desktop/hyprland.nix"
  ];

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs;
    [
      nodejs_23
      nix-search-cli
      gh
      vscode
      pinentry-gtk2
      floorp
      github-desktop
      nvd
      alejandra
      nixd
      alacritty
      foot
      tealdeer
      nix-inspect
      mission-center
    ]
    ++ import "${nhModules}/scripts" {inherit pkgs nhModules;};

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
