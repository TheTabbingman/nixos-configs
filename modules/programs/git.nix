{...}: {
  flake.homeModules.programs = {...}: {
    programs.git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user = {
          email = "51281790+TheTabbingman@users.noreply.github.com";
          name = "TheTabbingMan";
        };
        credential.helper = "cache --timeout 3600";
      };
      signing = {
        format = "ssh";
        signByDefault = true;
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMeQLDYA1qvze3jRtokPl1q49UMKFNOyTFisntYe1siI 51281790+TheTabbingman@users.noreply.github.com";
      };
    };
  };
}
