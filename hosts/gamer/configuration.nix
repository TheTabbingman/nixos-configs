# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  hostname,
  nixosModules,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    "${nixosModules}/system"
    "${nixosModules}/system/nvidia/nvidia.nix"
    "${nixosModules}/programs"
    "${nixosModules}/programs/gaming"
    "${nixosModules}/desktop/wm/niri.nix"
  ];

  environment.systemPackages = with pkgs; [
  ];

  hardware.nvidia = {
    open = true;
  };

  hardware.bluetooth.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
