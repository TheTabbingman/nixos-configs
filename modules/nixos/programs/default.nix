{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.system = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      inputs.nix-index-database.nixosModules.nix-index
      self.nixosModules.shell
      self.nixosModules.waydroid
      self.nixosModules.distrobox
    ];
    environment.systemPackages = with pkgs; [
      alacritty-graphics
      linux-wallpaperengine
      kdiskmark
      kopia-ui
      tor-browser
      puddletag
    ];
    programs.nix-index-database.comma.enable = true;

    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      environmentVariables = {"OLLAMA_CONTEXT_LENGTH" = "32768";};
    };
    services.open-webui.enable = true;
  };
}
