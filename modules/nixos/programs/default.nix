{pkgs, ...}: {
  imports = [
    ./shell.nix
    ./waydroid.nix
  ];
  environment.systemPackages = with pkgs; [
  ];
}
