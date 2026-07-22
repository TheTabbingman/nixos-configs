{...}: {
  flake.homeModules.programs = {
    pkgs,
    lib,
    osConfig,
    ...
  }: {
    programs.yazi = {
      enable = true;
      package = pkgs.yazi.override {
        extraPackages = with pkgs; [
          lazygit
          trash-cli
          mediainfo
          ffmpeg
          imagemagick
        ];
        _7zz = pkgs._7zz-rar; # _7zz-rar is unfree
      };
      shellWrapperName = "y";
      plugins = let
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
        recycle-bin-yazi = pkgs.stdenv.mkDerivation {
          name = "recycle-bin.yazi";
          src = pkgs.fetchFromGitHub {
            owner = "uhs-robert";
            repo = "recycle-bin.yazi";
            rev = "fa687116c46a784e664ef96619b32abf51f29b06";
            hash = "sha256-lpxTGWA15szM5VJ+qvV2+GTg7HXiZaZfyWyjeNMsTSM=";
          };
          installPhase = ''
            runHook preInstall
            cp -r . $out
            runHook postInstall
          '';
        };
      in {
        what-size = what-size-yazi;
        recycle-bin = recycle-bin-yazi;
        compress = pkgs.yaziPlugins.compress;
        chmod = pkgs.yaziPlugins.chmod;
        lazygit = pkgs.yaziPlugins.lazygit;
        git = pkgs.yaziPlugins.git;
        restore = pkgs.yaziPlugins.restore;
        mediainfo = pkgs.yaziPlugins.mediainfo;
      };
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
          {
            on = ["g" "b"];
            run = "cd /mnt/share/fat-boy";
            desc = "Cd to fat-boy";
          }
          {
            on = ["g" "n"];
            run = "cd /etc/nixos";
            desc = "Cd to nix config";
          }
          {
            on = ["g" "p"];
            run = "cd /persist";
            desc = "Cd to /persist";
          }
          {
            on = "T";
            run = "plugin recycle-bin";
            desc = "Open Recycle Bin menu";
          }
          {
            on = "u";
            run = "plugin restore";
            desc = "Restore last deleted files/folders";
          }
          {
            on = "U";
            run = "plugin restore -- --interactive";
            desc = "Restore deleted files/folders (Interactive)";
          }
          {
            on = ["c" "a" "o" "4"];
            run = let
              yazi-ffmpeg-convert-bulk-m4a = pkgs.writeShellScriptBin "yazi-ffmpeg-convert-bulk-m4a" ''
                for input in "$@"; do
                  if [ -f "$input" ]; then
                    output="''${input%.*}.m4a"
                    ${lib.getExe pkgs.ffmpeg} -i "$input" -map 0:a -map 0:v -c copy -map -0:v:0 -disposition:v attached_pic "$output"
                  fi
                done
              '';
            in ''
              shell -- ${lib.getExe yazi-ffmpeg-convert-bulk-m4a} %s;
            '';
          }
          {
            on = ["c" "a" "o" "k"];
            run = let
              yazi-ffmpeg-convert-bulk-mka = pkgs.writeShellScriptBin "yazi-ffmpeg-convert-bulk-mka" ''
                for input in "$@"; do
                  if [ -f "$input" ]; then
                    output="''${input%.*}.mka"
                    ${lib.getExe pkgs.ffmpeg} -i "$input" -map 0:a -map 0:t? -c copy -map_metadata 0 "$output"
                  fi
                done
              '';
            in ''
              shell -- ${lib.getExe yazi-ffmpeg-convert-bulk-mka} %s;
            '';
          }
        ];
      };
      settings = {
        opener = {
          set-wallpaper = [
            {
              run = "dms ipc wallpaper set %s1";
              desc = "Set as wallpaper";
            }
          ];
          play = lib.mkIf (osConfig.networking.hostName == "nixos-laptop") [
            # TODO: Make sure that this has actually worked
            {
              run = "mpv --hwdec=auto --vulkan-device='Intel(R) HD Graphics 530 (SKL GT2)' %s";
              orphan = true;
              for = "unix";
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
            # This doesn't seem to support mka preview image but exifaudio doesn't seem to either
            # Replace magick, image, video with mediainfo
            {
              mime = "{audio,video,image}/*";
              run = "mediainfo";
            }

            # Hide metadata by default.
            # Example for image mimetype:
            # {
            #   mime = "{image}/*";
            #   run = "mediainfo --no-metadata";
            # }

            # Hide image preview by default.
            # Example for video mimetype:
            # {
            #   mime = "{video}/*";
            #   run = "mediainfo --no-preview";
            # }

            # NOTE: Use both --no-metadata and --no-preview will display nothing. :)
            # Make sure both of your previewers and preloaders has the same arguments (--no-metadata and --no-preview)
          ];
          prepend_preloaders = [
            {
              mime = "{audio,video,image}/*";
              run = "mediainfo";
            }
            {
              mime = "application/subrip";
              run = "mediainfo";
            }

            # Hide metadata by default.
            # Example for image mimetype:
            # {
            #   mime = "{image}/*";
            #   run = "mediainfo --no-metadata";
            # }

            # Hide image preview by default.
            # Example for video mimetype:
            # {
            #   mime = "{video}/*";
            #   run = "mediainfo --no-preview";
            # }

            # NOTE: Use both --no-metadata and --no-preview will display nothing. :)
            # Make sure both of your previewers and preloaders has the same arguments (--no-metadata and --no-preview)
          ];
          prepend_fetchers = [
            {
              id = "git";
              url = "*";
              run = "git";
              group = "git";
            }
            {
              id = "git";
              url = "*/";
              run = "git";
              group = "git";
            }
          ];
        };
      };
      initLua =
        # lua
        ''
          -- show user:group in status bar
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

          -- show disk in status bar
          Status:children_add(function()
              local command = "df -kh .|awk '!/^Filesystem/{printf \" %s FREE \", $(NF-2)}'"
              local info = ui.Span(io.popen(command):read('*a')):fg("green")
              return info
          end, 1500, Header.RIGHT)

          require("git"):setup {
              order = 1500,
          }

          require("recycle-bin"):setup()
        '';
    };
  };
}
