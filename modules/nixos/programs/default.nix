{pkgs, ...}: {
  imports = [
    ./shell.nix
    ./waydroid.nix
    ./flatpaks.nix
  ];
  environment.systemPackages = with pkgs; [
  ];
}
