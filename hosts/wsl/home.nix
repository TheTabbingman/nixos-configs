{
  config,
  pkgs,
  userConfig,
  nhModules,
  ...
}: {
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

  home.packages = with pkgs;
    [
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
    ]
    ++ import "${nhModules}/scripts" {inherit pkgs nhModules;};

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
