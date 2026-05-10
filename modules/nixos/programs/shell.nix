{...}: {
  flake.nixosModules.shell = {pkgs, ...}: {
    programs.fish.enable = true;
    users.users.jonah.shell = pkgs.fish;
    # Fixes stuff trying to access /bin/bash
    services.envfs.enable = true;
  };
}
