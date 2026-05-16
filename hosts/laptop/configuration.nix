# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.nixos-laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = with self;
      [
        nixosModules.laptop
        nixosModules.laptopHome
        nixosModules.system
        nixosModules.impermanence
        nixosModules.intelgpu
        nixosModules.nvidia
        nixosModules.nvidiaPrime
        nixosModules.programs
        nixosModules.gaming
      ]
      ++ [inputs.home-manager.nixosModules.home-manager];
  };

  flake.nixosModules.laptop = {
    config,
    utils,
    ...
  }: {
    networking.hostName = "nixos-laptop";
    services.throttled = {
      enable = true;
      extraConfig = ''
        [GENERAL]
        # Enable or disable the script execution
        Enabled: True
        # SYSFS path for checking if the system is running on AC power
        Sysfs_Power_Path: /sys/class/power_supply/AC*/online
        # Auto reload config on changes
        Autoreload: True

        ## Settings to apply while connected to Battery power
        [BATTERY]
        # Update the registers every this many seconds
        Update_Rate_s: 30
        # Max package power for time window #1
        PL1_Tdp_W: 29
        # Time window #1 duration
        PL1_Duration_s: 28
        # Max package power for time window #2
        PL2_Tdp_W: 44
        # Time window #2 duration
        PL2_Duration_S: 0.002
        # Max allowed temperature before throttling
        Trip_Temp_C: 85
        # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
        cTDP: 0
        # Disable BDPROCHOT (EXPERIMENTAL)
        Disable_BDPROCHOT: True

        ## Settings to apply while connected to AC power
        [AC]
        # Update the registers every this many seconds
        Update_Rate_s: 5
        # Max package power for time window #1
        PL1_Tdp_W: 44
        # Time window #1 duration
        PL1_Duration_s: 28
        # Max package power for time window #2
        PL2_Tdp_W: 44
        # Time window #2 duration
        PL2_Duration_S: 0.002
        # Max allowed temperature before throttling
        Trip_Temp_C: 95
        # Set HWP energy performance hints to 'performance' on high load (EXPERIMENTAL)
        # Uncomment only if you really want to use it
        # HWP_Mode: False
        # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
        cTDP: 0
        # Disable BDPROCHOT (EXPERIMENTAL)
        Disable_BDPROCHOT: True

        # All voltage values are expressed in mV and *MUST* be negative (i.e. undervolt)!
        [UNDERVOLT.BATTERY]
        # CPU core voltage offset (mV)
        CORE: 0
        # Integrated GPU voltage offset (mV)
        GPU: 0
        # CPU cache voltage offset (mV)
        CACHE: 0
        # System Agent voltage offset (mV)
        UNCORE: 0
        # Analog I/O voltage offset (mV)
        ANALOGIO: 0

        # All voltage values are expressed in mV and *MUST* be negative (i.e. undervolt)!
        [UNDERVOLT.AC]
        # CPU core voltage offset (mV)
        CORE: 0
        # Integrated GPU voltage offset (mV)
        GPU: 0
        # CPU cache voltage offset (mV)
        CACHE: 0
        # System Agent voltage offset (mV)
        UNCORE: 0
        # Analog I/O voltage offset (mV)
        ANALOGIO: 0

        # [ICCMAX.AC]
        # # CPU core max current (A)
        # CORE:
        # # Integrated GPU max current (A)
        # GPU:
        # # CPU cache max current (A)
        # CACHE:

        # [ICCMAX.BATTERY]
        # # CPU core max current (A)
        # CORE:
        # # Integrated GPU max current (A)
        # GPU:
        # # CPU cache max current (A)
        # CACHE:
      '';
    };

    hardware.intelgpu = {
      # VP9 decoding not supported when using intel-media-driver
      # https://github.com/intel/media-driver/issues/1024
      # NixOS Wiki recommends using the legacy intel-vaapi-driver with the hybrid codec over that one for Skylake.
      # https://wiki.nixos.org/wiki/Accelerated_Video_Playback
      computeRuntime = "legacy";
      vaapiDriver = "intel-vaapi-driver";
      enableHybridCodec = true;
    };

    hardware.nvidia = {
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      prime = {
        # Make sure to use the correct Bus ID values for your system!
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      primeBatterySaverSpecialisation = true;
    };

    hardware.bluetooth.enable = true;

    services.udev.extraRules = ''
      # Intel iGPU Symlink
      # Replace 0000:00:02.0 with your actual Intel PCI ID
      KERNEL=="card*", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", KERNELS=="0000:00:02.0", SYMLINK+="dri/intel-igpu"

      # NVIDIA dGPU Symlink
      # Replace 0000:01:00.0 with your actual NVIDIA PCI ID
      KERNEL=="card*", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", KERNELS=="0000:01:00.0", SYMLINK+="dri/nvidia-dgpu"
    '';

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
        requires = ["${utils.escapeSystemdPath "/dev/disk/by-uuid/22e530c7-a48f-40e8-a474-0c2ca3a91825"}.device"];
        after = [
          "${utils.escapeSystemdPath "/dev/disk/by-uuid/22e530c7-a48f-40e8-a474-0c2ca3a91825"}.device"
          # Allow hibernation to resume before trying to alter any data
          "local-fs-pre.target"
        ];

        script = ''
          mkdir /btrfs_tmp
          mount /dev/disk/by-uuid/22e530c7-a48f-40e8-a474-0c2ca3a91825 /btrfs_tmp
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
