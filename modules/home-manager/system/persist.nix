{...}: let
  mkPaths = base: paths: map (p: "${base}/${p}") paths;
in {
  home.persistence."/persist" = {
    directories =
      [
        ".librewolf"
        ".local/state"
        ".mozilla/native-messaging-hosts"
        ".ollama"
        ".steam"
        ".var/app/org.flybywiresim.installer"
        "Calibre Library"
        "Documents"
        "Downloads"
        "Games"
        "openvpn"
        "persist"
        "Pictures"
        "Videos"
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
      ]
      ++ mkPaths ".local/share" [
        "Anki2"
        "Plexamp"
        "PrismLauncher"
        "Steam"
        "Tabletop Simulator"
        "Trash"
        "ark"
        "bottles"
        "cartridges"
        "chatterino"
        "containers"
        "direnv"
        "dolphin"
        "eden"
        "fish"
        "flatpak"
        "fsearch"
        "gwenview"
        "icons"
        "jellyfin-desktop"
        "nvim"
        "osu"
        "plex"
        "qBittorrent"
        "remmina"
        "umu"
        "waydroid"
        "xdg-desktop-portal" # Has some icons from bottles
      ]
      ++ mkPaths ".config" [
        "DankMaterialShell"
        "GIMP"
        "OpenTabletDriver"
        "Plexamp"
        "QDirStat"
        "Ryujinx"
        "Z-Library"
        "bcompare5"
        "calibre"
        "chromium"
        "eden"
        "fcitx5"
        "freerdp/server" # Required to remember remmina certificates
        "fsearch"
        "heroic"
        "hypr/dms"
        "koreader"
        "libreoffice"
        "mozc"
        "mozilla"
        "niri/dms"
        "nix"
        "nixpkgs"
        "plex-mpv-shim"
        "qBittorrent"
        "remmina"
        "screen_ai"
        "solaar"
        "sops" # Very important
        "ulauncher"
        "unity3d"
      ];
    files =
      [
        ".bash_history"
        ".lazygit/newdir"
        {
          file = ".ssh/known_hosts";
          parentDirectory.mode = "0700";
        }
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
