{
  pkgs,
  inputs,
  ...
}: {
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
    wl-clipboard # optional: provide complete clipboard API (used by some terminal apps)
  ];
}
