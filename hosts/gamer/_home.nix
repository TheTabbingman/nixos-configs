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
    "${nhModules}/system"
    "${nhModules}/programs"
    "${nhModules}/programs/gaming"
    "${nhModules}/programs/developer.nix"
    "${nhModules}/scripts"
    "${nhModules}/desktop/wm/niri.nix"
    "${nhModules}/desktop/wm/hyprland.nix"
  ];

  home.packages = with pkgs; [
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
