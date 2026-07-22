{inputs, ...}: {
  flake.nixosModules.system = {
    config,
    pkgs,
    ...
  }: {
    nixpkgs.overlays = [
      inputs.ulauncher.overlays.default
      (final: prev: {
        stable = import inputs.nixpkgs-stable {
          system = final.stdenv.hostPlatform.system;
          config = config.nixpkgs.config;
        };
        scopebuddy = inputs.scopebuddy.packages.${final.stdenv.hostPlatform.system}.default;
        # z-library-desktop = prev.z-library-desktop.overrideAttrs {
        #   src = pkgs.fetchurl {
        #     url = "https://dln1.ncdn.ec/general-files/soft/desktop/Z-Library_3.1.0_amd64.deb";
        #     hash = "sha256-m1axR0HrqHfoz+1tvhCOr1xq0lVkHjxrrf2KnTA7ZVg=";
        #   };
        # };
        video2x = prev.video2x.override {
          ffmpeg = prev.ffmpeg.override {withPlacebo = true;};
        };
        # Taken from https://github.com/rumboon/dolphin-overlay
        kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: {
          dolphin = prev.symlinkJoin {
            name = "dolphin-wrapped";
            paths = [kprev.dolphin kprev.dolphin.dev];
            nativeBuildInputs = [prev.makeWrapper];
            postBuild = ''
              rm $out/bin/dolphin
              makeWrapper ${kprev.dolphin}/bin/dolphin $out/bin/dolphin \
                --set XDG_CONFIG_DIRS "${prev.libsForQt5.__internalKF5.kservice}/etc/xdg:$XDG_CONFIG_DIRS" \
                --run "${kprev.kservice}/bin/kbuildsycoca6 --noincremental ${prev.libsForQt5.__internalKF5.kservice}/etc/xdg/menus/applications.menu"
            '';
            passthru = (kprev.dolphin.passthru or {}) // {dev = kprev.dolphin.dev;};
          };
        });
      })
    ];
  };
}
