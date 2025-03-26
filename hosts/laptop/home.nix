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
    "${nhModules}/scripts"
  ];

  home.packages = with pkgs; [
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
