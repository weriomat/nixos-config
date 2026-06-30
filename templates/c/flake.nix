{
  description = "C/CPP flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    systems.url = "github:nix-systems/default";
    utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    {
      nixpkgs,
      utils,
      ...
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.ccache
            pkgs.clang-tools
            pkgs.cmake
            pkgs.ninja
            pkgs.gnumake
            pkgs.codespell
            pkgs.cppcheck
            pkgs.gbenchmark
            pkgs.gdb
            pkgs.gtest
            pkgs.lcov
          ];
        };
      }
    );
}
