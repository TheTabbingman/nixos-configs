{self, ...}: {
  flake.nixosModules.gamerHome = {...}: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users."jonah" = self.homeModules.gamerUser;
      backupFileExtension = "hmOrig";
    };
  };
  flake.homeModules.gamerUser = {osConfig, ...}: {
    home = {
      username = "${osConfig.preferences.user.name}";
      homeDirectory = "/home/${osConfig.preferences.user.name}";

      stateVersion = "24.11";
    };

    imports = with self; [
      homeModules.system
      homeModules.default
      homeModules.persist
      homeModules.programs
      homeModules.gaming
      homeModules.developer
      homeModules.scripts
      homeModules.niri
      homeModules.dms
      homeModules.hyprland
    ];

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
