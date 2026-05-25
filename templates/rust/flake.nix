{
  description = "Rust flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      rust-overlay,
      ...
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlays.default ];
        };

        # this includes: rustc, rust-analyzer, clippy, cargo, rustfmt, rustsrc, rust-docs
        rust-bin = pkgs.rust-bin.stable.latest.default;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            rust-bin

            # rust tooling
            pkgs.cargo-wizard # wizard for perf Cargo.toml
            pkgs.cargo-nextest
            pkgs.cargo-flamegraph
            pkgs.cargo-deny
            pkgs.cargo-edit
            pkgs.cargo-watch
            pkgs.rustup
            pkgs.mold

            # other tooling
            pkgs.reuse
            pkgs.hyperfine

            # in case we need to use ssl/tls
            pkgs.pkg-config
            pkgs.openssl
          ];
        };
      }
    );
}
