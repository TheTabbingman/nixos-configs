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
      testflakeloc = "echo '${flakeLocation}'";
      he = "nvim ${flakeLocation}/hosts/${hostname}/home.nix";
      hms = "home-manager switch --flake ${pathFlakeLocation} && chd";
      hmu = "nix flake update --flake ${pathFlakeLocation}";
      hmsu = "hmu && hms";
      hd = "nvd diff $(home-manager generations | sed 's/.*-> //' | head -n 2 | tail -n 1) $(home-manager generations | sed 's/.*-> //' | head -n 1)";
      ne = "nvim ${flakeLocation}/hosts/${hostname}/configuration.nix";
      fe = "nvim ${flakeLocation}/flake.nix";
      nrs = "sudo nixos-rebuild switch && cnd";
      nrsu = "nu && nrs";
      nrb = "sudo nixos-rebuild boot && cnbd";
      nrbu = "nu && nrb";
      nrt = "sudo nixos-rebuild test && ntd";
      nhe = "nvim ${flakeLocation}/hosts/${hostname}/configuration.nix ${flakeLocation}/hosts/${hostname}/home.nix";
      nu = "nix flake update --flake ${pathFlakeLocation}";
      nd = "nvd diff $(ls -1d /nix/var/nix/profiles/system-* | sort -V | tail -n 2 | head -n 1) /run/current-system/";
      nbd = "nvd diff /run/current-system/ $(ls -1d /nix/var/nix/profiles/system-* | sort -V | tail -n 1)";
      ntd = "nvd diff $(ls -1d /nix/var/nix/profiles/system-* | sort -V | tail -n 1) /run/current-system/";
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
