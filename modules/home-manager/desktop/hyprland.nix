{
  pkgs,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    plugins = [
      # inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    extraConfig = ''
      source = ~/.config/hypr/config.conf
    '';
  };

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
  services.hyprpolkitagent.enable = true;
  services.network-manager-applet.enable = true;
  programs.ashell = {
    enable = true;
    systemd.enable = true;
  };
  services.mako.enable = true;

  home.packages = with pkgs; [
  ];
}
