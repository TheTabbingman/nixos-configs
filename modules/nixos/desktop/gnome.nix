{pkgs, ...}: {
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the Gnome Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    epiphany
  ];

  environment.systemPackages = with pkgs.gnomeExtensions; [
    appindicator
    dash-to-dock
    pop-shell
    blur-my-shell
    search-light
    pkgs.gnome-extension-manager
    clipboard-indicator
    pkgs.dconf-editor
  ];
  services.udev.packages = with pkgs; [gnome-settings-daemon];
}
