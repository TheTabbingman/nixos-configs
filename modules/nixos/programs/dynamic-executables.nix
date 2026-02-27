{
  config,
  pkgs,
  hostname,
  nixosModules,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    nix-ld
    inputs.nix-alien.packages.${stdenv.hostPlatform.system}.nix-alien
  ];
  # programs.nix-ld.libraries = with pkgs; [
  #   libglvnd
  #   libx11
  #   libxrandr
  #   libxxf86vm
  #   libGL
  #   libXcursor
  #   libXi
  #   libXinerama
  #   libgcc
  #   libxrender
  #   libGL
  #   libICE
  #   libSM
  #   libX11
  #   libXext
  #   libXfixes
  #   libXi
  #   libXrender
  #   libgcc
  #   libxkbcommon
  #   cudaPackages.cudatoolkit
  #   config.hardware.nvidia.package # Dynamically links your actual driver
  # ];
  programs.nix-ld.enable = true;
}
