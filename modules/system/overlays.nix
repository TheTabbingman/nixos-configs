{inputs, ...}: {
  flake.nixosModules.system = {
    config,
    pkgs,
    ...
  }: {
    nixpkgs.overlays = [
      inputs.ulauncher.overlays.default
      # inputs.dolphin-overlay.overlays.default
      (final: prev: {
        stable = import inputs.nixpkgs-stable {
          system = final.stdenv.hostPlatform.system;
          config = config.nixpkgs.config;
        };
        scopebuddy = inputs.scopebuddy.packages.${final.stdenv.hostPlatform.system}.default;
        z-library-desktop = prev.z-library-desktop.overrideAttrs {
          src = pkgs.fetchurl {
            url = "https://dln1.ncdn.ec/general-files/soft/desktop/Z-Library_3.1.0_amd64.deb";
            hash = "sha256-m1axR0HrqHfoz+1tvhCOr1xq0lVkHjxrrf2KnTA7ZVg=";
          };
        };
      })
    ];
  };
}
