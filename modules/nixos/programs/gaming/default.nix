{pkgs, ...}: {
  programs.steam = {
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
  programs.gamescope.enable = true;
  programs.gamemode.enable = true;
}
