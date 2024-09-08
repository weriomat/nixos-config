{
  inputs,
  outputs,
  lib,
  config,
  ...
}:
with lib; {
  options.nix-settings.enable =
    mkEnableOption "Enable nix settings";

  config = mkIf config.nix-settings.enable {
    nix = {
      nixPath = ["nixpkgs=${inputs.nixpkgs}" "unstable=${inputs.nixpkgs-unstable}"];

      # enable local registry for better search
      # https://discourse.nixos.org/t/local-flake-based-nix-search-nix-run-and-nix-shell/13433/12
      registry.nixpkgs.flake = inputs.nixpkgs;

      settings = {
        sandbox = true;
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
        substituters = [
          "https://hyprland.cachix.org"
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          # "https://nixpkgs-wayland.cachix.org"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          # "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        ];
      };
    };

    # TODO: here
    # Nix shouldn't build in /tmp since it might compete for RAM for large builds and will quickly exhaust the 5 G limit
    # systemd.services.nix-daemon.environment.TMPDIR = "/nix/tmp";
    # systemd.tmpfiles.rules = [ "d /nix/tmp 0755 root root 1d" ];

    nixpkgs = {
      overlays = [
        outputs.overlays.additions

        outputs.overlays.unstable-packages

        inputs.nur.overlay
      ];
      config = {
        allowUnfree = true;
      };
    };
  };
}