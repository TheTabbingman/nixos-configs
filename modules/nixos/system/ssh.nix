{...}: {
  flake.nixosModules.system = {...}: {
    services.openssh = {
      enable = true;
      ports = [2222];
      settings = {
        PermitRootLogin = "no";
        AllowUsers = ["jonah"];
      };
    };
  };
}
