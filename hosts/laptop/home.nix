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
    "${nhModules}/programs/neovim.nix"
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
      steam
      hyprland
      nixd
      alejandra
      nvd
    ]
    ++ import "${nhModules}/scripts" {inherit pkgs nhModules;};

  home.shellAliases = {
    hypredit = "cd ~/.config/hypr/ && $EDITOR .";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
