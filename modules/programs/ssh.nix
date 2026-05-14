{...}: {
  flake.homeModules.programs = {config, ...}: {
    services.ssh-agent.enable = true;
    sops.secrets.github-ssh = {};
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*".addKeysToAgent = "yes";
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = config.sops.secrets.github-ssh.path;
        };
      };
    };
  };
}
