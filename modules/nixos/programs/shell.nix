{pkgs, ...}: {
  programs.fish.enable = true;
  users.users.jonah.shell = pkgs.fish;
}
