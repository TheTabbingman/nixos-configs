{inputs, ...}: {
  flake.nixosModules.system = {...}: {
    imports = [
      inputs.nix-flatpak.nixosModules.nix-flatpak
    ];
    services.flatpak = {
      enable = true;
      uninstallUnmanaged = true;
      update.onActivation = true;
      packages = [
      ];
    };
  };
}
