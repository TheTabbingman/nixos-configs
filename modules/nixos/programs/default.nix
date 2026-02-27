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
  programs.steam.enable = true;
}
