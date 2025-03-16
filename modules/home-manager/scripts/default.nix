{
  pkgs,
  nhModules,
  ...
}: {
  home.packages = [
    (import "${nhModules}/scripts/check-home-diff.nix" {inherit pkgs;})
    (import "${nhModules}/scripts/check-nix-diff.nix" {inherit pkgs;})
    (import "${nhModules}/scripts/check-nix-boot-diff.nix" {inherit pkgs;})
  ];
}
