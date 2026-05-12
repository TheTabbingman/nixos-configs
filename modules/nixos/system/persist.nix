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
}
