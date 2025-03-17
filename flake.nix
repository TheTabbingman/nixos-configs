{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
    # Maybe change when flake is merged
    hyprsession = {
      url = "github:tiecia/hyprsession";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
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
          pkgs-stable = import nixpkgs-stable {
            system = "x86_64-linux";
          };
        in {
          inherit inputs outputs pkgs-stable;
          hostname = "nixos-" + hostname;
          userConfig = users.${username};
          nixosModules = "${self}/modules/nixos";
        };
        modules = [
          ./hosts/${hostname}/configuration.nix
          inputs.nix-index-database.nixosModules.nix-index
        ];
      };

    mkNixosWSLConfiguration = username: hostname:
      nixpkgs.lib.nixosSystem {
        specialArgs = let
          pkgs-stable = import nixpkgs-stable {
            system = "x86_64-linux";
          };
        in {
          inherit inputs outputs pkgs-stable;
          hostname = "nixos-" + hostname;
          userConfig = users.${username};
          nixosModules = "${self}/modules/nixos";
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
        };
        extraSpecialArgs = {
          inherit inputs outputs hostname;
          pkgs-stable = import nixpkgs-stable {system = "x86_64-linux";};
          userConfig = users.${username};
          nhModules = "${self}/modules/home-manager";
          flakeLocation = "/etc/nixos";
          dotfilesLocation = toString ./dotfiles;
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
