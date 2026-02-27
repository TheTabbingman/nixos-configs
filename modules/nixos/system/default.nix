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
    # These should be enable with gnome if I don't want a bunch of stuff to be compiled
    # targets = {
    #   gnome.enable = false;
    # };
    # overlays.enable = false;
  };
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc-ut
        fcitx5-gtk
      ];
    };
  };
}
