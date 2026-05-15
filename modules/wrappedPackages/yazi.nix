{self, ...}: {
  flake.wrappers.yazi = {
    wlib,
    pkgs,
    lib,
    config,
    ...
  }: {
    imports = [wlib.wrapperModules.yazi];
    extraPackages = with pkgs; [
      ffmpegthumbnailer
      exiftool
      mediainfo
      lazygit
    ];
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
      what-size-yazi = pkgs.stdenv.mkDerivation {
        name = "what-size.yazi";
        src = pkgs.fetchFromGitHub {
          owner = "pirafrank";
          repo = "what-size.yazi";
          rev = "179ebf69c9c3ade40cacc0f25e9557a43427c6ca";
          sha256 = "sha256-7q/45TopqbojNRvYDmP9+hgSGPmiyLHBcV051qpOB2Y=";
        };
        installPhase = ''
          runHook preInstall
          cp -r . $out
          runHook postInstall
        '';
      };
      exifaudio-yazi = pkgs.stdenv.mkDerivation {
        name = "exifaudio.yazi";
        src = pkgs.fetchFromGitHub {
          owner = "Sonico98";
          repo = "exifaudio.yazi";
          rev = "4506f9d5032e714c0689be09d566dd877b9d464e";
          sha256 = "sha256-RWCqWBpbmU3sh/A+LBJPXL/AY292blKb/zZXGvIA5/o=";
        };
        installPhase = ''
          runHook preInstall
          cp -r . $out
          runHook postInstall
        '';
      };
    in {
      ffmpegthumbnailer = ffmpegthumbnailer-yazi;
      what-size = what-size-yazi;
      exifaudio = exifaudio-yazi;
      compress = pkgs.yaziPlugins.compress;
      chmod = pkgs.yaziPlugins.chmod;
      lazygit = pkgs.yaziPlugins.lazygit;
    };
    settings = {
      keymap = {
        mgr.prepend_keymap = [
          {
            on = "<C-n>";
            run = "shell -- ${lib.getExe pkgs.ripdrag} %h --and-exit --icons-only --icon-size 64 -W 64 -H 64 --no-click";
          }
          {
            on = "y";
            run = [''shell -- for path in %s; do echo "file://$path"; done | ${lib.getExe' pkgs.wl-clipboard "wl-copy"} -t text/uri-list'' "yank"];
          }
          {
            on = ["g" "r"];
            run = ''shell -- ya emit cd "$(${lib.getExe pkgs.git} rev-parse --show-toplevel)"'';
            desc = "Go to root of git project";
          }
          {
            on = "<C-g>";
            run = ''shell -- ${lib.getExe pkgs.rofi} -theme fullscreen-preview -show filebrowser -filebrowser-command "ya emit reveal" -filebrowser-directory "$(pwd)"'';
            desc = "Grid view";
          }
          {
            on = ["c" "a" "a"];
            run = "plugin compress";
            desc = "Archive selected files";
          }
          {
            on = ["c" "a" "p"];
            run = "plugin compress -p";
            desc = "Archive selected files (password)";
          }
          {
            on = ["c" "a" "h"];
            run = "plugin compress -ph";
            desc = "Archive selected files (password+header)";
          }
          {
            on = ["c" "a" "l"];
            run = "plugin compress -l";
            desc = "Archive selected files (compression level)";
          }
          {
            on = ["c" "a" "u"];
            run = "plugin compress -phl";
            desc = "Archive selected files (password+header+level)";
          }
          {
            on = [">" "s"];
            run = "plugin what-size";
            desc = "Calc size of selection or cwd";
          }
          {
            on = ["c" "m"];
            run = "plugin chmod";
            desc = "Chmod on selected files";
          }
          {
            on = ["g" "i"];
            run = "plugin lazygit";
            desc = "run lazygit";
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
            {
              mime = "audio/*";
              run = "exifaudio";
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
    buildCommand.writeInitLua = {
      after = ["makePluginsAndFlavors"];
      data =
        # lua
        ''
          cat <<EOF > "${config.generatedConfig.placeholder}/init.lua"
          Status:children_add(function()
              local h = cx.active.current.hovered
                  if not h or ya.target_family() ~= "unix" then
                      return ""
                  end

                  return ui.Line {
                      ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
                      ":",
                      ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
                      " ",
              }
          end, 500, Status.RIGHT)
          EOF
        '';
    };
  };
  flake.nixosModules.programs = {
    pkgs,
    config,
    ...
  }: {
    environment.systemPackages = let
      yazi = self.packages.${pkgs.stdenv.hostPlatform.system}.yazi.wrap ({lib, ...}: {
        package = pkgs.yazi.override {_7zz = pkgs._7zz-rar;}; # _7zz-rar is unfree
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
  flake.homeModules.programs = {
    programs.fish.functions = {
      y = ''
        set -l tmp (mktemp -t "yazi-cwd.XXXXX")
        command yazi $argv --cwd-file="$tmp"
        if read cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
          builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
      '';
    };
  };
}
