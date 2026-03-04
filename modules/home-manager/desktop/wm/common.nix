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
  wmServices =
    (lib.optionals config.services.swayidle.enable ["swayidle"])
    ++ (lib.optionals config.services.hypridle.enable ["hypridle"])
    ++ (lib.optionals config.services.hyprpolkitagent.enable ["hyprpolkitagent"])
    ++ [
      "elephant"
      "walker"
    ];
in {
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };
  imports = [
    inputs.walker.homeManagerModules.default
  ];
  systemd.user.services = lib.genAttrs wmServices (name: {
    Unit = {
      PartOf = enabledWmTargets;
    };
    Install = {
      WantedBy = lib.mkForce enabledWmTargets;
    };
  });
  services.mako.enable = true;
  programs.walker = {
    enable = true;
    runAsService = true;
  };

  home.packages = with pkgs; [
    kitty
    nwg-drawer
  ];
}
