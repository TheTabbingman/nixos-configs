{...}: {
  flake.homeModules.persist = {...}: let
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
          "openvpn" # TODO: Make this sops-nix
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
          "bottles"
          "cartridges"
          "chatterino"
          "containers"
          "direnv/allow"
          "dolphin/view_properties"
          "eden"
          "flatpak"
          "gwenview/recentfolders"
          "icons" # The icons for distrobox-export stuff is here
          "jellyfin-desktop"
          "nvim"
          "osu"
          "plex"
          "Plexamp"
          "PrismLauncher"
          "qBittorrent"
          "remmina"
          "Steam"
          "Tabletop Simulator"
          "Trash"
          "umu"
          "waydroid/data"
          "xdg-desktop-portal" # Has some icons from bottles
        ]
        ++ mkPaths ".config" [
          "bcompare5"
          "calibre"
          "chromium"
          "DankMaterialShell/plugins/nvidiaGpuMonitor"
          "eden"
          "fcitx5"
          "freerdp/server" # Required to remember remmina certificates
          "GIMP"
          "heroic"
          "hypr/dms"
          "koreader"
          "libreoffice"
          "mozc"
          "mozilla" # TODO: Should remove when I feel satisfied with librewolf
          "niri/dms"
          "nix"
          "OpenTabletDriver"
          "plex-mpv-shim"
          "Plexamp"
          "qBittorrent"
          "QDirStat"
          "remmina"
          "Ryujinx"
          "screen_ai"
          "solaar"
          "ulauncher"
          "unity3d/Berserk Games/Tabletop Simulator"
          "Z-Library"
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
          "ark/ark_recentfiles"
          "fish/fish_history"
          "fsearch/fsearch.db"
          "recently-used.xbel"
          "user-places.xbel"
        ]
        ++ mkPaths ".config" [
          "DankMaterialShell/plugin_settings.json"
          "dolphinrc"
          "fsearch/fsearch.conf"
          "gwenviewrc"
          "nixpkgs/config.nix"
          "sops/age/keys.txt" # Very important
        ];
    };
  };
}
