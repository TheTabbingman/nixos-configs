{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.system = {pkgs, ...}: {
    imports = [
      inputs.nix-index-database.nixosModules.nix-index
      self.nixosModules.shell
      self.nixosModules.waydroid
      self.nixosModules.distrobox
    ];
    environment.systemPackages = with pkgs; [
      ghostty
      linux-wallpaperengine
      kdiskmark
      kopia-ui
      tor-browser
      puddletag
      gparted-full
    ];
    programs.nix-index-database.comma.enable = true;

    programs.kdeconnect.enable = true;
  };
  flake.homeModules.programs = {pkgs, ...}: {
    home.packages = with pkgs; [
      nix-search-cli
      chafa
      tealdeer
      nix-inspect
      mission-center
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
      telegram-desktop
      whatsie
      ouch-rar
      thunderbird
    ];

    dconf.settings = {
      "io/missioncenter/MissionCenter" = {
        performance-sidebar-hidden-graphs = "net-enp8s0;net-ip6tnl0;net-wlp9s0";
        apps-page-merged-process-stats = true;
      };
    };

    services.syncthing.enable = true;

    services.kdeconnect.indicator = true;

    xdg.desktopEntries.fat-boy = {
      name = "Connect to fat-boy";
      comment = "Remote Desktop to fat-boy";
      exec = "remmina -c /home/jonah/.local/share/remmina/group_rdp_fat-boy_fat-boy.remmina"; # TODO: Make this file declared
      terminal = false;
      type = "Application";
      icon = "org.remmina.Remmina";
      categories = ["Network" "RemoteAccess"];
    };

    programs.lazygit = {
      enable = true;
      settings = {
        git.overrideGpg = true;
      };
    };

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
        "application/zip" = "org.kde.ark.desktop";
        "application/x-rar" = "org.kde.ark.desktop";
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
  };
}
