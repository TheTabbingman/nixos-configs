{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./audio.nix
    ./bootloader.nix
    ./fonts.nix
    ./keymap.nix
    ./locale.nix
    ./networking.nix
    ./print.nix
    ./substituters.nix
    ./system.nix
    ./users.nix
    ./zram.nix
  ];
  # stylix = {
  #   enable = true;
  #   base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";
  #   # image = "${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/share/hypr/wall2.png";
  #   polarity = "dark";
  #   # If I don't have both of these then a bunch of gnome stuff gets compiled
  #   targets = {
  #     gnome.enable = false;
  #   };
  #   overlays.enable = false;
  # };
  i18n.inputMethod = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";
    # image = "${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/share/hypr/wall2.png";
    polarity = "dark";
  };
}
