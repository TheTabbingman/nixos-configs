{...}: {
  flake.nixosModules.system = {pkgs, ...}: {
    # Enable CUPS to print documents.
    services.printing.enable = true;
  };
}
