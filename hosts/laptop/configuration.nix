# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  hostname,
  nixosModules,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    "${nixosModules}/desktop/kdeplasma.nix"
    "${nixosModules}/desktop/hyprland.nix"
    "${nixosModules}/system"
    "${nixosModules}/programs"
  ];

  # Disable tpm for faster boot
  systemd.tpm2.enable = false;

  environment.systemPackages = with pkgs; [
  ];

  system.stateVersion = "23.11"; # Did you read the comment?
}
