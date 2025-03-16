{...}: {
  programs.git = {
    enable = true;
    userEmail = "51281790+TheTabbingman@users.noreply.github.com";
    userName = "TheTabbingMan";
    extraConfig = {
      credential.helper = "store";
    };
    lfs.enable = true;
  };
}
