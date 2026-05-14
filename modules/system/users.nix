{...}: {
  flake.nixosModules.system = {
    config,
    lib,
    ...
  }: {
    options.preferences = {
      user.name = lib.mkOption {
        type = lib.types.str;
        default = "jonah";
      };
    };
    config = {
      users.mutableUsers = false;
      sops.secrets.jonah-password.neededForUsers = true;
      users.users.${config.preferences.user.name} = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets.jonah-password.path;
        description = "${config.preferences.user.name}";
        extraGroups = ["networkmanager" "wheel" "gamemode"];
      };
      # Enable automatic login for the user.
      # services.displayManager.autoLogin.enable = true;
      # services.displayManager.autoLogin.user = "jonah";
    };
  };
}
