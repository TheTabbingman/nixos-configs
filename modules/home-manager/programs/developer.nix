{...}: {
  flake.homeModules.developer = {pkgs, ...}: {
    home.packages = with pkgs; [
      vscode
    ];
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
