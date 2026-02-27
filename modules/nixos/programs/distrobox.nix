{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    distrobox
    nvidia-container-toolkit
  ];
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  hardware.nvidia-container-toolkit.enable = true;
  # Have to run this command too
  # sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
  # Example distrobox
  # distrobox create --name bazzite-arch \
  #   --image ghcr.io/ublue-os/bazzite-arch:latest \
  #   --additional-flags "--device nvidia.com/gpu=all --security-opt=label=disable"
}
