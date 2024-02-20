# TODO: make default flakes for c rust haskel python dev -> devshells -> shell.nix
# TODO: zsh for desktop
# TODO: move /home to other disk
# TODO: use zsh
# TODO: nix-update
{
  description = "Marts - Nixos config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    utils.url = "github:numtide/flake-utils";

    # hm
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    prism.url = "github:IogaMaster/prism";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    hypr-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpicker.url = "github:hyprwm/hyprpicker";

    # dev
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay.url = "github:oxalica/rust-overlay";

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
    nix-colors,
    prism,
    pre-commit-hooks,
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
      default = import ./hosts/default {inherit inputs outputs nix-colors prism;};
      laptop = import ./hosts/laptop {inherit inputs outputs nix-colors prism;};
    };

    # Full hm build for aarch64
    darwinConfigurations = {
      Eliass-MacBook-Pro-4 =
        import ./hosts/darwina {inherit inputs nix-colors prism;};
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Eliass-MacBook-Pro-4".pkgs;

    # Formatter for x86 -> nix fmt
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    # Formatter for darwin -> nix fmt
    formatter.aarch64-darwin =
      nixpkgs.legacyPackages.aarch64-darwin.alejandra;

    checks.x86_64-linux = {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
          deadnix.enable = true;
          statix.enable = true;
          nil.enable = true;
        };
      };
    };
    checks.aarch64-darwin = {
      pre-commit-check = pre-commit-hooks.lib.aarch64-darwin.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
          deadnix.enable = true;
          statix.enable = true;
        };
      };
    };
  };
}
