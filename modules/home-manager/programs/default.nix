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
    ./mpv.nix
    ./ssh.nix
  ];

  home.packages = with pkgs; [
    nix-search-cli
    nvd
    alejandra
    nixd
    alacritty-graphics
    chafa
    tealdeer
    nix-inspect
    mission-center
    pinentry-gtk2
    meld
    kdiff3
    fsearch
    inputs.json2nix.packages.${pkgs.stdenv.hostPlatform.system}.json2nix
    libreoffice-fresh
    anki
    remmina
    chatterino2
    ungoogled-chromium
    koreader
    calibre
    plex-desktop
    plexamp
    jellyfin-desktop
    jellyfin-mpv-shim
    gimp
    ffmpeg
    btdu
    qdirstat
    z-library-desktop
    soundconverter
    qbittorrent
  ];
  services.syncthing.enable = true;
  xdg.desktopEntries.fat-boy = {
    name = "Connect to fat-boy";
    comment = "Remote Desktop to fat-boy";
    exec = "remmina -c /home/jonah/.local/share/remmina/group_rdp_fat-boy_fat-boy.remmina";
    terminal = false;
    type = "Application";
    icon = "org.remmina.Remmina";
    categories = ["Network" "RemoteAccess"];
  };
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
  };
  programs.lazygit.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
      "application/x-extension-htm" = "librewolf.desktop";
      "application/x-extension-html" = "librewolf.desktop";
      "application/x-extension-shtml" = "librewolf.desktop";
      "application/x-extension-xht" = "librewolf.desktop";
      "application/x-extension-xhtml" = "librewolf.desktop";
      "application/xhtml+xml" = "librewolf.desktop";
      "x-scheme-handler/chrome" = "librewolf.desktop";
      "application/zip" = "ark.desktop";
      "application/x-rar" = "ark.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/mp4" = "mpv.desktop";
      "audio/x-wav" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "application/vnd.comicbook+zip" = "calibre-ebook-viewer.desktop";
      "text/plain" = "nvim.desktop";
      "application/vnd.microsoft.portable-executable" = "protontricks-launch.desktop";
    };
  };
}
