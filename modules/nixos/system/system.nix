{hostname, ...}: {
  networking.hostName = hostname; # Define your hostname.

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];

    optimise = {
      automatic = true;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  security.sudo.extraConfig = ''
    Defaults pwfeedback
  '';
}
