{inputs, ...}: {
  flake.nixosModules.system = {pkgs, ...}: {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";
      # image = "${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/share/hypr/wall2.png";
      polarity = "dark";
      # Maybe need if using gnome/kde at the same time as wm
      # targets.qt.platform = lib.mkForce "qtct";
      # These should be enable with gnome if I don't want a bunch of stuff to be compiled
      # targets = {
      #   gnome.enable = false;
      # };
      # overlays.enable = false;
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
      fonts = {
        serif = {
          package = pkgs.noto-fonts;
          name = "Noto Serif";
        };
        sansSerif = {
          package = pkgs.inter;
          name = "Inter";
        };
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetbrainsMono Nerd Font";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
      targets.plymouth.enable = false;
    };
  };
}
