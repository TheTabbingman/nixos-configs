{
  pkgs,
  inputs,
  config,
  ...
}: {
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
  ];
}
