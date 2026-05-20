{...}: {
  flake.homeModules.programs = {config, ...}: {
    sops.secrets."ssh/github" = {};
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings."*".addKeysToAgent = "yes"; # TODO: Make this timeout
      settings = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = config.sops.secrets."ssh/github".path;
        };
      };
    };
  };
}
