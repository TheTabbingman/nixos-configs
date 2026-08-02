{...}: {
  flake.nixosModules.wmCommon = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      # ./dms.nix
    ];
    services.displayManager.regreet = {
      enable = !config.services.displayManager.plasma-login-manager.enable && !config.services.displayManager.gdm.enable;
      cageArgs = ["-s" "-d" "-m" "last"];
    };

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
      wl-clipboard # optional: provide complete clipboard API (used by some terminal apps)
      qt6Packages.qt6ct
      ulauncher6
    ];
    # Needed for dolphin disk discovery
    services.udisks2.enable = true;
  };
  flake.homeModules.wm = {pkgs, ...}: {
    home.packages = with pkgs; [
    ];
    services.playerctld.enable = true;
  };
}
