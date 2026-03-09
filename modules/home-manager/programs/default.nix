{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./git.nix
    ./gpg.nix
    ./neovim.nix
    ./nh.nix
    ./shell.nix
    ./flatpaks.nix
    ./firefox.nix
  ];

  home.packages = with pkgs; [
    nix-search-cli
    firefox
    gh
    github-desktop
    nvd
    alejandra
    nixd
    alacritty-graphics
    chafa
    tealdeer
    nix-inspect
    mission-center
    fastfetch
    htop
    pinentry-gtk2
    compsize
    distroshelf
    ptyxis
    mpv
    meld
    fsearch
    inputs.json2nix.packages.${pkgs.stdenv.hostPlatform.system}.json2nix
    libreoffice-fresh
  ];
}
