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
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixos-wsl,
    ...
  } @ inputs: let
    inherit (self) outputs;

    users = {
      jonah = {
        name = "jonah";
      };
    };

    mkNixosConfiguration = username: hostname:
      nixpkgs.lib.nixosSystem {
        specialArgs = let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [
              (final: pre: {
                unstable = import nixpkgs-unstable {system = "x86_64-linux";};
              })
            ];
          };
        in {
          inherit inputs outputs pkgs;
          hostname = "nixos-" + hostname;
          userConfig = users.${username};
        };
        modules = [./hosts/${hostname}/configuration.nix];
      };

    mkNixosWSLConfiguration = username: hostname:
      nixpkgs.lib.nixosSystem {
        specialArgs = let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [
              (final: pre: {
                unstable = import nixpkgs-unstable {system = "x86_64-linux";};
              })
            ];
          };
        in {
          inherit inputs outputs pkgs;
          hostname = "nixos-" + hostname;
          userConfig = users.${username};
        };
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          ./hosts/${hostname}/configuration.nix
        ];
      };

    mkHomeConfiguration = username: hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [
            (final: pre: {
              unstable = import nixpkgs-unstable {system = "x86_64-linux";};
            })
          ];
        };
        extraSpecialArgs = {
          inherit inputs outputs hostname;
          userConfig = users.${username};
          nhModules = "${self}/modules/home-manager";
          flakeLocation = "/etc/nixos";
        };
        modules = [
          ./hosts/${hostname}/home.nix
        ];
      };
  in {
    nixosConfigurations = {
      nixos-vm = mkNixosConfiguration "jonah" "vm";
      nixos-laptop = mkNixosConfiguration "jonah" "laptop";
      nixos-wsl = mkNixosWSLConfiguration "jonah" "wsl";
    };

    homeConfigurations = {
      "jonah@nixos-vm" = mkHomeConfiguration "jonah" "vm";
      "jonah@nixos-laptop" = mkHomeConfiguration "jonah" "laptop";
      "jonah@nixos-wsl" = mkHomeConfiguration "jonah" "wsl";
    };
  };
}
