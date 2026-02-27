{pkgs, ...}: {
  home.packages = with pkgs; [
    neovim
    clang
    clang-tools
    nixd
    alejandra
    unzip
    gnumake
    ripgrep
    wl-clipboard
    xclip
    nodejs
  ];
}
