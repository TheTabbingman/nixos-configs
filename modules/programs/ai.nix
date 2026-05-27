{
  flake.nixosModules.ai = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      koboldcpp
      llama-cpp
    ];
    services.ollama = {
      enable = true;
      openFirewall = true;
      package = pkgs.ollama-cuda;
    };
    services.llama-cpp = {
      enable = true;
      openFirewall = true;
    };
  };
  flake.homeModules.ai = {
    pkgs,
    lib,
    ...
  }: {
    systemd.user.services.swarmui = {
      Unit = {
        Description = "SwarmUI";
        After = ["network.target"];
      };

      Service = {
        Type = "simple";

        WorkingDirectory = "/mnt/ssd/Programs/SwarmUI";

        ExecStart = "${lib.getExe pkgs.nix} run path:./.nix/fhs";

        Restart = "on-failure";
        RestartSec = "5s";
      };

      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
