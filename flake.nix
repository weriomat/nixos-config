# TODO: make default flakes for c rust haskel python dev -> devshells -> shell.nix
{
  description = "Marts - Nixos config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    utils.url = "github:numtide/flake-utils";

    # hm
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    catppuccin.url = "github:catppuccin/nix";
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Firefox addons
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    arkenfox = {
      url = "github:dwarfmaster/arkenfox-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit.follows = "pre-commit-hooks";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    hypr-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: diff packaging https://github.com/niksingh710/ndots/blob/master/pkgs/mono-lisa/default.nix
    # font
    monoLisa = {
      url = "path:/home/marts/.nixos/MonoLisa";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };

    # dev
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # gaming
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # darwin
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.flake-utils.follows = "utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      utils,
      nixpkgs,
      nix-colors,
      pre-commit-hooks,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      overlays = import ./overlays { inherit inputs; };

      # TODO: nixd https://www.youtube.com/watch?v=M_zMoHlbZBY
      # TODO: make seperate home module and move things around to make use of nixd
      # Full system build for x86
      nixosConfigurations = {
        # nixos = import ./hosts/default { inherit inputs outputs nix-colors; };
        nixos-laptop = import ./hosts/lap { inherit inputs outputs nix-colors; };
      };

      # Full hm build for aarch64
      darwinConfigurations.Eliass-MacBook-Pro-4 = import ./hosts/darwina { inherit inputs nix-colors; };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Eliass-MacBook-Pro-4".pkgs;
    }
    // utils.lib.eachDefaultSystem (system: {
      packages = import ./pkgs nixpkgs.legacyPackages.${system};
      formatter = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
      checks.default = pre-commit-hooks.lib.${system}.run {
        src = self.outPath;
        hooks = {
          nixfmt-rfc-style.enable = true;
          deadnix.enable = true;
          statix.enable = true;
          nil.enable = true;

          # not nix
          shellcheck.enable = true;
          markdownlint.enable = true;
          check-toml.enable = true;
          check-json.enable = true;

          # commits
          convco.enable = true;
        };
      };
      devShells =
        let
          pkgs = import nixpkgs { inherit system; };
        in
        rec {
          default = deploy;
          deploy = pkgs.mkShell {
            inherit (self.checks.${system}.default) shellHook;
            buildInputs = [
              self.checks.${system}.default.enabledPackages
              pkgs.sops
              pkgs.nixfmt-rfc-style
              pkgs.nix
              pkgs.nurl # simple nix prefetch
              pkgs.nix-init # packaging helper

              # TODO: take a look at this: https://github.com/louib/nix2sbom
              # TODO: flake checker
              # see parts of derivations
              pkgs.nix-tree
              pkgs.graphviz
              pkgs.nix-du
            ];
          };
        };
    });
}
