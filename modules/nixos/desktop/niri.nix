{
  pkgs,
  inputs,
  ...
}: {
  # Enable hyprland
  programs.niri.enable = true;

  programs.regreet.enable = true;

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
  ];
}
