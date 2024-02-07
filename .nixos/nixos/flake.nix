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

      # Full system build for x86
      nixosConfigurations = {
        default = import ./hosts/default { inherit inputs outputs; };
        laptop = import ./hosts/laptop { inherit inputs outputs; };
      };

      # Formatter for x86 -> nix fmt
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    };
}
