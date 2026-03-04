{pkgs, ...}: {
  imports = [
    ./git.nix
    ./gpg.nix
    ./neovim.nix
    ./nh.nix
    ./shell.nix
    ./flatpaks.nix
  ];

  home.packages = with pkgs; [
    nix-search-cli
    firefox
    floorp-bin
    gh
    github-desktop
    nvd
    alejandra
    nixd
    alacritty
    foot
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
  ];
}
