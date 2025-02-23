{flakeLocation, hostname, ...}: {
  home.sessionVariables = {
    EDITOR = "nvim";
    # NIXPKGS_ALLOW_UNFREE = 1;
  };

  home.shellAliases = 
    let
      pathFlakeLocation = "path:${flakeLocation}";
    in
    {
      # edit
      he = "nvim ${flakeLocation}/hosts/${hostname}/home.nix";
      ne = "nvim ${flakeLocation}/hosts/${hostname}/configuration.nix";
      fe = "nvim ${flakeLocation}/flake.nix";
      nhe = "nvim ${flakeLocation}/hosts/${hostname}/configuration.nix ${flakeLocation}/hosts/${hostname}/home.nix";
      # home-manager
      hms = "home-manager switch --flake ${pathFlakeLocation} && chd";
      # nix
      nrs = "sudo nixos-rebuild switch && cnd";
      nrb = "sudo nixos-rebuild boot && cnbd";
      nrt = "sudo nixos-rebuild test && ntd";
      nu = "nix flake update --flake ${pathFlakeLocation}";
      # diff
      hd = "nvd diff $(home-manager generations | sed 's/.*-> //' | head -n 2 | tail -n 1) $(home-manager generations | sed 's/.*-> //' | head -n 1)";
      nd = "nvd diff $(ls -1d /nix/var/nix/profiles/system-* | sort -V | tail -n 2 | head -n 1) /run/current-system/";
      nbd = "nvd diff /run/current-system/ $(ls -1d /nix/var/nix/profiles/system-* | sort -V | tail -n 1)";
      ntd = "nvd diff $(ls -1d /nix/var/nix/profiles/system-* | sort -V | tail -n 1) /run/current-system/";
      # other
      rm = "rm -I";
      fish-reload = "source ~/.config/fish/**/*.fish";
  };
  programs.bash = {
    enable = true;
  };
  programs.zsh = {
    enable = true;
  };
  programs.fish = {
    enable = true;
  };
}
