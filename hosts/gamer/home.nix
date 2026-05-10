{self, ...}: {
  flake.homeModules.jonah = {
    config,
    pkgs,
    pkgs-stable,
    userConfig,
    nhModules,
    inputs,
    ...
  }: {
    home.username = "${userConfig.name}";
    home.homeDirectory = "/home/${userConfig.name}";

    home.stateVersion = "24.11";

    imports = [
      self.homeModules.system
      self.homeModules.default
      self.homeModules.persist
      self.homeModules.programs
      self.homeModules.gaming
      self.homeModules.developer
      self.homeModules.scripts
      self.homeModules.niri
      self.homeModules.dms
      self.homeModules.hyprland
    ];

    home.packages = with pkgs; [
    ];

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
