{...}: {
  flake.homeModules.scripts = {pkgs, ...}: {
    home.packages = [
      (pkgs.callPackage ./_check-home-diff.nix {})
      (pkgs.callPackage ./_check-nix-diff.nix {})
      (pkgs.callPackage ./_check-nix-boot-diff.nix {})
    ];
  };
}
