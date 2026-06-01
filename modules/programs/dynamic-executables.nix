{inputs, ...}: {
  flake.nixosModules.system = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      inputs.nix-alien.packages.${stdenv.hostPlatform.system}.nix-alien
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
