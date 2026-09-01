{...}: {
  flake.nixosModules.system = {
    pkgs,
    lib,
    config,
    ...
  }: {
    # Enable networking
    networking.networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };

    services.tailscale.enable = true;

    # For mount.cifs, required unless domain name resolution is not needed.
    environment.systemPackages = with pkgs; [
      cifs-utils
      samba
    ];
    services.resolved.enable = true;

    sops.secrets."fat-boy-smb-credentials/username" = {};
    sops.secrets."fat-boy-smb-credentials/password" = {};
    sops.templates."smb-secrets".content = ''
      username=${config.sops.placeholder."fat-boy-smb-credentials/username"}
      password=${config.sops.placeholder."fat-boy-smb-credentials/password"}
    '';
    # This generates a fileSystems block for every share in the list
    fileSystems = let
      # Define your share names here
      shares = ["6X6" "3X4" "Ramdisk" "SSD" "Family" "2X4"];

      commonOptions = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=60"
        "x-systemd.device-timeout=5s"
        "x-systemd.mount-timeout=5s"
        "credentials=${config.sops.templates."smb-secrets".path}"
        "uid=1000"
        "gid=100"
        "nofail"
      ];
    in
      lib.genAttrs (map (share: "/mnt/share/fat-boy/${share}") shares) (mountPoint: {
        device = "//fat-boy/${lib.last (lib.splitString "/" mountPoint)}";
        fsType = "cifs";
        options = commonOptions;
      });

    sops.secrets."windscribe/chicago/private-key" = {};
    sops.secrets."windscribe/chicago/preshared-key" = {};
    sops.secrets."windscribe/portugal/private-key" = {};
    sops.secrets."windscribe/portugal/preshared-key" = {};
    sops.secrets."windscribe/tokyo/private-key" = {};
    sops.secrets."windscribe/tokyo/preshared-key" = {};
    networking.wg-quick.interfaces = {
      wg0 = {
        autostart = true;
        address = ["100.127.13.215/32"];
        dns = ["10.255.255.3"];
        privateKeyFile = config.sops.secrets."windscribe/chicago/private-key".path;
        peers = [
          {
            publicKey = "5LYbbr320XMoXPrLsZex+2cDAMUOnzX5Htpcgb4Uc1c=";
            presharedKeyFile = config.sops.secrets."windscribe/chicago/preshared-key".path;
            allowedIPs = ["0.0.0.0/0"];
            endpoint = "ord-323-wg.whiskergalaxy.com:443";
            persistentKeepalive = 25;
          }
        ];
      };
      wg1 = {
        autostart = false;
        address = ["100.93.32.203/32"];
        dns = ["10.255.255.3"];
        privateKeyFile = config.sops.secrets."windscribe/portugal/private-key".path;
        peers = [
          {
            publicKey = "olUvyUS7X592mAkw3tV1g4drB4XyNl7422F5zo6pd0o=";
            presharedKeyFile = config.sops.secrets."windscribe/portugal/preshared-key".path;
            allowedIPs = ["0.0.0.0/0"];
            endpoint = "lis-249-wg.whiskergalaxy.com:443";
            persistentKeepalive = 25;
          }
        ];
      };
      wg2 = {
        autostart = false;
        address = ["100.94.68.117/32"];
        dns = ["10.255.255.3"];
        privateKeyFile = config.sops.secrets."windscribe/tokyo/private-key".path;
        peers = [
          {
            publicKey = "X6LjCVZ41wLoSbWWZpFET+Ejw0VsGuvJ5utU/l3rKl4=";
            presharedKeyFile = config.sops.secrets."windscribe/tokyo/preshared-key".path;
            allowedIPs = ["0.0.0.0/0"];
            endpoint = "hnd-287-wg.whiskergalaxy.com:443";
            persistentKeepalive = 25;
          }
        ];
      };
    };

    services.openvpn.servers = {
      chicago = {
        config = ''config /home/jonah/openvpn/Windscribe-Chicago-Wrigley.ovpn'';
        authUserPass = "/home/jonah/openvpn/credentials";
        autoStart = false;
        updateResolvConf = true;
      };
      portugal = {
        config = ''config /home/jonah/openvpn/Windscribe-Lisbon-Bairro.ovpn'';
        authUserPass = "/home/jonah/openvpn/credentials";
        autoStart = false;
        updateResolvConf = true;
      };
    };

    networking = {
      firewall.allowedTCPPorts = [5900];
      extraHosts = "192.168.0.81 fat-boy"; # This needs to be manually changed if the ip ever changes
    };
  };
}
