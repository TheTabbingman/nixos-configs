{
  hostname,
  pkgs,
  ...
}: {
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

  security.sudo = {
    extraConfig = ''
      Defaults pwfeedback
    '';
    extraRules = [
      {
        groups = ["wheel"];
        commands = [
          {
            command = "/run/current-system/sw/bin/systemctl start wg-quick-wg0";
            options = ["NOPASSWD"];
          }
          {
            command = "/run/current-system/sw/bin/systemctl stop wg-quick-wg0";
            options = ["NOPASSWD"];
          }
          {
            command = "/run/current-system/sw/bin/systemctl start wg-quick-wg1";
            options = ["NOPASSWD"];
          }
          {
            command = "/run/current-system/sw/bin/systemctl stop wg-quick-wg1";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
