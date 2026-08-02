{...}: {
  flake.homeModules.programs = {pkgs, ...}: let
    fixedOwocr = pkgs.stable.owocr.overrideAttrs (oldAttrs: {
      buildInputs =
        (oldAttrs.buildInputs or [])
        ++ [
          pkgs.stable.gst_all_1.gstreamer
        ];
      nativeBuildInputs =
        (oldAttrs.nativeBuildInputs or [])
        ++ [
          pkgs.stable.gobject-introspection
          pkgs.stable.wrapGAppsHook3
        ];
    });
  in {
    systemd.user.services.owocr = {
      Unit = {
        Description = "owocr ocr software";
        After = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${fixedOwocr}/bin/owocr";
        Restart = "on-failure";
        Environment = [
          "DISPLAY=:0"
        ];
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
