{
  pkgs,
  lib,
  ...
}: let
  # Define your share names here
  shares = ["6X6" "3X4" "Ramdisk" "SSD" "Family"];

  commonOptions = [
    "x-systemd.automount"
    "noauto"
    "x-systemd.idle-timeout=60"
    "x-systemd.device-timeout=5s"
    "x-systemd.mount-timeout=5s"
    "credentials=/home/jonah/.config/smb-secrets"
    "uid=1000"
    "gid=100"
  ];
in {
  # Enable networking
  networking.networkmanager = {
    enable = true;
    # plugins = with pkgs; [
    #   networkmanager-openvpn
    # ];
  };

  services.tailscale.enable = true;

  # For mount.cifs, required unless domain name resolution is not needed.
  environment.systemPackages = with pkgs; [
    cifs-utils
    samba
  ];
  services.resolved.enable = true;

  # This generates a fileSystems block for every share in the list
  fileSystems = lib.genAttrs (map (share: "/mnt/share/fat-boy/${share}") shares) (mountPoint: {
    device = "//fat-boy/${lib.last (lib.splitString "/" mountPoint)}";
    fsType = "cifs";
    options = commonOptions;
  });

  networking.wg-quick.interfaces = {
    wg0 = {
      autostart = false;
      address = ["100.127.13.215/32"];
      dns = ["10.255.255.3"];
      privateKeyFile = "/home/jonah/wireguard-keys/private.key";
      peers = [
        {
          publicKey = "5LYbbr320XMoXPrLsZex+2cDAMUOnzX5Htpcgb4Uc1c=";
          presharedKeyFile = "/home/jonah/wireguard-keys/preshared.key";
          allowedIPs = ["0.0.0.0/0"];
          endpoint = "ord-323-wg.whiskergalaxy.com:443";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # services.openvpn.servers = {
  #   windscribe = {
  #     config = ''config /home/jonah/openvpn/Windscribe-Chicago-Wrigley.ovpn'';
  #     authUserPass = "/home/jonah/openvpn/credentials";
  #     autoStart = true;
  #   };
  # };
}
