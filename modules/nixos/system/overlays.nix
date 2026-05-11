{...}: {
  flake.nixosModules.system = {...}: {
    # https://github.com/nixos/nixpkgs/issues/514113
    # https://github.com/NixOS/nixpkgs/issues/513245
    nixpkgs.overlays = [
      (_: prev: {
        openldap = prev.openldap.overrideAttrs {
          doCheck = !prev.stdenv.hostPlatform.isi686;
        };
      })
    ];
  };
}
