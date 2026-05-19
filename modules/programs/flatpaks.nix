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
  flake.homeModules.programs = {...}: {
    imports = [
      inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ];
    services.flatpak = {
      enable = true;
      uninstallUnmanaged = true;
      update.onActivation = true;
      # Some packages are in gaming
      packages = [
      ];
    };
  };
}
