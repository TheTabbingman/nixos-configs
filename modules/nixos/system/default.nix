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
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";
    # image = "${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/share/hypr/wall2.png";
    polarity = "dark";
  };
}
