{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.hyprland = {pkgs, ...}: {
    imports = [
      self.nixosModules.wmCommon
    ];
    # Enable hyprland
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    # Optional, hint electron apps to use wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.systemPackages = with pkgs; [
      # inputs.hyprsession.packages.${pkgs.stdenv.hostPlatform.system}.hyprsession
    ];
  };
  flake.homeModules.hyprland = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      self.homeModules.wm
      # ./hyprlock.nix
    ];
    # services.hypridle.enable = true;
    # services.hyprpolkitagent.enable = true;
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      package = null;
      portalPackage = null;
      plugins = [
        # inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
        # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
      ];
      settings = {
        # This is an example Hyprland Lua config file.
        # Refer to the wiki for more information.
        # https://wiki.hypr.land/Configuring/Start/

        # Please note not all available settings / options are set here.
        # For a full list, see the wiki

        # You can (and should!!) split this configuration into multiple files
        # Create your files separately and then require them like this:
        # require("myColors")

        ##################
        #### MONITORS ####
        ##################

        # See https://wiki.hypr.land/Configuring/Basics/Monitors/
        monitor = [
          {
            output = "DP-3";
            mode = "2560x1440@180.002";
            position = "1920x0";
            scale = 1;
            vrr = 2;
            bitdepth = 10;
          }
          {
            output = "DP-2";
            mode = "1920x1080@143.856";
            position = "0x360";
            scale = 1;
            vrr = 2;
          }
          {
            output = "HDMI-A-1";
            mode = "1920x1200@59.950";
            position = "4480x240";
            scale = 1;
          }
        ];

        ###################
        ### MY PROGRAMS ###
        ###################

        # Set programs that you use
        # local terminal    = "kitty"
        # local fileManager = "dolphin"
        # local menu        = "hyprlauncher"

        #################
        ### AUTOSTART ###
        #################

        # See https://wiki.hypr.land/Configuring/Basics/Autostart/
        #
        # Autostart necessary processes (like notifications daemons, status bars, etc.)
        # Or execute your favorite apps at launch like this:
        #
        # hl.on("hyprland.start", function ()
        #   hl.exec_cmd(terminal)
        #   hl.exec_cmd("nm-applet")
        #   hl.exec_cmd("waybar & hyprpaper & firefox")
        # end)

        #############################
        ### ENVIRONMENT VARIABLES ###
        #############################

        # See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

        env = [
          {
            _args = [
              "XCURSOR_SIZE"
              "24"
            ];
          }
          {
            _args = [
              "HYPRCURSOR_SIZE"
              "24"
            ];
          }
          {
            _args = [
              "LIBVA_DRIVER_NAME"
              "nvidia"
            ];
          }
          {
            _args = [
              "__GLX_VENDOR_LIBRARY_NAME"
              "nvidia"
            ];
          }
          # "AQ_DRM_DEVICES,/dev/dri/intel-igpu:/dev/dri/nvidia-dgpu"
        ];

        #######################
        ##### PERMISSIONS #####
        #######################

        # See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
        # Please note permission changes here require a Hyprland restart and are not applied on-the-fly
        # for security reasons

        # hl.config({
        #   ecosystem = {
        #     enforce_permissions = true,
        #   },
        # })

        # hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
        # hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
        # hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

        #####################
        ### LOOK AND FEEL ###
        #####################

        # Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
        config = {
          general = lib.mkMerge [
            {
              gaps_in = 5;
              gaps_out = 10;

              border_size = 2;

              # col.active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
              # col.inactive_border = "rgba(595959aa)";

              # Set to true enable resizing windows by clicking and dragging on borders and gaps
              resize_on_border = false;

              # Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
              allow_tearing = false;

              layout = "scrolling";
            }
          ];
          scrolling = lib.generators.mkLuaInline ''{fullscreen_on_one_column = true, explicit_column_widths = "0.333, 0.5, 0.667", wrap_focus = false, wrap_swapcol = false}'';

          decoration = lib.mkMerge [
            {
              rounding = 10;
              rounding_power = 2;

              # Change transparency of focused and unfocused windows
              active_opacity = 1.0;
              inactive_opacity = 1.0;

              shadow = lib.mkMerge [
                {
                  enabled = true;
                  range = 4;
                  render_power = 3;
                  # color = "rgba(1a1a1aee)";
                }
              ];

              blur = {
                enabled = true;
                size = 3;
                passes = 1;
                vibrancy = 0.1696;
              };
            }
          ];
          animations.enabled = true;

          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          dwindle = {
            preserve_split = true; # You probably want this
          };

          group = lib.mkMerge [
            {
              auto_group = false;
              insert_after_current = false;
            }
          ];

          # See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
          master = {
            new_status = "master";
          };

          misc = lib.mkMerge [
            {
              force_default_wallpaper = 2; # Set to 0 or 1 to disable the anime mascot wallpapers
              disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
            }
          ];

          #############
          ### INPUT ###
          #############

          # https://wiki.hyprland.org/Configuring/Variables/#input
          input = {
            kb_layout = "us";
            kb_variant = "";
            kb_model = "";
            kb_options = "";
            kb_rules = "";

            numlock_by_default = true;

            follow_mouse = 1;

            sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
            accel_profile = "flat";

            touchpad = {
              natural_scroll = true;
            };
          };
          cursor.no_warps = true;
        };

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        # TODO:
        # bezier = [
        #   "easeOutQuint,0.23,1,0.32,1"
        #   "easeInOutCubic,0.65,0.05,0.36,1"
        #   "linear,0,0,1,1"
        #   "almostLinear,0.5,0.5,0.75,1.0"
        #   "quick,0.15,0,0.1,1"
        # ];

        # animation = [
        #   "global, 1, 10, default"
        #   "border, 1, 5.39, easeOutQuint"
        #   "windows, 1, 4.79, easeOutQuint"
        #   "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
        #   "windowsOut, 1, 1.49, linear, popin 87%"
        #   "fadeIn, 1, 1.73, almostLinear"
        #   "fadeOut, 1, 1.46, almostLinear"
        #   "fade, 1, 3.03, quick"
        #   "layers, 1, 3.81, easeOutQuint"
        #   "layersIn, 1, 4, easeOutQuint, fade"
        #   "layersOut, 1, 1.5, linear, fade"
        #   "fadeLayersIn, 1, 1.79, almostLinear"
        #   "fadeLayersOut, 1, 1.39, almostLinear"
        #   "workspaces, 1, 1.94, almostLinear, fade"
        #   "workspacesIn, 1, 1.21, almostLinear, fade"
        #   "workspacesOut, 1, 1.94, almostLinear, fade"
        # ];

        # Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
        # "Smart gaps" / "No gaps when only"
        # uncomment all if you wish to use that.
        # hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
        # hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
        # hl.window_rule({
        #     name  = "no-gaps-wtv1",
        #     match = { float = false, workspace = "w[tv1]" },
        #     border_size = 0,
        #     rounding    = 0,
        # })
        # hl.window_rule({
        #     name  = "no-gaps-f1",
        #     match = { float = false, workspace = "f[1]" },
        #     border_size = 0,
        #     rounding    = 0,
        # })

        gesture = {
          fingers = 3;
          direction = "horizontal";
          action = "workspace";
        };

        # Example per-device config
        # See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
        device = {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        };

        ###################
        ### KEYBINDINGS ###
        ###################

        # local mainMod = "SUPER" -- Sets "Windows" key as main modifier

        # Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more

        bind = let
          mainMod = "SUPER";
        in [
          {
            _args = [
              "${mainMod} + Q"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe pkgs.ghostty}")'')
            ];
          }
          {
            _args = [
              "${mainMod} + b"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe pkgs.librewolf}")'')
            ];
          }
          {
            _args = [
              "${mainMod} + C"
              (lib.generators.mkLuaInline "hl.dsp.window.close()")
            ];
          }
          {
            _args = [
              "${mainMod} + M"
              (lib.generators.mkLuaInline "hl.dsp.exit()") # TODO: Make this hyprshutdown?
            ];
          }
          {
            _args = [
              "${mainMod} + E"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe pkgs.yazi}")'')
            ];
          }
          {
            _args = [
              "${mainMod} + V"
              (lib.generators.mkLuaInline "hl.dsp.window.float()") # NOTE: See if it works. If not {toggle, activewindow}
            ];
          }
          {
            _args = [
              "ALT + space"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("ulauncher-toggle")'')
            ];
          }
          # "$mainMod, P, pseudo, # dwindle"
          # "$mainMod, t, togglesplit, # dwindle"

          {
            _args = [
              "${mainMod} + h"
              (lib.generators.mkLuaInline ''hl.dsp.layout("focus l")'')
            ];
          }
          {
            _args = [
              "${mainMod} + l"
              (lib.generators.mkLuaInline ''hl.dsp.layout("focus r")'')
            ];
          }
          {
            _args = [
              "${mainMod} + CTRL + h"
              (lib.generators.mkLuaInline ''hl.dsp.focus({monitor = "-1"})'')
            ];
          }
          {
            _args = [
              "${mainMod} + CTRL + l"
              (lib.generators.mkLuaInline ''hl.dsp.focus({monitor = "+1"})'')
            ];
          }
          {
            _args = [
              "${mainMod} + k"
              (lib.generators.mkLuaInline ''hl.dsp.focus({direction="up"})'')
            ];
          }
          {
            _args = [
              "${mainMod} + j"
              (lib.generators.mkLuaInline ''hl.dsp.focus({direction="down"})'')
            ];
          }

          {
            _args = [
              "${mainMod} + SHIFT + h"
              (lib.generators.mkLuaInline ''hl.dsp.layout("swapcol l")'')
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + l"
              (lib.generators.mkLuaInline ''hl.dsp.layout("swapcol r")'')
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + k"
              (lib.generators.mkLuaInline ''hl.dsp.window.move({direction="up"})'')
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + j"
              (lib.generators.mkLuaInline ''hl.dsp.window.move({direction="down"})'')
            ];
          }

          {
            _args = [
              "${mainMod} + RIGHT"
              (lib.generators.mkLuaInline ''hl.dsp.layout("consume_or_expel next")'')
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + RIGHT"
              (lib.generators.mkLuaInline ''hl.dsp.layout("consume_or_expel next")'')
            ];
          }
          {
            _args = [
              "${mainMod} + LEFT"
              (lib.generators.mkLuaInline ''hl.dsp.layout("consume_or_expel prev")'')
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + LEFT"
              (lib.generators.mkLuaInline ''hl.dsp.layout("consume_or_expel prev")'')
            ];
          }

          {
            _args = [
              "${mainMod} + 1"
              (lib.generators.mkLuaInline "hl.dsp.focus({workspace=1})")
            ];
          }
          {
            _args = [
              "${mainMod} + 2"
              (lib.generators.mkLuaInline "hl.dsp.focus({workspace=2})")
            ];
          }
          {
            _args = [
              "${mainMod} + 3"
              (lib.generators.mkLuaInline "hl.dsp.focus({workspace=3})")
            ];
          }
          {
            _args = [
              "${mainMod} + 4"
              (lib.generators.mkLuaInline "hl.dsp.focus({workspace=4})")
            ];
          }
          {
            _args = [
              "${mainMod} + 5"
              (lib.generators.mkLuaInline "hl.dsp.focus({workspace=5})")
            ];
          }
          {
            _args = [
              "${mainMod} + 6"
              (lib.generators.mkLuaInline "hl.dsp.focus({workspace=6})")
            ];
          }
          {
            _args = [
              "${mainMod} + 7"
              (lib.generators.mkLuaInline "hl.dsp.focus({workspace=7})")
            ];
          }
          {
            _args = [
              "${mainMod} + 8"
              (lib.generators.mkLuaInline "hl.dsp.focus({workspace=8})")
            ];
          }
          {
            _args = [
              "${mainMod} + 9"
              (lib.generators.mkLuaInline "hl.dsp.focus({workspace=9})")
            ];
          }
          {
            _args = [
              "${mainMod} + 0"
              (lib.generators.mkLuaInline "hl.dsp.focus({workspace=10})")
            ];
          }

          {
            _args = [
              "${mainMod} + SHIFT + 1"
              (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=1})")
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + 2"
              (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=2})")
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + 3"
              (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=3})")
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + 4"
              (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=4})")
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + 5"
              (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=5})")
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + 6"
              (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=6})")
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + 7"
              (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=7})")
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + 8"
              (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=8})")
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + 9"
              (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=9})")
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + 0"
              (lib.generators.mkLuaInline "hl.dsp.window.move({workspace=10})")
            ];
          }

          {
            _args = [
              "${mainMod} + s"
              (lib.generators.mkLuaInline ''hl.dsp.workspace.toggle_special("magic")'')
            ];
          }

          {
            _args = [
              "${mainMod} + mouse_down"
              (lib.generators.mkLuaInline ''hl.dsp.focus({workspace="e+1"})'')
            ];
          }
          {
            _args = [
              "${mainMod} + mouse_up"
              (lib.generators.mkLuaInline ''hl.dsp.focus({workspace="e-1"})'')
            ];
          }

          # Scroll through group TODO:
          # "alt, bracketleft, changegroupactive, b"
          # "alt, bracketright, changegroupactive, f"
          # Select specific group TODO:
          # "alt, 1, changegroupactive, 1"
          # "alt, 2, changegroupactive, 2"
          # "alt, 3, changegroupactive, 3"
          # "alt, 4, changegroupactive, 4"
          # "alt, 5, changegroupactive, 5"
          # "alt, 6, changegroupactive, 6"
          # "alt, 7, changegroupactive, 7"
          # "alt, 8, changegroupactive, 8"
          # "alt, 9, changegroupactive, 9"
          # "alt, 0, changegroupactive, 10"

          {
            _args = [
              "print"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("grim -l 0 -g slurp - | wl-copy")'')
            ];
          }

          {
            _args = [
              "${mainMod} + r"
              (lib.generators.mkLuaInline ''hl.dsp.layout("colresize +conf")'')
            ];
          }
          {
            _args = [
              "${mainMod} + SHIFT + f"
              (lib.generators.mkLuaInline "hl.dsp.window.fullscreen()")
            ];
          }
          {
            _args = [
              "${mainMod} + f"
              (lib.generators.mkLuaInline ''hl.dsp.window.fullscreen({mode = "maximized", action = "toggle"})'')
            ];
          }

          # TODO: "$mainMod, g, togglegroup"

          {
            _args = [
              "${mainMod} + mouse:272"
              (lib.generators.mkLuaInline "hl.dsp.window.drag()")
              "{mouse = true}"
            ];
          }
          {
            _args = [
              "${mainMod} + mouse:273"
              (lib.generators.mkLuaInline "hl.dsp.window.resize()")
              "{mouse = true}"
            ];
          }

          {
            _args = [
              "XF86AudioRaiseVolume"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 0.02+ -l 1.0")'')
              "{repeating = true, locked = true}"
            ];
          }
          {
            _args = [
              "XF86AudioLowerVolume"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 0.02-")'')
              "{repeating = true, locked = true}"
            ];
          }
          {
            _args = [
              "XF86AudioMute"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle")'')
              "{repeating = true, locked = true}"
            ];
          }
          {
            _args = [
              "XF86AudioMicMute"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle")'')
              "{repeating = true, locked = true}"
            ];
          }

          {
            _args = [
              "XF86MonBrightnessUp"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe pkgs.brightnessctl} --class=backlight set +10%")'')
              "{repeating = true, locked = true}"
            ];
          }
          {
            _args = [
              "XF86MonBrightnessDown"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe pkgs.brightnessctl} --class=backlight set 10%-")'')
              "{repeating = true, locked = true}"
            ];
          }

          {
            _args = [
              "XF86AudioPlay"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe pkgs.playerctl} play-pause")'')
              "{locked = true}"
            ];
          }
          {
            _args = [
              "XF86AudioStop"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe pkgs.playerctl} stop")'')
              "{locked = true}"
            ];
          }
          {
            _args = [
              "XF86AudioPrev"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe pkgs.playerctl} previous")'')
              "{locked = true}"
            ];
          }
          {
            _args = [
              "XF86AudioNext"
              (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${lib.getExe pkgs.playerctl} next")'')
              "{locked = true}"
            ];
          }
        ];

        ##############################
        ### WINDOWS AND WORKSPACES ###
        ##############################

        # See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
        # and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

        window_rule = [
          # Ignore maximize requests from apps. You'll probably like this.
          {
            name = "supress-maximize-events";
            match.class = ".*";

            suppress_event = "maximize";
          }
          # Fix some dragging issues with XWayland
          {
            name = "fix-xwayland-drags";
            match = {
              class = "^$";
              title = "^$";
              xwayland = "true";
              float = "true";
              fullscreen = "false";
              pin = "false";
            };

            no_focus = true;
          }
        ];

        # plugin = [
        # {
        # hyprbars = [
        #   {
        #     # Set to 0 to disable hyprbars
        #     # bar_height = 38;
        #     bar_height = 0;
        #     bar_color = "rgb(1e1e1e)";
        #     col.text = "rgb(ffffff)";
        #     bar_text_size = 12;
        #     bar_text_font = "Jetbrains Mono Nerd Font Mono Bold";
        #     bar_button_padding = 12;
        #     bar_padding = 10;
        #     bar_precedence_over_border = true;
        #     hyprbars-button = [
        #       "rgb(ff0000), 20, , hyprctl dispatch killactive"
        #       "rgb(00ff00), 20, , hyprctl dispatch fullscreen 2"
        #       "rgb(0000ff), 20, , hyprctl dispatch togglefloating"
        #     ];
        #   }
        # ];
        # }
        # ];
      };
    };
  };
}
