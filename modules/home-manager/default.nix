{...}: {
  nix.gc = {
    automatic = true;
    frequency = "03:15";
    options = "--delete-older-than 14d";
  };
}
