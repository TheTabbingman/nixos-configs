{...}: {
  flake.homeModules.wm = {pkgs, ...}: {
    home.packages = with pkgs; [
      mpd
      grim
      slurp
      kdePackages.dolphin
      brightnessctl
      playerctl
      wl-clipboard # optional: provide complete clipboard API (used by some terminal apps)
    ];
  };
}
