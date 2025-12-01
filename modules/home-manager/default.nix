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
  stylix = {
    # Have to do this because stylix thinks I'm not using the same version for stylix and home-manager
    enableReleaseChecks = false;
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";
    # image = "${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/share/hypr/wall2.png";
    polarity = "dark";
  };
}
