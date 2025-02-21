{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-wsl, ... }@inputs: let
    inherit (self) outputs;

    users = {
      jonah = {
        name = "jonah";
      };
    };

    mkNixosConfiguration = username: hostname:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs hostname;
          userConfig = users.${username};
        };
        modules = [./hosts/${hostname}/configuration.nix];
      };

    mkHomeConfiguration = username: hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs-unstable {system = "x86_64-linux";};
        extraSpecialArgs = {
          inherit inputs outputs;
          userConfig = users.${username};
          pkgs-stable = import nixpkgs {system = "x86_64-linux";};
        };
        modules = [
          ./hosts/${hostname}/home-manager/home.nix
        ];
      };
  in {
    nixosConfigurations = {
      vm = mkNixosConfiguration "jonah" "vm" ;
      laptop = mkNixosConfiguration "jonah" "laptop";
      wsl = mkNixosConfiguration "jonah" "wsl";
    };

    homeConfigurations = {
      "jonah@nixos-vm" = mkHomeConfiguration "jonah" "vm";
      "jonah@nixos-laptop" = mkHomeConfiguration "jonah" "laptop";
      "jonah@wsl" = mkHomeConfiguration "jonah" "wsl";
    };
  };
}
