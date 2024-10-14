# This file defines overlays
{inputs, ...}: rec {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };

  borg = _final: prev: {
    borgmatic = prev.borgmatic.overrideAttrs (old: {patches = (old.patches or []) ++ [./borgmatic.patch];});
  };
}
