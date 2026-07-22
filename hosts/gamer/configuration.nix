{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.nixos-gamer = inputs.nixpkgs.lib.nixosSystem {
    modules = with self;
      [
        nixosModules.gamer
        nixosModules.gamerHome
        nixosModules.system
        nixosModules.impermanence
        nixosModules.nvidia
        nixosModules.programs
        nixosModules.gaming
        nixosModules.niri
        nixosModules.virtualization
        nixosModules.ai
        nixosModules.plasma
      ]
      ++ [inputs.home-manager.nixosModules.home-manager];
  };

  flake.nixosModules.gamer = {
    pkgs,
    utils,
    config,
    ...
  }: {
    networking.hostName = "nixos-gamer"; # Define your hostname.
    environment.systemPackages = with pkgs; [
      solaar
    ];

    hardware = {
      bluetooth.enable = true;

      keyboard.qmk.enable = true;
      keyboard.qmk.keychronSupport = true;
    };

    # OpenTabletDriver
    hardware.uinput.enable = true;
    boot.kernelModules = ["uinput"];
    hardware.opentabletdriver.enable = true;
    hardware.opentabletdriver.daemon.enable = true;

    boot.tmp.useTmpfs = true;

    # Setup samba shares
    services.samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          #"use sendfile" = "yes";
          #"max protocol" = "smb2";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "192.168.0. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "Extra" = {
          "path" = "/mnt/extra";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "${config.preferences.user.name}";
          "force group" = "users";
          "valid users" = "${config.preferences.user.name}";
        };
      };
    };
    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
    services.avahi = {
      publish.enable = true;
      publish.userServices = true;
      # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
      nssmdns4 = true;
      # ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
      enable = true;
      openFirewall = true;
    };
    networking.firewall.enable = true;
    networking.firewall.allowPing = true;
    system.activationScripts = {
      # The "init_smbpasswd" script name is arbitrary, but a useful label for tracking
      # failed scripts in the build output. An absolute path to smbpasswd is necessary
      # as it is not in $PATH in the activation script's environment. The password
      # is repeated twice with newline characters as smbpasswd requires a password
      # confirmation even in non-interactive mode where input is piped in through stdin.
      init_smbpasswd.text = ''
        /run/current-system/sw/bin/printf "$(/run/current-system/sw/bin/cat ${config.sops.secrets.jonah-password.path})\n$(/run/current-system/sw/bin/cat ${config.sops.secrets.jonah-password.path})\n" | /run/current-system/sw/bin/smbpasswd -sa ${config.preferences.user.name}
      '';
    };

    boot.initrd.systemd = {
      enable = true; # Default in 26.05
      services.wipe-file-systems = {
        # Specify dependencies explicitly
        unitConfig.DefaultDependencies = false;
        # The script needs to run to completion before this service is done
        serviceConfig.Type = "oneshot";
        # This service is required for boot to succeed
        requiredBy = ["initrd.target"];
        # Should complete before any file systems are mounted
        before = ["sysroot.mount"];

        # Wait for the disk to appear
        requires = ["${utils.escapeSystemdPath "/dev/disk/by-uuid/a0a31b91-438b-46f9-bbaf-3c15bbc390e5"}.device"];
        after = [
          "${utils.escapeSystemdPath "/dev/disk/by-uuid/a0a31b91-438b-46f9-bbaf-3c15bbc390e5"}.device"
          # Allow hibernation to resume before trying to alter any data
          "local-fs-pre.target"
        ];

        script = ''
          mkdir /btrfs_tmp
          mount /dev/disk/by-uuid/a0a31b91-438b-46f9-bbaf-3c15bbc390e5 /btrfs_tmp
          if [[ -e /btrfs_tmp/@ ]]; then
              mkdir -p /btrfs_tmp/old_@
              timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/@)" "+%Y-%m-%-d_%H:%M:%S")
              mv /btrfs_tmp/@ "/btrfs_tmp/old_@/$timestamp"
          fi
          if [[ -e /btrfs_tmp/@home ]]; then
              mkdir -p /btrfs_tmp/old_@home
              timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/@home)" "+%Y-%m-%-d_%H:%M:%S")
              mv /btrfs_tmp/@home "/btrfs_tmp/old_@home/$timestamp"
          fi

          delete_subvolume_recursively() {
              IFS=$'\n'
              for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                  delete_subvolume_recursively "/btrfs_tmp/$i"
              done
              btrfs subvolume delete "$1"
          }

          for i in $(find /btrfs_tmp/old_@/ -maxdepth 1 -mtime +30); do
              delete_subvolume_recursively "$i"
          done
          for i in $(find /btrfs_tmp/old_@home/ -maxdepth 1 -mtime +30); do
              delete_subvolume_recursively "$i"
          done

          btrfs subvolume create /btrfs_tmp/@
          btrfs subvolume create /btrfs_tmp/@home
          umount /btrfs_tmp
        '';
      };
    };

    system.stateVersion = "23.11"; # Did you read the comment?
  };
}
