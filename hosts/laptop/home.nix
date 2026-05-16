{self, ...}: {
  flake.nixosModules.laptopHome = {...}: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users."jonah" = self.homeModules.laptopUser;
    };
  };
  flake.homeModules.laptopUser = {osConfig, ...}: {
    home = {
      username = "${osConfig.preferences.user.name}";
      homeDirectory = "/home/${osConfig.preferences.user.name}";
    };

    home.stateVersion = "24.11";

    imports = with self; [
      homeModules.system
      homeModules.default
      homeModules.programs
      homeModules.gaming
      homeModules.scripts
      homeModules.niri
      homeModules.dms
    ];

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
