{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  systemd.user.services.niri-flake-polkit.enable = false;
  programs.dsearch.enable = true;
}
