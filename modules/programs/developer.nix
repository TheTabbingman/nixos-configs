{...}: {
  flake.homeModules.developer = {pkgs, ...}: {
    home.packages = with pkgs; [
      vscodium
    ];
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
