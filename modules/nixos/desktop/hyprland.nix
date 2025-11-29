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

  programs.regreet.enable = true;

  # Keyring stuff
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # Optional, hint electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    mpd
    grim
    slurp
    # inputs.hyprsession.packages.${pkgs.stdenv.hostPlatform.system}.hyprsession
    kdePackages.dolphin
    brightnessctl
    playerctl
  ];
}
