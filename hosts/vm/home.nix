{
  config,
  pkgs,
  pkgs-stable,
  userConfig,
  nhModules,
  inputs,
  ...
}: {
  home.username = "${userConfig.name}";
  home.homeDirectory = "/home/${userConfig.name}";

  home.stateVersion = "24.11";

  imports = [
    "${nhModules}/default.nix"
    "${nhModules}/programs"
    "${nhModules}/programs/developer.nix"
    "${nhModules}/desktop/hyprland.nix"
    "${nhModules}/scripts"
  ];

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
