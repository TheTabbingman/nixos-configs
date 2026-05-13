{self, ...}: {
  flake.wrappers.yazi = {
    wlib,
    pkgs,
    lib,
    ...
  }: {
    imports = [wlib.wrapperModules.yazi];
    extraPackages = with pkgs; [
      ffmpegthumbnailer
      exiftool
    ];
    aliases = ["y"];
    plugins = let
      ffmpegthumbnailer-yazi = pkgs.stdenv.mkDerivation {
        name = "ffmpegthumbnailer.yazi";
        src = pkgs.fetchFromGitHub {
          owner = "ze0987";
          repo = "ffmpegthumbnailer.yazi";
          rev = "b0e5cc8278181a8bdcb9442d2f9307a05d0e0525";
          sha256 = "sha256-CTTeywF+hlxYRi2wgdbGoogyrIGrZoWTNuqTC9wA92g=";
        };
        installPhase = ''
          runHook preInstall
          cp -r . $out
          runHook postInstall
        '';
      };
    in {
      ffmpegthumbnailer = ffmpegthumbnailer-yazi;
    };
    settings = {
      keymap = {
        mgr.prepend_keymap = [
          {
            on = "<C-n>";
            run = "shell -- ${lib.getExe pkgs.ripdrag} %h --and-exit --icons-only --icon-size 64 -W 64 -H 64 --no-click";
          }
        ];
      };
      yazi = {
        opener = {
          set-wallpaper = [
            {
              run = "dms ipc wallpaper set %s1";
              desc = "Set as wallpaper";
            }
          ];
        };
        open = {
          prepend_rules = [
            {
              mime = "image/*";
              use = ["open" "reveal" "set-wallpaper"];
            }
          ];
        };
        plugin = {
          prepend_previewers = [
            {
              mime = "video/*";
              run = "ffmpegthumbnailer";
            }
          ];
          prepend_preloaders = [
            {
              mime = "video/*";
              run = "ffmpegthumbnailer";
            }
          ];
        };
      };
    };
  };
  flake.nixosModules.programs = {
    pkgs,
    config,
    ...
  }: {
    environment.systemPackages = let
      yazi = self.packages.${pkgs.stdenv.hostPlatform.system}.yazi.wrap ({lib, ...}: {
        settings.yazi.opener = {
          play = lib.mkIf (config.networking.hostName == "nixos-laptop") [
            # TODO: Make sure that this has actually worked
            {
              run = "mpv --hwdec=auto --vulkan-device='Intel(R) HD Graphics 530 (SKL GT2)' %s";
              orphan = true;
              for = "unix";
            }
          ];
        };
      });
    in [yazi];
  };
}
