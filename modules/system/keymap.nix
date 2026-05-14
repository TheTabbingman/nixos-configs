{...}: {
  flake.nixosModules.system = {...}: {
    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
