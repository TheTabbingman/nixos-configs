{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  # Create a list of targets based on enabled WMs
  enabledWmTargets =
    (lib.optionals config.wayland.windowManager.hyprland.enable ["hyprland-session.target"])
    ++ (lib.optionals config.programs.niri.enable ["niri.service"]);
  wmServices =
    (lib.optionals config.services.swayidle.enable ["swayidle"])
    ++ (lib.optionals config.services.hypridle.enable ["hypridle"])
    ++ (lib.optionals config.services.hyprpolkitagent.enable ["hyprpolkitagent"])
    ++ [
      "ashell"
      "elephant"
      "mako"
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
  programs.ashell = {
    enable = true;
    systemd.enable = true;
    settings = {
      modules = {
        left = ["Workspaces"];
        center = [];
        right = ["Tray" "KeyboardLayout" "SystemInfo" ["Clock" "Privacy" "Settings"]];
      };
      settings = {
        battery_format = "IconAndPercentage";
        peripheral_battery_format = "IconAndPercentage";
        peripheral_indicators = "All";
        # The default value is the following, the items are shown in this order:
        indicators = ["IdleInhibitor" "PowerProfile" "Audio" "PeripheralBattery" "Bluetooth" "Network" "Vpn" "Battery"];
      };
    };
  };
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
