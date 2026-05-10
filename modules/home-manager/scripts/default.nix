{...}: {
  flake.homeModules.scripts = {
    pkgs,
    nhModules,
    ...
  }: {
    home.packages = [
      (import "${nhModules}/scripts/_check-home-diff.nix" {inherit pkgs;})
      (import "${nhModules}/scripts/_check-nix-diff.nix" {inherit pkgs;})
      (import "${nhModules}/scripts/_check-nix-boot-diff.nix" {inherit pkgs;})
    ];
  };
}
