{inputs, ...}: {
  flake.nixosModules.impermanence = {lib, ...}: let
    mkPaths = base: paths: map (p: "${base}/${p}") paths;
  in {
    imports = [
      inputs.impermanence.nixosModules.impermanence
    ];
    environment.persistence."/persist" = {
      enable = lib.mkDefault true; # NB: Defaults to true, not needed
      hideMounts = true;
      allowTrash = true;
      directories =
        [
          {
            directory = "/etc/nixos";
            user = "jonah";
            group = "users";
            mode = "u=rwx,g=r,o=";
          }
          "/etc/NetworkManager/system-connections"
          "/etc/ssh"
          "/root/.cache/nix" # Needed so it doesn't reclone repos on every boot
          "/var/db/sudo/lectured"
          "/var/log"
          {
            # Need to make sure that /var/lib/private has 0700 permissions
            directory = "/var/lib/private/ollama";
            mode = "u=rwx,g=,o=";
          }
          {
            directory = "/var/lib/colord";
            user = "colord";
            group = "colord";
            mode = "u=rwx,g=rx,o=";
          }
        ]
        ++ mkPaths "/var/lib" [
          "bluetooth"
          "btrfs"
          "nixos"
          "systemd/coredump"
          "tailscale"
          "upower"
          "waydroid"
        ];
      files = [
        "/etc/machine-id"
        "/var/lib/regreet/state.toml"
        # {
        #   file = "/var/keys/secret_file";
        #   parentDirectory = {mode = "u=rwx,g=,o=";};
        # }
      ];
    };
  };
  flake.homeModules.persist = {...}: let
    mkPaths = base: paths: map (p: "${base}/${p}") paths;
  in {
    home.persistence."/persist" = {
      directories =
        [
          ".librewolf"
          ".local/state"
          ".mozilla/native-messaging-hosts"
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
          "osu"
          "plex"
          "Plexamp"
          "PrismLauncher"
          "qBittorrent"
          "remmina"
          "Steam"
          "Tabletop Simulator"
          "TelegramDesktop"
          "Trash"
          "umu"
          "waydroid/data"
          "xdg-desktop-portal" # Has some icons from bottles
          "zoxide" # Has to be the folder because it overrites the file
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
