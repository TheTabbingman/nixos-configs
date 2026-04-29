{pkgs, ...}: {
  boot = {
    plymouth = {
      enable = true;
      # logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
      # theme = "lone";
      # themePackages = with pkgs; [
      #   # By default we would install all themes
      #   (adi1090x-plymouth-themes.override {
      #     selected_themes = ["lone"];
      #   })
      # ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader = {
      timeout = 0;

      # Not for plymouth
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
