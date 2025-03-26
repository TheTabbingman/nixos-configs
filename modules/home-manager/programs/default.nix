{pkgs, ...}: {
  imports = [
    ./git.nix
    ./gpg.nix
    ./neovim.nix
    ./nh.nix
    ./shell.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    nix-search-cli
    firefox
    floorp
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
  ];
}
