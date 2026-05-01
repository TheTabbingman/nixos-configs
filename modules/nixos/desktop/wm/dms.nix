{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  systemd.user.services.niri-flake-polkit.enable = false;
  programs.dsearch.enable = true;
  programs.dms-shell = {
    enable = true;
    package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
    systemd.target = "niri.service";
    systemd.restartIfChanged = true;
  };
}
