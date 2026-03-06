{pkgs, ...}: {
  programs.steam = {
    enable = true;
    # Fixes black screen with pgu acceleration on xwayland-satellite niri
    package = pkgs.steam.override {
      extraArgs = "-system-composer";
    };
  };
}
