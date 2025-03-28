{
  config,
  pkgs,
  pkgs-stable,
  userConfig,
  nhModules,
  ...
}: {
  home.username = "${userConfig.name}";
  home.homeDirectory = "/home/${userConfig.name}";

  home.stateVersion = "24.11";

  imports = [
    "${nhModules}/programs/shell.nix"
    "${nhModules}/programs/git.nix"
    "${nhModules}/programs/gpg.nix"
    "${nhModules}/programs/nh.nix"
    "${nhModules}/programs/neovim.nix"
  ];

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs;
    [
      nodejs_23
      nix-search-cli
      pinentry-gtk2
      nvd
      alejandra
      nixd
    ]
    ++ import "${nhModules}/scripts" {inherit pkgs nhModules;};

  home.shellAliases = {
    cd = ''
      function cd
        if test (count $argv) -eq 0
          # If no argument, change to the default path
          builtin cd /mnt/c/Users/gamer
        else
          # Else behave like normal cd
          builtin cd $argv
        end
      end
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
