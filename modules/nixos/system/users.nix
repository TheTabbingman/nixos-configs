{...}: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jonah = {
    isNormalUser = true;
    description = "Jonah";
    extraGroups = ["networkmanager" "wheel"];
  };

  # Enable automatic login for the user.
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "jonah";
}
