# TODO: make default flakes for c rust haskel python dev -> devshells -> shell.nix
{
  description = "Marts - Nixos config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    utils.url = "github:numtide/flake-utils";

    # hm
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix/release-25.05";

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

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
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
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
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
      pre-commit-hooks,
      sops-nix,
      treefmt-nix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      overlays = import ./overlays { inherit inputs; };

      # Full system build for x86
      nixosConfigurations = {
        # nixos = import ./hosts/default { inherit inputs outputs; };
        nixos-laptop = import ./hosts/lap { inherit inputs outputs; };
      };

      # Full hm build for aarch64
      darwinConfigurations.Eliass-MacBook-Pro-4 = import ./hosts/darwina { inherit inputs outputs; };
      darwinPackages = self.darwinConfigurations."Eliass-MacBook-Pro-4".pkgs;
    }
    // utils.lib.eachDefaultSystem (
      system:
      let
        treefmtEval = treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix;
      in
      {
        packages = import ./pkgs nixpkgs.legacyPackages.${system};
        formatter = treefmtEval.config.build.wrapper;
        checks = {
          default = pre-commit-hooks.lib.${system}.run {
            src = self.outPath;
            hooks = {
              nixfmt-rfc-style.enable = true;
              deadnix.enable = true;
              statix.enable = true;
              nil.enable = true;

              # TODO: https://github.com/DeterminateSystems/flake-checker?tab=readme-ov-file
              # typos.enable = true;
              tflint.enable = true;

              # treefmt.enable = true;

              # not nix
              shellcheck.enable = true;
              markdownlint.enable = true;
              check-toml.enable = true;
              check-json.enable = true;

              # commits
              convco.enable = true;
            };
          };
          formatting = treefmtEval.config.build.check self;
        };
        devShells =
          let
            pkgs = import nixpkgs { inherit system; };
          in
          rec {
            default = deploy;
            deploy = pkgs.mkShell {
              inherit (self.checks.${system}.default) shellHook;
              sopsPGPKeyDirs = [ ./secrets/pgp ];

              buildInputs = [
                self.checks.${system}.default.enabledPackages
                sops-nix.packages.${system}.sops-import-keys-hook

                pkgs.sops
                pkgs.nixfmt-rfc-style
                pkgs.nix
                pkgs.nurl # simple nix prefetch
                pkgs.nix-init # packaging helper

                # TODO: cleanup
                pkgs.vulnix # a security scanner

                # TODO: take a look at this: https://github.com/louib/nix2sbom
                # TODO: flake checker
                # see parts of derivations
                pkgs.nix-tree
                pkgs.graphviz
                pkgs.nix-du
              ];
            };
          };
      }
    );
}
