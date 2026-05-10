# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  self,
  lib,
  ...
}: {
  flake.nixosConfigurations.nixos-gamer = let
    users = {
      jonah = {
        name = "jonah";
      };
    };
  in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = let
        pkgs-stable = import inputs.nixpkgs-stable {
          system = "x86_64-linux";
        };
      in {
        inherit inputs pkgs-stable;
        hostname = "nixos-gamer";
        userConfig = users."jonah";
        nixosModulesLocation = "${inputs.self}/modules/nixos";
      };
      modules = [
        self.nixosModules.gamer
        self.nixosModules.system
        self.nixosModules.nvidia
        self.nixosModules.gaming
        self.nixosModules.hyprland
        inputs.home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = [inputs.dolphin-overlay.overlays.default inputs.ulauncher.overlays.default];
        }
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."jonah" = {
            imports = [
              ./_home.nix
              inputs.sops-nix.homeManagerModules.sops
              inputs.nix-flatpak.homeManagerModules.nix-flatpak
              inputs.dms.homeModules.niri
              inputs.dms.homeModules.dank-material-shell
              inputs.dms-plugin-registry.modules.default
              inputs.nix-index-database.homeModules.default
            ];
          };
          home-manager.extraSpecialArgs = let
          in {
            inherit inputs;
            hostname = "gamer";
            pkgs-stable = import inputs.nixpkgs-stable {system = "x86_64-linux";};
            userConfig = users."jonah";
            nhModules = "${inputs.self}/modules/home-manager";
            flakeLocation = "/etc/nixos";
          };
        }
      ];
    };

  flake.nixosModules.gamer = {
    pkgs,
    utils,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      solaar
    ];

    hardware.bluetooth.enable = true;

    environment.variables.LIBVA_DRIVER_NAME = "nvidia";

    hardware.keyboard.qmk.enable = true;
    hardware.keyboard.qmk.keychronSupport = true;

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
