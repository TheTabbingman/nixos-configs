{
  pkgs,
  inputs,
  self,
  ...
}: {
  flake.nixosModules.hyprland = {pkgs, ...}: {
    imports = [
      self.nixosModules.wmCommon
    ];
    # Enable hyprland
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    # Optional, hint electron apps to use wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.systemPackages = with pkgs; [
      # inputs.hyprsession.packages.${pkgs.stdenv.hostPlatform.system}.hyprsession
    ];
  };
}
