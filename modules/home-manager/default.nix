{
  config,
  pkgs,
  inputs,
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
        source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/.config/${dir}";
      };
    })
    configDirs
  );
  gtk.gtk4.theme = config.gtk.theme;

  # Temporarily needed to fix qt6(?) applications https://github.com/NixOS/nixpkgs/issues/508998
  home.sessionVariables = {
    QTWEBENGINE_FORCE_USE_GBM = 0;
  };
}
