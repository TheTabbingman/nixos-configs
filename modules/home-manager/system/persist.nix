{...}: let
  mkPaths = base: paths: map (p: "${base}/${p}") paths;
in {
  home.persistence."/persist" = {
    directories =
      [
        "Downloads"
        "Pictures"
        "Documents"
        "Videos"
        "Calibre Library"
        "Games"
        "openvpn"
        "persist"
        ".local/state"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
      ]
      ++ mkPaths ".local/share" [
        "direnv"
        "Steam"
        "containers"
        "bottles"
        "Anki2"
        "flatpak"
        "waydroid"
        "PrismLauncher"
        "eden"
        "umu"
        "nvim"
        "Trash"
        "fsearch"
        "Tabletop Simulator"
        "cartridges"
        "chatterino"
        "fish"
        "jellyfin-desktop"
        "osu"
        "plex"
        "Plexamp"
        "qBittorrent"
        "ark"
        "dolphin"
        "gwenview"
        "icons"
        "remmina"
        "xdg-desktop-portal" # Has some icons from bottles
      ]
      ++ mkPaths ".config" [
        "nix"
        "DankMaterialShell"
        "GIMP"
        "OpenTabletDriver"
        "Plexamp"
        "Ryujinx"
        "Z-Library"
        "eden"
        "fsearch"
        "heroic"
        "koreader"
        "libreoffice"
        "mozc"
        "fcitx5"
        "mozilla"
        "qBittorrent"
        "screen_ai"
        "unity3d"
        "hypr/dms"
        "niri/dms"
        "bcompare5"
        "calibre"
        "chromium"
        "nixpkgs"
        "plex-mpv-shim"
        "QDirStat"
        "remmina"
        "solaar"
        "sops" # Very important
        "ulauncher"
      ];
    files =
      [
      ]
      ++ mkPaths ".local/share" [
        "recently-used.xbel"
        "user-places.xbel"
      ]
      ++ mkPaths ".config" [
        "dolphinrc"
        "gwenviewrc"
      ];
  };
}
