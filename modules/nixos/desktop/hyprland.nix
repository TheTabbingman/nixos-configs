{
  pkgs,
  inputs,
  ...
}: {
  # Enable hyprland
  programs.hyprland.enable = true;
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
  ];
}
