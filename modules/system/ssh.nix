{...}: {
  flake.nixosModules.system = {...}: {
    services.openssh = {
      enable = true;
      ports = [22 2222];
      settings = {
        PermitRootLogin = "no";
        AllowUsers = ["jonah"];
      };
    };
  };
}
