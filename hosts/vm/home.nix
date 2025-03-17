{
  config,
  pkgs,
  pkgs-stable,
  userConfig,
  nhModules,
  inputs,
  dotfilesLocation,
  ...
}: let
  configPath = "${dotfilesLocation}/.config";
  configDirs = builtins.attrNames (builtins.readDir configPath);
in {
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

  home.file = builtins.listToAttrs (map (dir: {
      name = ".config/${dir}";
      value = {
        source = "${configPath}/${dir}";
      };
    })
    configDirs);

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
