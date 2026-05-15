{inputs, ...}: {
  flake.nixosModules.system = {...}: {
    nixpkgs.overlays = [
      inputs.ulauncher.overlays.default
      # inputs.dolphin-overlay.overlays.default
      (final: prev: {
        # https://github.com/nixos/nixpkgs/issues/514113
        # https://github.com/NixOS/nixpkgs/issues/513245
        openldap = prev.openldap.overrideAttrs {
          doCheck = !prev.stdenv.hostPlatform.isi686;
        };
        stable = import inputs.nixpkgs-stable {
          system = final.stdenv.hostPlatform.system;
          config = {
            # This should be the same as nixpkgs.config
            allowUnfree = true;
            cudaSupport = true;
          };
        };
      })
    ];
  };
}
