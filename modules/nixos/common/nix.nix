{
  inputs,
  outputs,
  lib,
  config,
  ...
}: {
  options.nix-settings = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable nix settings";
    };
  };
  config = lib.mkIf config.nix-settings.enable {
    nix = {
      nixPath = ["nixpkgs=${inputs.nixpkgs}" "unstable=${inputs.nixpkgs-unstable}"];

      # enable local registry for better search
      # https://discourse.nixos.org/t/local-flake-based-nix-search-nix-run-and-nix-shell/13433/12
      registry.nixpkgs.flake = inputs.nixpkgs;

      settings = {
        sandbox = true;
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        # Deduplicate and optimize nix store
        auto-optimise-store = true;
        substituters = [
          "https://hyprland.cachix.org"
          "https://cache.nixos.org"
          # "https://nixpkgs-wayland.cachix.org"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          # "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        ];
      };
    };
    # TODO: set trusted public keys, trusted-subsituters

    # Nix shouldn't build in /tmp since it might compete for RAM for large builds and will quickly exhaust the 5 G limit
    # systemd.services.nix-daemon.environment.TMPDIR = "/nix/tmp";
    # systemd.tmpfiles.rules = [ "d /nix/tmp 0755 root root 1d" ];
    # Allow some unfree packages
    nixpkgs = {
      overlays = [
        outputs.overlays.additions

        outputs.overlays.unstable-packages

        inputs.nur.overlay

        # Or define it inline, for example:
        # (final: prev: {
        #   hi = final.hello.overrideAttrs (oldAttrs: {
        #     patches = [ ./change-hello-to-hi.patch ];
        #   });
        # })
      ];
      config = {
        permittedInsecurePackages = [
          "electron-17.4.1"
          "electron-19.1.9"
          "electron-21.4.0"
          "electron-15.5.2"
          "electron-24.8.6"
          "electron-25.9.0"
          "python-2.7.18.7"
        ];
        allowUnfree = true;
      };
    };
  };
}
