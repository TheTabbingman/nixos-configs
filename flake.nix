{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

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
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
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
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.stylix.nixosModules.stylix
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
        };
        modules = [
          ./hosts/${hostname}/home.nix
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
          inputs.stylix.homeModules.stylix
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
