{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  # Create a list of targets based on enabled WMs
  enabledWmTargets =
    (lib.optionals config.programs.hyprland.enable ["hyprland-session.target"])
    ++ (lib.optionals config.programs.niri.enable ["niri.service"]);
in {
  programs.regreet.enable = !config.services.displayManager.sddm.enable && !config.services.displayManager.gdm.enable;

  # Keyring stuff
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  environment.systemPackages = with pkgs; [
    mpd
    grim
    slurp
    kdePackages.dolphin
    brightnessctl
    playerctl
    wl-clipboard # optional: provide complete clipboard API (used by some terminal apps)
    qt6Packages.qt6ct
  ];
  programs.dms-shell = {
    enable = true;
    package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };
  systemd.user.services.dms = {
    wantedBy = lib.mkForce enabledWmTargets;
    partOf = enabledWmTargets;
  };
}
