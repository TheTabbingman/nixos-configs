{
  pkgs,
  inputs,
  lib,
  config,
  osConfig,
  ...
}: let
  # Create a list of targets based on enabled WMs
  enabledWmTargets =
    lib.optionals osConfig.programs.hyprland.enable ["hyprland-session.target"]
    ++ (lib.optionals osConfig.programs.niri.enable ["niri.service"]);
  wmServices = [
    "elephant"
    "walker"
  ];
in {
  imports = [
    inputs.walker.homeManagerModules.default
    ./dms.nix
    ./yazi.nix
  ];
  systemd.user.services = lib.genAttrs wmServices (name: {
    Unit = {
      PartOf = enabledWmTargets;
    };
    Install = {
      WantedBy = lib.mkForce enabledWmTargets;
    };
  });
  programs.walker = {
    enable = true;
    runAsService = true;
  };

  home.packages = with pkgs; [
    mpd
    grim
    slurp
    kdePackages.dolphin
    brightnessctl
    playerctl
    wl-clipboard # optional: provide complete clipboard API (used by some terminal apps)
  ];
}
