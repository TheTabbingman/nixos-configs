{self, ...}: {
  flake.homeModules.default = {
    config,
    flakeLocation,
    ...
  }: let
    configDirs = builtins.attrNames (builtins.readDir ../../dotfiles/.config);
  in {
    nix.gc = {
      automatic = true;
      dates = "03:15";
      options = "--delete-older-than 7d";
    };

    home.file = builtins.listToAttrs (
      map (dir: {
        name = ".config/${dir}";
        value = {
          source = config.lib.file.mkOutOfStoreSymlink "${flakeLocation}/dotfiles/.config/${dir}";
        };
      })
      configDirs
    );
    gtk.gtk4.theme = config.gtk.theme;
  };
}
