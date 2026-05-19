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
        nixosModules.hyprland
        nixosModules.virtualization
      ]
      ++ [inputs.home-manager.nixosModules.home-manager];
  };

  flake.nixosModules.gamer = {
    pkgs,
    utils,
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
