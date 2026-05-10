{...}: {
  flake.nixosModules.system = {config, ...}: {
    users.mutableUsers = false;
    sops.secrets.jonah-password.neededForUsers = true;
    users.users.jonah = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.jonah-password.path;
      description = "Jonah";
      extraGroups = ["networkmanager" "wheel" "gamemode"];
    };

    # Enable automatic login for the user.
    # services.displayManager.autoLogin.enable = true;
    # services.displayManager.autoLogin.user = "jonah";
  };
}
