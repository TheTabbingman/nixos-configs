{...}: {
  flake.nixosModules.wmCommon = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      # ./dms.nix
    ];
    programs.regreet.enable = !config.services.displayManager.sddm.enable && !config.services.displayManager.gdm.enable;
    programs.regreet.cageArgs = ["-s" "-d" "-m" "last"];

    # Keyring stuff
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;

    environment.systemPackages = with pkgs; [
      mpd
      grim
      slurp
      kdePackages.dolphin
      kdePackages.ark
      loupe
      identity
      unzip
      unrar
      brightnessctl
      playerctl
      wl-clipboard # optional: provide complete clipboard API (used by some terminal apps)
      qt6Packages.qt6ct
      ulauncher6
    ];
    # Needed for dolphin disk discovery
    services.udisks2.enable = true;
  };
}
