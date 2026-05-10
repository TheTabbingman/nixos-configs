{inputs, ...}: {
  flake.nixosModules.system = {
    pkgs,
    lib,
    config,
    ...
  }: let
    # Create a list of targets based on enabled WMs
    enabledWmTargets =
      (lib.optionals config.programs.hyprland.enable ["hyprland-session.target"])
      ++ (lib.optionals config.programs.niri.enable ["niri.service"]);
    # Determine the target string
    finalTarget =
      if (lib.length enabledWmTargets == 1)
      then (lib.head enabledWmTargets)
      else "graphical-session.target";
  in {
    imports = [
      inputs.dms.nixosModules.dank-material-shell
    ];
    systemd.user.services.niri-flake-polkit.enable = false;
    programs.dsearch.enable = true;
    programs.dms-shell = {
      enable = true;
      package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
      systemd.target = finalTarget;
      systemd.restartIfChanged = true;
    };
  };
}
