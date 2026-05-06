{...}: {
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    update.onActivation = true;
    packages = [
    ];
  };
}
