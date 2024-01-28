# This file defines overlays
{ inputs, pkgs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };
  # additions_packages = final: _prev: {
  # addition = import ../pkgs { pkgs = final; };
  # };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev:
    {
      # steam = prev.steam.override {
      #   extraProfile = "export STEAM_EXTRA_COMPAT_TOOLS_PATHS='${
      #       inputs.nix-gaming.packages.${pkgs.system}.proton-ge
      #     }'";
      # };
      # example = prev.example.overrideAttrs (oldAttrs: rec {
      # ...
      # });
    };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
      # config = config.nixpkgs.config;
    };
  };
}
