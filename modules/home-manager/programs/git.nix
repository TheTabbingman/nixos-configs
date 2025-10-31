{...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        email = "51281790+TheTabbingman@users.noreply.github.com";
        name = "TheTabbingMan";
      };
      credential.helper = "store";
    };
  };
}
