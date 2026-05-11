{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.system = {pkgs, ...}: {
    imports = [
      inputs.nix-index-database.nixosModules.nix-index
      self.nixosModules.shell
      self.nixosModules.waydroid
      self.nixosModules.distrobox
    ];
    environment.systemPackages = with pkgs; [
      linux-wallpaperengine
      kdiskmark
      kopia-ui
    ];
    programs.nix-index-database.comma.enable = true;
  };
}
