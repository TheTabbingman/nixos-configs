{...}: {
  flake.homeModules.programs = {config, ...}: {
    sops.secrets."ssh/github" = {};
    sops.secrets."ssh/gamer" = {};
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        addKeysToAgent = "yes"; # TODO: Make this timeout
        identityFile = config.sops.secrets."ssh/gamer".path;
      };
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = config.sops.secrets."ssh/github".path;
        };
      };
    };
  };
}
