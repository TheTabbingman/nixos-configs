{...}: {
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

      boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
      specialisation = {
        lts-kernel.configuration = {
          system.nixos.tags = ["lts-kernel"];
          boot.kernelPackages = pkgs.linuxPackages;
        };
      };
    };
  };
}
