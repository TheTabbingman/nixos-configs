{...}: {
  flake.nixosModules.gaming = {pkgs, ...}: {
    programs = {
      steam = {
        enable = true;
        # Fixes black screen with pgu acceleration on xwayland-satellite niri
        package = pkgs.steam.override {
          extraArgs = "-system-composer";
        };
        gamescopeSession.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
      gamescope.enable = true;
      gamemode.enable = true;
    };
  };
  flake.homeModules.gaming = {pkgs, ...}: {
    home.packages = with pkgs; [
      osu-lazer-bin
      protontricks
      (heroic.override {
        extraPkgs = pkgs':
          with pkgs'; [
            gamescope
            gamemode
          ];
      })
      (pkgs.bottles.override {removeWarningPopup = true;})
      cartridges
      ryubing
      eden
      prismlauncher
    ];
  };
}
