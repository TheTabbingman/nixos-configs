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
    "${nixosModules}/system/intel_gpu.nix"
    "${nixosModules}/system/nvidia/nvidia.nix"
    "${nixosModules}/system/nvidia/prime.nix"
    "${nixosModules}/programs"
    "${nixosModules}/programs/gaming"
    "${nixosModules}/desktop/wm/niri.nix"
  ];

  environment.systemPackages = with pkgs; [
  ];

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

  system.stateVersion = "23.11"; # Did you read the comment?
}
