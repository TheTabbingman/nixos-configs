{lib, ...}: {
  environment.persistence."/persist" = {
    enable = lib.mkDefault true; # NB: Defaults to true, not needed
    hideMounts = true;
    allowTrash = true;
    directories = [
      {
        directory = "/etc/nixos";
        user = "jonah";
        group = "users";
        mode = "u=rwx,g=r,o=";
      }
      "/etc/ssh"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/var/db/sudo/lectured"
      "/var/lib/tailscale"
      "/var/lib/btrfs"
      "/var/lib/upower"
      "/var/lib/waydroid"
      "/root/.cache/nix" # Needed so it doesn't reclone repos on every boot
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
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
}
