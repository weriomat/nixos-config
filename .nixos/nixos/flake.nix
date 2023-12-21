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
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-master, nixos-hardware
    , utils, home-manager, firefox-addons, rust-overlay, ... }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      loadPkgs = (system: import nixpkgs { inherit system; });
      pkgs = loadPkgs system;
      # specialArgs = {
      # inherit inputs outputs;
      # martsPackages = self.packages.${system};
      # martsOverlays = (import ./overlays { inherit pkgs inputs; });
      # };
    in {
      # packages = import ./pkgs nixpkgs.legacyPackages.${system};
      packages = import ./pkgs { inherit pkgs; };
      # packages = self.packages.${system};
      overlays = import ./overlays { inherit inputs pkgs outputs; };
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        # inherit system specialArgs;
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./modules/nixos/nix.nix
          ./modules/nixos/configuration.nix
          ./hosts/default/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = { inherit inputs outputs; };
              # extraSpecialArgs = { inherit inputs; };
              # extraSpecialArgs = { inherit specialArgs; };
              # extraSpecialArgs.inputs = inputs;
              useUserPackages = true;
              useGlobalPkgs = true;
              users = { "marts" = import ./modules/home-manager/home.nix; };
            };
          }
        ];
      };
    };
}
