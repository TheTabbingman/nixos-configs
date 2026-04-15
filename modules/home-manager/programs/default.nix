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
    ./firefox
    ./owocr.nix
  ];

  home.packages = with pkgs; [
    nix-search-cli
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
    anki-bin
    remmina
    chatterino2
    ungoogled-chromium
    koreader
  ];
  xdg.desktopEntries.fat-boy = {
    name = "Connect to fat-boy";
    comment = "Remote Desktop to fat-boy";
    exec = "remmina -c /home/jonah/.local/share/remmina/group_rdp_fat-boy_fat-boy.remmina";
    terminal = false;
    type = "Application";
    icon = "org.remmina.Remmina";
    categories = ["Network" "RemoteAccess"];
  };
}
