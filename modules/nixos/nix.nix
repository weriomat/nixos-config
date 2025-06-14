{
  globals,
  inputs,
  outputs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.nix-settings.enable = mkEnableOption "Enable nix settings";

  config = mkIf config.nix-settings.enable {
    system.rebuild.enableNg = true;
    nix = {
      channel.enable = false;
      nixPath = [
        "nixpkgs=${inputs.nixpkgs}"
        "unstable=${inputs.nixpkgs-unstable}"
      ];

      # stolen from https://git.cobalt.rocks/shared-configs/nixos-ng/-/blob/main/modules/nix.nix?ref_type=heads
      # enable local registry for better search
      # https://discourse.nixos.org/t/local-flake-based-nix-search-nix-run-and-nix-shell/13433/12
      registry = lib.attrsets.genAttrs (builtins.attrNames inputs) (name: {
        flake = inputs.${name};
      });

      settings = {
        allowed-users = [
          "${globals.username}"
          "root"
          "@wheel"
        ];
        trusted-users = [
          "${globals.username}"
          "root"
          "@wheel"
        ];
        sandbox = true;
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
        warn-dirty = false;
        use-xdg-base-directories = true;
        substituters = [
          "https://hyprland.cachix.org"
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://helix.cachix.org"
          "https://devenv.cachix.org/"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        ];
      };
    };

    nixpkgs = {
      overlays = [
        outputs.overlays.additions
        outputs.overlays.unstable-packages
      ];
      config.allowUnfree = true;
    };
  };
}
