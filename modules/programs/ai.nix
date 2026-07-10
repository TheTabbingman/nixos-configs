{
  flake.nixosModules.ai = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      koboldcpp
      llama-cpp
    ];
    services.ollama = {
      enable = true;
      openFirewall = true;
      host = "[::]";
      package = let
        cudaEnabled =
          if (pkgs ? cudaSupported)
          then (pkgs.cudaSupported.config.cudaSupport or false)
          else false;
        ollamaPkg =
          if cudaEnabled
          then pkgs.ollama-cuda
          else pkgs.ollama;
      in
        ollamaPkg;
      environmentVariables = {
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_KV_CACHE_TYPE = "q8_0";
      };
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

      # Install = {
      #   WantedBy = ["default.target"];
      # };
    };
  };
}
