{...}: {
  flake.homeModules.developer = {pkgs, ...}: {
    home.packages = with pkgs; [
    ];
    programs = {
      # vscodium.enable = true;
      # zed-editor.enable = true;
      # helix = {
      #   enable = true;
      #   extraPackages = with pkgs; [
      #     nixd
      #   ];
      # };

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
  };
}
