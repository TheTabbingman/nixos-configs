{...}: {
  flake.homeModules.programs = {pkgs, ...}: {
    services.flatpak = {
      enable = true;
      uninstallUnmanaged = true;
      update.onActivation = true;
      packages = [
        rec {
          appId = "org.flybywiresim.installer";
          sha256 = "sha256-S68PYfVv5UqXf4yhwnHRth8MNMj43tQu9+6TitlMoac=";
          bundle = "${pkgs.fetchurl {
            url = "https://github.com/flybywiresim/installer/releases/download/v3.7.0/FlyByWire-Installer-3.7.0-x86_64.flatpak";
            inherit sha256;
          }}";
        }
      ];
    };
  };
}
