{
  pkgs,
  inputs,
  ...
}: {
  # Enable hyprland
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  # Optional, hint electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    kitty
    rofi-wayland
    waybar
    hyprpaper
    mpd
    networkmanagerapplet
    mako
    # libnotify
    grim
    slurp
    hyprpolkitagent
    inputs.hyprsession.packages.${pkgs.system}.hyprsession
    kdePackages.dolphin
    brightnessctl
    playerctl
    ashell
  ];
}
