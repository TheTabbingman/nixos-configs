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
      withUWSM = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    # Optional, hint electron apps to use wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
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
      systemd.enable = false;
      configType = "lua";
      package = null;
      portalPackage = null;
      plugins = [
        inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
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
          scrolling = lib.generators.mkLuaInline ''{fullscreen_on_one_column = true, explicit_column_widths = "0.333, 0.5, 0.667", wrap_focus = false, wrap_swapcol = false, follow_min_visible="0.1"}'';

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
          plugin = {
            split_monitor_workspaces = {
              enable_wrapping = false;
            };
          };
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

          mkBind = keys: luaStr: extraArgs: {
            _args =
              [
                keys
                (lib.generators.mkLuaInline luaStr)
              ]
              ++ extraArgs;
          };
        in
          [
            (mkBind "${mainMod} + c" "hl.dsp.window.close()" [])
            (mkBind "${mainMod} + m" "hl.dsp.exit()" []) # TODO: Make this hyprshutdown?

            (mkBind "${mainMod} + q" ''hl.dsp.exec_cmd("uwsm app -- ${lib.getExe pkgs.ghostty}")'' [])
            (mkBind "${mainMod} + b" ''hl.dsp.exec_cmd("uwsm app -- ${lib.getExe pkgs.librewolf}")'' [])
            (mkBind "${mainMod} + e" ''hl.dsp.exec_cmd("uwsm app -- ${lib.getExe pkgs.ghostty} -e ${lib.getExe pkgs.fish} -i -c ${lib.getExe pkgs.yazi}")'' [])
            (mkBind "ALT + space" ''hl.dsp.exec_cmd("uwsm app -- ulauncher-toggle")'' [])

            (mkBind "${mainMod} + v" "hl.dsp.window.float()" [])
            # "$mainMod, P, pseudo, # dwindle"
            # "$mainMod, t, togglesplit, # dwindle"
            (mkBind "${mainMod} + h" ''hl.dsp.layout("focus l")'' [])
            (mkBind "${mainMod} + l" ''hl.dsp.layout("focus r")'' [])
            (mkBind "${mainMod} + k" ''hl.dsp.focus({direction="up"})'' [])
            (mkBind "${mainMod} + j" ''hl.dsp.focus({direction="down"})'' [])
            (mkBind "${mainMod} + CTRL + h" ''hl.dsp.focus({monitor = "-1"})'' [])
            (mkBind "${mainMod} + CTRL + l" ''hl.dsp.focus({monitor = "+1"})'' [])

            (mkBind "${mainMod} + CTRL + SHIFT + h" ''hl.dsp.window.move({monitor = "-1"})'' [])
            (mkBind "${mainMod} + CTRL + SHIFT + l" ''hl.dsp.window.move({monitor = "+1"})'' [])
            (mkBind "${mainMod} + SHIFT + h" ''hl.dsp.layout("swapcol l")'' [])
            (mkBind "${mainMod} + SHIFT + l" ''hl.dsp.layout("swapcol r")'' [])
            (mkBind "${mainMod} + SHIFT + k" ''hl.dsp.window.move({direction="up"})'' [])
            (mkBind "${mainMod} + SHIFT + j" ''hl.dsp.window.move({direction="down"})'' [])

            (mkBind "${mainMod} + RIGHT" ''hl.dsp.layout("consume_or_expel next")'' [])
            (mkBind "${mainMod} + SHIFT + RIGHT" ''hl.dsp.layout("consume_or_expel next")'' [])
            (mkBind "${mainMod} + LEFT" ''hl.dsp.layout("consume_or_expel prev")'' [])
            (mkBind "${mainMod} + SHIFT + LEFT" ''hl.dsp.layout("consume_or_expel prev")'' [])

            (mkBind "${mainMod} + s" ''hl.dsp.workspace.toggle_special("magic")'' [])

            (mkBind "${mainMod} + mouse_up" ''function() return hl.plugin.split_monitor_workspaces.workspace("+1") end'' [])
            (mkBind "${mainMod} + mouse_down" ''function() return hl.plugin.split_monitor_workspaces.workspace("-1") end'' [])

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

            (mkBind "print" ''hl.dsp.exec_cmd("uwsm app -- grim -l 0 -g slurp - | wl-copy")'' [])

            (mkBind "${mainMod} + r" ''hl.dsp.layout("colresize +conf")'' [])
            (mkBind "${mainMod} + SHIFT + f" "hl.dsp.window.fullscreen()" [])
            (mkBind "${mainMod} + f" ''hl.dsp.window.fullscreen({mode = "maximized", action = "toggle"})'' [])

            # TODO: "$mainMod, g, togglegroup"

            (mkBind "${mainMod} + mouse:272" "hl.dsp.window.drag()" ["{mouse = true}"])
            (mkBind "${mainMod} + mouse:273" "hl.dsp.window.resize()" ["{mouse = true}"])

            (mkBind "XF86AudioRaiseVolume" ''hl.dsp.exec_cmd("uwsm app -- ${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 0.02+ -l 1.0")'' ["{repeating = true, locked = true}"])
            (mkBind "XF86AudioLowerVolume" ''hl.dsp.exec_cmd("uwsm app -- ${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 0.02-")'' ["{repeating = true, locked = true}"])
            (mkBind "XF86AudioMute" ''hl.dsp.exec_cmd("uwsm app -- ${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle")'' ["{repeating = true, locked = true}"])
            (mkBind "XF86AudioMicMute" ''hl.dsp.exec_cmd("uwsm app -- ${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle")'' ["{repeating = true, locked = true}"])

            (mkBind "XF86MonBrightnessUp" ''hl.dsp.exec_cmd("uwsm app -- ${lib.getExe pkgs.brightnessctl} --class=backlight set +10%")'' ["{repeating = true, locked = true}"])
            (mkBind "XF86MonBrightnessDown" ''hl.dsp.exec_cmd("uwsm app -- ${lib.getExe pkgs.brightnessctl} --class=backlight set 10%-")'' ["{repeating = true, locked = true}"])

            (mkBind "XF86AudioPlay" ''hl.dsp.exec_cmd("uwsm app -- ${lib.getExe pkgs.playerctl} play-pause")'' ["{locked = true}"])
            (mkBind "XF86AudioStop" ''hl.dsp.exec_cmd("uwsm app -- ${lib.getExe pkgs.playerctl} stop")'' ["{locked = true}"])
            (mkBind "XF86AudioPrev" ''hl.dsp.exec_cmd("uwsm app -- ${lib.getExe pkgs.playerctl} previous")'' ["{locked = true}"])
            (mkBind "XF86AudioNext" ''hl.dsp.exec_cmd("uwsm app -- ${lib.getExe pkgs.playerctl} next")'' ["{locked = true}"])
          ]
          ++ (builtins.concatLists (builtins.genList
            (
              i: let
                # Convert 0-9 index to workspace numbers 1-10
                ws = toString (i + 1);
                # Map workspace 10 back to the "0" key
                key =
                  if ws == "10"
                  then "0"
                  else ws;
              in [
                (mkBind "${mainMod} + ${key}" "function() return hl.plugin.split_monitor_workspaces.workspace(${ws}) end" [])
                (mkBind "${mainMod} + SHIFT + ${key}" "function() return hl.plugin.split_monitor_workspaces.move_to_workspace(${ws}) end" [])
              ]
            )
            10));

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
      };
      extraConfig =
        # lua
        ''
          local smw = hl.plugin.split_monitor_workspaces
          smw.monitor_priority({ "DP-3", "DP-2", "HDMI-A-1"})
        '';
    };
  };
}
