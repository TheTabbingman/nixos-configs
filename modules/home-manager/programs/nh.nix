{...}: {
  flake.homeModules.programs = {...}: {
    programs.nh = {
      enable = true;
      flake = "/etc/nixos";
    };
  };
}
