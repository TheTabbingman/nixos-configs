{...}: {
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
}
