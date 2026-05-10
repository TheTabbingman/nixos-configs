{...}: {
  flake.nixosModules.plasma-minimal = {pkgs, ...}: {
    services.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      aurorae
      plasma-browser-integration
      plasma-workspace-wallpapers
      konsole
      kwin-x11
      qttools # Expose qdbus in PATH
      ark
      elisa
      gwenview
      okular
      kate
      ktexteditor # provides elevated actions for kate
      khelpcenter
      dolphin
      baloo-widgets # baloo information in Dolphin
      dolphin-plugins
      spectacle
      ffmpegthumbs
      krdp
      kconfig # required for xdg-terminal from xdg-utils
      qtbase # for qtpaths which is required for xdg-mime from xdg-utils
      discover
      qrca
      kwallet
    ];
  };
}
