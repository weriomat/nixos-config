# TODO: make everything a module and enable them in hosts and inport hosts than
# TODO: add prism.nix -> iogamaster
# TODO: use numtide falke helpers
# TODO: make default flakes for c rust haskel python dev -> devshells -> shell.nix
# TODO: https://github.com/cachix/pre-commit-hooks.nix?tab=readme-ov-file
# TODO: zsh for desktop
# TODO: https://github.com/Gerschtli/nix-formatter-pack?tab=readme-ov-file
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

    hyprland = {url = "github:hyprwm/Hyprland";};
    hypr-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpicker.url = "github:hyprwm/hyprpicker";
    nix-colors.url = "github:misterio77/nix-colors";

    # gaming
    nix-gaming.url = "github:fufexan/nix-gaming";

    # darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
    nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-colors,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    loadPkgs = system: import nixpkgs {inherit system;};
    pkgs = loadPkgs system;
  in {
    packages = import ./pkgs {inherit pkgs;};
    overlays = import ./overlays {inherit inputs pkgs outputs;};

    # Full system build for x86
    nixosConfigurations = {
      default = import ./hosts/default {inherit inputs outputs nix-colors;};
      laptop = import ./hosts/laptop {inherit inputs outputs nix-colors;};
    };

    # Full hm build for aarch64
    darwinConfigurations = {
      Eliass-MacBook-Pro-4 =
        import ./hosts/darwina {inherit inputs nix-colors;};
    };

    # homeConfigurations = {
    #   Eliass-MacBook-Pro-4 =
    #     darwinConfigurations.Eliass-MacBook-Pro-4.config.home-manager.users."eliasengel".home;
    # };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Eliass-MacBook-Pro-4".pkgs;

    # Formatter for x86 -> nix fmt
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    # Formatter for darwin -> nix fmt
    formatter.aarch64-darwin =
      nixpkgs.legacyPackages.aarch64-darwin.alejandra;
  };
}
