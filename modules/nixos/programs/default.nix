{pkgs, ...}: {
  imports = [
    ./shell.nix
    ./waydroid.nix
    ./flatpaks.nix
    ./distrobox.nix
  ];
  environment.systemPackages = with pkgs; [
    linux-wallpaperengine
  ];
  programs.steam = {
    enable = true;
    # Fixes black screen with pgu acceleration on xwayland-satellite niri
    package = pkgs.steam.override {
      extraArgs = "-system-composer";
    };
  };
}
