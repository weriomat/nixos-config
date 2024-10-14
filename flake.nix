# TODO: make default flakes for c rust haskel python dev -> devshells -> shell.nix
{
  description = "Marts - Nixos config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    utils.url = "github:numtide/flake-utils";

    # tmux sessionsx
    sessionx = {
      url = "github:omerxx/tmux-sessionx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hm
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    catppuccin.url = "github:catppuccin/nix";

    # Firefox addons
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    arkenfox = {
      url = "github:dwarfmaster/arkenfox-nixos";
      inputs.arkenfox.inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    # hyprland
    hyprland = {
      # url = "github:hyprwm/Hyprland";
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };

    hypr-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO: DO i use this?
    hyprpicker.url = "github:hyprwm/hyprpicker";

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # dev
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    utils,
    nixpkgs,
    nix-colors,
    pre-commit-hooks,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in
    {
      overlays = import ./overlays {inherit inputs;};

      # Full system build for x86
      nixosConfigurations = {
        nixos = import ./hosts/default {inherit inputs outputs nix-colors;};
        nixos-laptop = import ./hosts/lap {inherit inputs outputs nix-colors;};
      };

      # Full hm build for aarch64
      darwinConfigurations.Eliass-MacBook-Pro-4 = import ./hosts/darwina {inherit inputs nix-colors;};

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Eliass-MacBook-Pro-4".pkgs;
    }
    // utils.lib.eachDefaultSystem (system: {
      packages = import ./pkgs nixpkgs.legacyPackages.${system};
      formatter = nixpkgs.legacyPackages.${system}.alejandra;
      checks.default = pre-commit-hooks.lib.${system}.run {
        src = self.outPath;
        hooks = {
          alejandra.enable = true;
          deadnix.enable = true;
          statix.enable = true;
          nil.enable = true;
          # flake-checker.enable = true;

          # not nix
          shellcheck.enable = true;
          markdownlint.enable = true;
          yamllint.enable = true;
          check-toml.enable = true;
          check-json.enable = true;

          # commits
          convco.enable = true;
        };
      };
      devShells = let
        pkgs = import nixpkgs {inherit system;};
      in rec {
        default = deploy;
        deploy = pkgs.mkShell {
          inherit (self.checks.${system}.default) shellHook;
          buildInputs = [
            self.checks.${system}.default.enabledPackages
            pkgs.sops
            pkgs.alejandra
            pkgs.nix
          ];
        };
      };
    });
}
