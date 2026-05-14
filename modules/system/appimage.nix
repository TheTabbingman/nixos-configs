{...}: {
  flake.nixosModules.system = {...}: {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
