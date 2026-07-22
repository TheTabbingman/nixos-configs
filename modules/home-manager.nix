{...}: {
  flake.homeModules.default = {
    config,
    osConfig,
    ...
  }: {
    nix.gc = {
      automatic = true;
      dates = "03:15";
      options = "--delete-older-than 14d";
    };

    home.file = let
      configDirs = [
        "owocr_config.ini"
        "kdeglobals"
        "kwinrc"
      ];
    in
      builtins.listToAttrs (
        map (dir: {
          name = ".config/${dir}";
          value = {
            source = config.lib.file.mkOutOfStoreSymlink "${osConfig.preferences.flakeLocation}/dotfiles/.config/${dir}";
          };
        })
        configDirs
      );
  };
}
