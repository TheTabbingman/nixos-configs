{self, ...}: {
  flake.nixosModules.system = {
    inputs,
    pkgs,
    ...
  }: {
    imports = [
      inputs.nix-index-database.nixosModules.nix-index
      self.nixosModules.shell
      self.nixosModules.waydroid
      self.nixosModules.distrobox
    ];
    environment.systemPackages = with pkgs; [
      linux-wallpaperengine
      kdiskmark
    ];
    programs.nix-index-database.comma.enable = true;
  };
}
