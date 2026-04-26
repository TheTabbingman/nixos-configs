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
  ];

  home.packages = with pkgs; [
    nix-search-cli
    gh
    lazygit
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
    anki-bin
    remmina
    chatterino2
    ungoogled-chromium
    koreader
    calibre
    plex-desktop
    plex-mpv-shim
    plexamp
    jellyfin-desktop
    jellyfin-mpv-shim
    gimp
    ffmpeg
    ncdu
    z-library-desktop
    soundconverter
    qbittorrent
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
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
  };
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
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
    };
  };
}
