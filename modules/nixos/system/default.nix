{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.modules];
  systems = ["x86_64-linux"];
  flake.nixosModules.system = {pkgs, ...}: {
    services.tailscale.enable = true;
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-mozc-ut
          fcitx5-gtk
        ];
      };
    };

    services.btrfs.autoScrub.enable = true;

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
