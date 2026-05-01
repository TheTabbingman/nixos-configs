{
  pkgs,
  lib,
  ...
}: {
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
}
