# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  hostname,
  nixosModules,
  inputs,
  lib,
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
    solaar
  ];

  hardware.bluetooth.enable = true;

  environment.variables.LIBVA_DRIVER_NAME = "nvidia";

  # If used with Firefox
  environment.variables.MOZ_DISABLE_RDD_SANDBOX = "1";

  programs.firefox.enable = true;
  programs.firefox.preferences = let
    ffVersion = config.programs.firefox.package.version;
  in {
    "media.ffmpeg.vaapi.enabled" = lib.versionOlder ffVersion "137.0.0";
    "media.hardware-video-decoding.force-enabled" = lib.versionAtLeast ffVersion "137.0.0";
    "media.rdd-ffmpeg.enabled" = lib.versionOlder ffVersion "97.0.0";

    "gfx.x11-egl.force-enabled" = true;
    "widget.dmabuf.force-enabled" = true;

    # Set this to true if your GPU supports AV1.
    #
    # This can be determined by reading the output of the
    # `vainfo` command, after the driver is enabled with
    # the environment variable.
    "media.av1.enabled" = true;
  };

  hardware.keyboard.qmk.enable = true;
  hardware.keyboard.qmk.keychronSupport = true;

  hardware.uinput.enable = true;
  boot.kernelModules = ["uinput"];
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;

  boot.tmp.useTmpfs = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
