{inputs, ...}: {
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
        # rm = "rm -I";
        rm = ''echo "This is not the command you are looking for. Use tp. Or \rm (command rm on fish) if you REALLY need it."; false'';
        tp = "${pkgs.trash-cli}/bin/trash-put";
        fish-reload = "source ~/.config/fish/**/*.fish";
        # Stop all vpn
        vpnoff = "wcd && wpd && ocd && opd";
        # Windscribe chicago
        wcu = "vpnoff && sudo systemctl start wg-quick-wg0";
        wcd = "sudo systemctl stop wg-quick-wg0";
        # Windscribe portugal
        wpu = "vpnoff && sudo systemctl start wg-quick-wg1";
        wpd = "sudo systemctl stop wg-quick-wg1";
        # Openvpn chicago
        ocu = "vpnoff && sudo systemctl start openvpn-chicago";
        ocd = "sudo systemctl stop openvpn-chicago";
        # Openvpn portugal
        opu = "vpnoff && sudo systemctl start openvpn-portugal";
        opd = "sudo systemctl stop openvpn-portugal";
      };
      packages = with pkgs; [
        trash-cli
      ];
    };
    programs = {
      bash.enable = true;
      fish.enable = true;
      nix-index.enable = true;
    };
    imports = [
      inputs.nix-index-database.homeModules.default
    ];
  };
}
