{hostname, ...}: {
  networking.hostName = hostname; # Define your hostname.

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nix.optimise = {
    automatic = true;
  };
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
