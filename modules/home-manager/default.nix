{config, ...}: let
  configDirs = builtins.attrNames (builtins.readDir ../../dotfiles/.config);
in {
  nix.gc = {
    automatic = true;
    frequency = "03:15";
    options = "--delete-older-than 14d";
  };

  home.file = builtins.listToAttrs (
    map (dir: {
      name = ".config/${dir}";
      value = {
        source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/.config/${dir}";
      };
    })
    configDirs
  );
}
