{
  pkgs,
  lib,
  ...
}: let
  # Define your share names here
  shares = ["6X6" "3X4" "256GB NVME" "Ramdisk" "SSD" "Family"];

  commonOptions = [
    "x-systemd.automount"
    "noauto"
    "x-systemd.idle-timeout=60"
    "x-systemd.device-timeout=5s"
    "x-systemd.mount-timeout=5s"
    "credentials=/home/jonah/smb-secrets"
  ];
in {
  # Enable networking
  networking.networkmanager.enable = true;

  # For mount.cifs, required unless domain name resolution is not needed.
  environment.systemPackages = [pkgs.cifs-utils pkgs.samba];

  # This generates a fileSystems block for every share in the list
  fileSystems = lib.genAttrs (map (share: "/mnt/share/fat-boy/${share}") shares) (mountPoint: {
    device = "//fat-boy/${lib.last (lib.splitString "/" mountPoint)}";
    fsType = "cifs";
    options = commonOptions;
  });
}
