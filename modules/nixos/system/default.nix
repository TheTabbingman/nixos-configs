{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.modules inputs.home-manager.flakeModules.home-manager];
  systems = ["x86_64-linux"];
  flake.nixosModules.system = {
    pkgs,
    lib,
    ...
  }: {
    options.preferences = {
      flakeLocation = lib.mkOption {
        type = lib.types.str;
        default = "/etc/nixos";
      };
    };
    config = {
      services.btrfs.autoScrub.enable = true;

    };
  };
}
