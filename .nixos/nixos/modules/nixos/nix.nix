{ inputs, outputs, ... }: {
  nix.nixPath =
    [ "nixpkgs=${inputs.nixpkgs}" "unstable=${inputs.nixpkgs-unstable}" ];

  # enable local registry for better search
  # https://discourse.nixos.org/t/local-flake-based-nix-search-nix-run-and-nix-shell/13433/12
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  nix.settings = {
    sandbox = true;
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };
  # TODO: set trusted public keys, trusted-subsituters

  # Nix shouldn't build in /tmp since it might compete for RAM for large builds and will quickly exhaust the 5 G limit
  # systemd.services.nix-daemon.environment.TMPDIR = "/nix/tmp";
  # systemd.tmpfiles.rules = [ "d /nix/tmp 0755 root root 1d" ];
  # Allow some unfree packages
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      # outputs.overlays.additions_packages
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

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
        "electron-21.4.0"
        "electron-15.5.2"
        "electron-24.8.6"
      ];
      allowUnfree = true;
      # allowUnfreePredicate = (pkg: true);
      # allowBroken = true;
    };
  };
  # overlays = [
  # inputs.rust-overlay.overlays.default
  # (self: super: rec {
  # kitty-themes = unstable.kitty-themes;
  # See and https://nixos.wiki/wiki/Overlays
  # inherit inputs cobaltPackages;

  # See https://nixos.wiki/wiki/Cheatsheet#Customizing_Packages
  # unstable = (import inputs.nixpkgs-unstable {
  # config = config.nixpkgs.config;
  # system = "x86_64-linux";
  # });

  # })
  # ];
  # };

}
