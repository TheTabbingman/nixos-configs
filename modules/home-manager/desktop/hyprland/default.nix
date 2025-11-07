{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.walker.homeManagerModules.default
    ./hyprlock.nix
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    plugins = [
      # inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    ];
    settings = {
      source = "~/.config/hypr/config.conf";
    };
  };

  services.hypridle.enable = true;
  services.hyprpolkitagent.enable = true;
  services.network-manager-applet.enable = true;
  programs.ashell = {
    enable = true;
    systemd.enable = true;
    settings.modules = {
      left = ["Workspaces"];
      center = [];
      right = ["Tray" "KeyboardLayout" "SystemInfo" ["Clock" "Privacy" "Settings"]];
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
