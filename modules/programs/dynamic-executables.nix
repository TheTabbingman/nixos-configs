{inputs, ...}: {
  flake.nixosModules.system = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
    ];
    # programs.nix-ld = {
    # enable = true;
    # libraries = with pkgs; [
    # python3Packages.tkinter
    # libglvnd
    # libx11
    # libxrandr
    # libxxf86vm
    # libGL
    # libXcursor
    # libXi
    # libXinerama
    # libgcc
    # libxrender
    # libGL
    # libICE
    # libSM
    # libX11
    # libXext
    # libXfixes
    # libXi
    # libXrender
    # libgcc
    # libxkbcommon
    # cudaPackages.cudatoolkit
    # config.hardware.nvidia.package # Dynamically links your actual driver
    # ];
    # };
  };
}
