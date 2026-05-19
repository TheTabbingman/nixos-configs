{
  flake.nixosModules.virtualization = {
    config,
    pkgs,
    ...
  }: {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    users.users.${config.preferences.user.name}.extraGroups = ["libvirtd"];
    environment.systemPackages = with pkgs; [dnsmasq];
  };
}
