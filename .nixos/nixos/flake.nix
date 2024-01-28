{
  description = "Marts - Nixos config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # firefox addons from nur
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay.url = "github:oxalica/rust-overlay";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    hypr-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpicker.url = "github:hyprwm/hyprpicker";

    # gaming
    nix-gaming.url = "github:fufexan/nix-gaming";

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-master, nixos-hardware
    , utils, home-manager, firefox-addons, rust-overlay, hyprland, ... }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      loadPkgs = (system: import nixpkgs { inherit system; });
      pkgs = loadPkgs system;
    in {
      packages = import ./pkgs { inherit pkgs; };
      overlays = import ./overlays { inherit inputs pkgs outputs; };
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./modules/nixos/common/nix.nix
          ./modules/nixos/configuration.nix
          ./hosts/default/hardware-configuration.nix
          ./hosts/default/hardware-config-add.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = { inherit inputs outputs; };
              useUserPackages = true;
              useGlobalPkgs = true;
              users = { "marts" = import ./modules/home-manager/home.nix; };
            };
          }
        ];
      };
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./modules/nixos/common/nix.nix
          ./modules/nixos/config-laptop.nix
          ./hosts/laptop/hardware-configuration.nix
          ./hosts/laptop/hardware-configuration-add.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-l13
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = { inherit inputs outputs; };
              useUserPackages = true;
              useGlobalPkgs = true;
              users = {
                "marts" = import ./modules/home-manager/home_laptop.nix;
              };
            };
          }
        ];
      };
    };
}
