{inputs, ...}: {
  systems = ["x86_64-linux"];
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.home-manager.flakeModules.home-manager
    inputs.wrapper-modules.flakeModules.wrappers
  ];
}
