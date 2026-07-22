{inputs, ...}: {
  flake.nixosModules.shell = {pkgs, ...}: {
    programs.fish.enable = true;
    users.users.jonah.shell = pkgs.fish;
    # Fixes stuff trying to access /bin/bash
    services.envfs.enable = true;
  };
  flake.homeModules.programs = {
    lib,
    pkgs,
    osConfig,
    ...
  }: {
    home = {
      sessionVariables = {
        EDITOR = "nvim";
      };

      shellAliases = let
        pathFlakeLocation = "path:${osConfig.preferences.flakeLocation}";
      in {
        # edit
        ne = "pushd ${osConfig.preferences.flakeLocation} && nvim . && popd";
        # home-manager
        # hms = "home-manager switch --flake ${pathFlakeLocation} && chd";
        # nix
        nrs = "sudo nixos-rebuild switch --flake ${pathFlakeLocation} && cnd";
        nrb = "sudo nixos-rebuild boot --flake ${pathFlakeLocation} && cnbd";
        nrt = "sudo nixos-rebuild test --flake ${pathFlakeLocation} && ntd";
        nu = "nix flake update --flake ${pathFlakeLocation}";
        # diff
        hd = "${lib.getExe pkgs.nvd} diff $(home-manager generations | sed 's/.*-> //' | head -n 2 | tail -n 1) $(home-manager generations | sed 's/.*-> //' | sed 's/ (current)//' | head -n 1)";
        nd = "${lib.getExe pkgs.nvd} diff $(ls -1d /nix/var/nix/profiles/system-* | sort -V | tail -n 2 | head -n 1) /run/current-system/";
        nbd = "${lib.getExe pkgs.nvd} diff /run/current-system/ $(ls -1d /nix/var/nix/profiles/system-* | sort -V | tail -n 1)";
        ntd = "${lib.getExe pkgs.nvd} diff $(ls -1d /nix/var/nix/profiles/system-* | sort -V | tail -n 1) /run/current-system/";
        # other
        rm = "rm -I";
        # rm = ''echo "This is not the command you are looking for. Use tp. Or \rm (command rm on fish) if you REALLY need it."; false'';
        tp = "${pkgs.gtrash}/bin/gtrash put";
        t = "${pkgs.gtrash}/bin/gtrash";
        fish-reload = "source ~/.config/fish/**/*.fish";
        # Stop all vpn
        vpnoff = "wcd && wpd && wtd && ocd && opd";
        # Windscribe chicago
        wcu = "vpnoff && sudo systemctl start wg-quick-wg0";
        wcd = "sudo systemctl stop wg-quick-wg0";
        # Windscribe portugal
        wpu = "vpnoff && sudo systemctl start wg-quick-wg1";
        wpd = "sudo systemctl stop wg-quick-wg1";
        # Windscribe tokyo
        wtu = "vpnoff && sudo systemctl start wg-quick-wg2";
        wtd = "sudo systemctl stop wg-quick-wg2";
        # Openvpn chicago
        ocu = "vpnoff && sudo systemctl start openvpn-chicago";
        ocd = "sudo systemctl stop openvpn-chicago";
        # Openvpn portugal
        opu = "vpnoff && sudo systemctl start openvpn-portugal";
        opd = "sudo systemctl stop openvpn-portugal";

        json2nix = "nix run github:sempruijs/json2nix";
        nix-alien = "nix run github:thiagokokada/nix-alien --";
      };
      packages = with pkgs; [
        gtrash
      ];
    };
    programs = {
      bash.enable = true;
      fish = {
        enable = true;
        functions = {
          fish_user_key_bindings = {
            body = "fish_vi_key_bindings";
          };
        };
      };
      nix-index.enable = true;
      zoxide.enable = true;
    };
    imports = [
      inputs.nix-index-database.homeModules.default
    ];
  };
}
