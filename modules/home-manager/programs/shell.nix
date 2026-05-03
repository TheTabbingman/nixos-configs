{
  flakeLocation,
  hostname,
  config,
  pkgs,
  ...
}: {
  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };

    shellAliases = let
      pathFlakeLocation = "path:${flakeLocation}";
    in {
      # edit
      he = "nvim ${flakeLocation}/hosts/${hostname}/home.nix";
      nce = "nvim ${flakeLocation}/hosts/${hostname}/configuration.nix";
      fe = "nvim ${flakeLocation}/flake.nix";
      nhe = "nvim ${flakeLocation}/hosts/${hostname}/configuration.nix ${flakeLocation}/hosts/${hostname}/home.nix";
      ne = "pushd ${flakeLocation} && nvim . && popd";
      # home-manager
      # hms = "home-manager switch --flake ${pathFlakeLocation} && chd";
      # nix
      nrs = "sudo nixos-rebuild switch --flake ${pathFlakeLocation} && cnd && systemctl --user restart elephant";
      nrb = "sudo nixos-rebuild boot --flake ${pathFlakeLocation} && cnbd";
      nrt = "sudo nixos-rebuild test --flake ${pathFlakeLocation} && ntd && systemctl --user restart elephant";
      nu = "nix flake update --flake ${pathFlakeLocation}";
      # diff
      hd = "nvd diff $(home-manager generations | sed 's/.*-> //' | head -n 2 | tail -n 1) $(home-manager generations | sed 's/.*-> //' | sed 's/ (current)//' | head -n 1)";
      nd = "nvd diff $(ls -1d /nix/var/nix/profiles/system-* | sort -V | tail -n 2 | head -n 1) /run/current-system/";
      nbd = "nvd diff /run/current-system/ $(ls -1d /nix/var/nix/profiles/system-* | sort -V | tail -n 1)";
      ntd = "nvd diff $(ls -1d /nix/var/nix/profiles/system-* | sort -V | tail -n 1) /run/current-system/";
      # other
      # rm = "rm -I";
      rm = ''echo "This is not the command you are looking for. Use tp. Or \rm (command rm on fish) if you REALLY need it."; false'';
      tp = "${pkgs.trashy}/bin/trash put";
      fish-reload = "source ~/.config/fish/**/*.fish";
      wsu = "sudo systemctl start wg-quick-wg0";
      wsd = "sudo systemctl stop wg-quick-wg0";
    };
    packages = with pkgs; [
      trashy
    ];
  };
  programs = {
    bash.enable = true;
    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
    };
    fish.enable = true;
    nix-index.enable = true;
  };
}
