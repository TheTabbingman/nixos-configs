{nix, nixHost, nixFlake, homeFlake, ...}: {
  home.sessionVariables = {
    EDITOR = "nvim";
    # NIXPKGS_ALLOW_UNFREE = 1;
  };

  home.shellAliases = 
    {
      he = "nvim ${nixHost}/home.nix";
      hms = "home-manager switch --flake ${homeFlake} && chd";
      hmu = "nix flake update --flake ${homeFlake}";
      hmsu = "hmu && hms";
      hd = "nvd diff $(home-manager generations | sed 's/.*-> //' | head -n 2 | tail -n 1) $(home-manager generations | sed 's/.*-> //' | head -n 1)";
      ne = "nvim ${nixHost}/configuration.nix";
      fe = "nvim ${nix}/flake.nix";
      nrs = "sudo nixos-rebuild switch --flake ${nixFlake} && cnd";
      nrsu = "nu && nrs";
      nrb = "sudo nixos-rebuild boot --flake ${nixFlake} && cnbd";
      nrbu = "nu && nrb";
      nrt = "sudo nixos-rebuild test --flake ${nixFlake} && ntd";
      nhe = "nvim ${nixHost}/configuration.nix ${nixHost}/home.nix";
      nu = "nix flake update --flake ${nix}";
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
