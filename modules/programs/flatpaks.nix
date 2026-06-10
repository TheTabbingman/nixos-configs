{inputs, ...}: {
  flake.nixosModules.system = {...}: {
    imports = [
      inputs.nix-flatpak.nixosModules.nix-flatpak
    ];
    services.flatpak = {
      enable = true;
      uninstallUnmanaged = true;
      update.onActivation = false;
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
      update.onActivation = false;
      # Some packages are in gaming
      packages = [
        "com.github.tchx84.Flatseal"
        "io.github.tntwise.REAL-Video-Enhancer"
      ];
      overrides = {
        "io.github.tntwise.REAL-Video-Enhancer".Context = {
          filesystems = [
            "/mnt/share/fat-boy/3X4/Backups/Jonah's Stuff"
          ];
        };
      };
    };
  };
}
